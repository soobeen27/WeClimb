//
//  UploadVM.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import AVKit
import PhotosUI

import FirebaseAuth
import FirebaseStorage
import LightCompressor
import RxRelay
import RxSwift
import RxCocoa

class UploadVM {
    private let disposeBag = DisposeBag()
    
    var mediaItems = BehaviorRelay<[PHPickerResult]>(value: [])
    var feedRelay = BehaviorRelay<[FeedCellModel]>(value: [])
    var cellData = BehaviorRelay(value: [FeedCellModel]())
    
    let showAlert = PublishRelay<Void>()
    let isLoading = BehaviorRelay<Bool>(value: false)
    
    var pageChanged = BehaviorRelay<Int>(value: 0)
    var currentPageIndex = 0
    
    var shouldUpdateUI: Bool = true
    
    var gymRelay = BehaviorRelay<Gym?>(value: nil)
    
    var gradeRelayArray: BehaviorRelay<[String]> = BehaviorRelay(value: [])
    
    var selectedGrade = BehaviorRelay<String?>(value: nil)
    var selectedHold = BehaviorRelay<Hold?>(value: nil)
    
}

extension UploadVM {
    // MARK: - 각 미디어마다 선택한 옵션 저장 YJ
    func optionSelected(optionText: String, buttonType: String) {
        print("옵션 선택됨: \(optionText), 현재 페이지 인덱스: \(currentPageIndex)")
        
        var currentFeedItems = feedRelay.value
        var feedItem = currentFeedItems[currentPageIndex]
        
        if buttonType == "grade" {
            feedItem.grade = optionText
        } else if buttonType == "hold" {
            feedItem.hold = optionText
        }
        
        currentFeedItems[currentPageIndex] = feedItem
        print("currentFeedItems: \(currentFeedItems)")
        shouldUpdateUI = false  // UI업데이트 X
        feedRelay.accept(currentFeedItems)
        print("진짜 확인용: \(feedRelay.value)")
    }
    
    // MARK: - 페이지 변경 이벤트 방출 YJ
    func pageChanged(to pageIndex: Int) {
        pageChanged.accept(pageIndex)
        print("페이지 확인: \(pageChanged.value)")
        
        currentPageIndex = pageIndex
    }
    
    func updateGymData(_ gym: Gym) {
        self.gymRelay.accept(gym)
        
        let gradeParts = gym.grade.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        gradeRelayArray.accept(gradeParts)
    }
    
    func bindGymDataToMedia() {
        gymRelay
            .compactMap { $0 }
            .subscribe(onNext: { [weak self] gym in
                guard let self else { return }
                
                var updatedFeedItems = self.feedRelay.value
                
                updatedFeedItems = updatedFeedItems.map { item in
                    var updatedItem = item
                    updatedItem.gym = gym.gymName
                    return updatedItem
                }
                self.feedRelay.accept(updatedFeedItems)
            })
            .disposed(by: disposeBag)
    }
}

extension UploadVM {
    func setMedia() {
        isLoading.accept(true) // 로딩 시작
        
        let group = DispatchGroup() // 비동기 작업을 추적하기 위한 그룹
        var models = [FeedCellModel?](repeating: nil, count: mediaItems.value.count)
        
        // 암장 이름을 미리 가져옵니다.
        guard let gymName = gymRelay.value?.gymName else {
            print("암장 이름이 설정되지 않았습니다.")
            return
        }
        
        mediaItems.value.enumerated().forEach { (index, mediaItem) in
            group.enter()   // 비동기 작업 시작 알려줌
            
            if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] (url, error) in
                    guard let self = self, let url = url, error == nil else {
                        print("비디오 파일 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }
                    
                    // 임시 디렉토리로 파일 복사
                    let tempVideoURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mov")
                    do {
                        try FileManager.default.copyItem(at: url, to: tempVideoURL)
                        print("비디오 파일이 임시 디렉토리에 저장됨: \(tempVideoURL.path)")
                    } catch {
                        print("비디오 파일 복사 실패: \(error.localizedDescription)")
                        group.leave()
                        return
                    }
                    
                    // AVAsset으로 비디오 상태 확인
                    let asset = AVAsset(url: tempVideoURL)
                    let isPlayable = asset.isPlayable
                    let hasProtectedContent = asset.hasProtectedContent
                    print("비디오 파일 상태: isPlayable=\(isPlayable), hasProtectedContent=\(hasProtectedContent)")
                    
                    // 파일이 재생 가능한 상태인지 확인
                    guard isPlayable else {
                        print("비디오 파일이 재생 불가능 상태입니다.")
                        group.leave()
                        return
                    }
                    
                    // 비디오 항목에 암장 이름 추가
                    Task {
                        let durationInSeconds = await self.checkVideoDuration(url: tempVideoURL)
                        if durationInSeconds > 60 {
                            self.showAlert.accept(())
                            print("비디오가 너무 깁니다. 알람을 보냅니다.")
                            group.leave()
                            return
                        } else {
                            models[index] = FeedCellModel(
                                imageURL: nil,
                                videoURL: tempVideoURL,
                                grade: self.selectedGrade.value, hold: self.selectedHold.value?.koreanHold, gym: gymName
                            )
                        }
                        group.leave()
                    }
                }
            } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                mediaItem.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                    guard let uiImage = image as? UIImage else {
                        print("이미지 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }
                    
                    // 임시 디렉토리에 이미지 저장
                    let tempImageURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
                    
                    if let data = uiImage.jpegData(compressionQuality: 1) {
                        do {
                            try data.write(to: tempImageURL)
                            models[index] = FeedCellModel(
                                imageURL: tempImageURL,
                                videoURL: nil,
                                grade: self.selectedGrade.value, hold: self.selectedHold.value?.koreanHold, gym: gymName
                            )
                        } catch {
                            print("이미지 저장 실패: \(error.localizedDescription)")
                        }
                    }
                    group.leave()
                }
            }
        }
        
        // 비동기 작업이 모두 완료되었을 때 호출되는 클로저
        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            self.isLoading.accept(false) // 로딩 종료
            
            if !models.isEmpty {
                self.feedRelay.accept(models.compactMap { $0 })
                self.cellData.accept(models.compactMap { $0 })
            }
        }
    }
    
    // MARK: - 비디오 길이를 체크하는 메서드
    func checkVideoDuration(url: URL) async -> Double {
        print("비디오 URL: \(url)")
        let asset = AVAsset(url: url)
        
        do {
            // duration 속성을 await으로 로드
            let duration: CMTime = try await asset.load(.duration)
            // CMTime 객체를 초 단위로 변환
            let durationInSeconds = CMTimeGetSeconds(duration)
            print("비디오 길이: \(durationInSeconds)초")
            return durationInSeconds
        } catch {
            print("비디오 길이 로드 실패: \(error.localizedDescription)")
            return 0 // 실패 시 0초 반환
        }
    }
}

extension UploadVM {
    func upload(media: [(url: URL, hold: String?, grade: String?)], caption: String?, gym: String?, thumbnailURL: String) -> Driver<Void> {
        return Observable.create { observer in
            let dispatchGroup = DispatchGroup()
            var uploadMedia: [(url: URL, hold: String?, grade: String?, thumbnailURL: String?)] = []
            
            for item in media {
                dispatchGroup.enter()
                
                if item.url.pathExtension == "jpg" || item.url.pathExtension == "png" {
                    // 이미지인 경우
                    if let image = UIImage(contentsOfFile: item.url.path) {
                        if let compressedData = image.jpegData(compressionQuality: 0.3) {
                            let tempImageURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("jpg")
                            do {
                                try compressedData.write(to: tempImageURL)
                                // 이미지 URL을 그대로 썸네일 URL로 지정
                                uploadMedia.append((url: tempImageURL, hold: item.hold, grade: item.grade, thumbnailURL: item.url.absoluteString))
                            } catch {
                                print("이미지 저장 실패: \(error.localizedDescription)")
                            }
                        }
                    }
                    dispatchGroup.leave()
                } else {
                    // 비디오인 경우
                    self.compressVideo(inputURL: item.url) { [weak self] compressedURL in
                        guard let self = self, let compressedURL = compressedURL else {
                            dispatchGroup.leave()
                            return
                        }
                        
                        // 비디오 썸네일 생성
                        self.getThumbnailImage(from: compressedURL) { thumbnailURL in
                            uploadMedia.append((url: compressedURL, hold: item.hold, grade: item.grade, thumbnailURL: thumbnailURL))
                            dispatchGroup.leave()
                        }
                    }
                }
            }
            
            dispatchGroup.notify(queue: .main) {
                Task { [uploadMedia, caption, gym] in
                    let myUID = FirebaseManager.shared.currentUserUID()
                    await FirebaseManager.shared.uploadPost(myUID: myUID, media: uploadMedia, caption: caption, gym: gym, thumbnail: thumbnailURL)
                    
                    observer.onNext(())
                    observer.onCompleted()
                }
            }
            
            return Disposables.create()
        }
        .asDriver(onErrorDriveWith: Driver.empty())
    }
    
    // MARK: - 비디오를 압축하는 메서드
    func compressVideo(inputURL: URL, completion: @escaping (URL?) -> Void) {
        
        let videoCompressor = LightCompressor()
        
        // 압축 작업 설정
        _ = videoCompressor.compressVideo(videos: [
            .init(
                source: inputURL,
                destination: FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString).appendingPathExtension("mp4"),
                configuration: .init(
                    quality: VideoQuality.medium, // 비디오 품질
                    videoBitrateInMbps: 2, // 비트레이트
                    disableAudio: false, // 오디오
                    keepOriginalResolution: false, // 원본 해상도 변경
                    videoSize: nil
                )
            )
        ],
        progressQueue: .main,
        progressHandler: { progress in
        },
                                          completion: { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .onSuccess(_, let path):
                print("비디오 압축 완료: \(path)")
                completion(path)
            case .onStart:
                print("압축 시작")
            case .onFailure(_, let error):
                print("비디오 압축 실패: \(error.localizedDescription)")
                completion(nil)
            case .onCancelled:
                print("비디오 압축 취소됨")
                completion(nil)
            }
        })
    }
    
    func getThumbnailImage(from videoURL: URL, completion: @escaping (String?) -> Void) {
        print("썸네일 이미지 생성 중")
        
        let asset = AVAsset(url: videoURL)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        
        let time = CMTime(seconds: 1, preferredTimescale: 600) // 1초에서 썸네일 생성
        imageGenerator.requestedTimeToleranceBefore = .zero
        imageGenerator.requestedTimeToleranceAfter = .zero
        imageGenerator.appliesPreferredTrackTransform = true // 방향
        
        imageGenerator.generateCGImagesAsynchronously(forTimes: [NSValue(time: time)]) { _, image, _, result, error in
            if let error = error {
                print("썸네일 생성 중 오류 발생: \(error.localizedDescription)")
                completion(nil)
            } else if let image = image {
                print("썸네일이 성공적으로 생성.")
                let uiImage = UIImage(cgImage: image)
                
                if let thumbnailData = uiImage.jpegData(compressionQuality: 0.5) {
                    guard let userUUID = Auth.auth().currentUser?.uid else {
                        print("사용자 UUID를 가져올 수 없습니다.")
                        completion(nil)
                        return
                    }
                    print("userUUID 확인용: \(userUUID)")
                    self.uploadThumbnailToFirebase(thumbnailData: thumbnailData, userUUID: userUUID) { thumbnailURL in
                        completion(thumbnailURL)
                    }
                } else {
                    completion(nil)
                }
            } else {
                print("생성된 이미지가 없음.")
                completion(nil)
            }
        }
    }
    
    // Firebase에 썸네일 업로드
    private func uploadThumbnailToFirebase(thumbnailData: Data, userUUID: String, completion: @escaping (String?) -> Void) {
        let storageRef = Storage.storage().reference().child("users/\(userUUID)/thumbnails/\(UUID().uuidString).jpg")

        storageRef.putData(thumbnailData, metadata: nil) { metadata, error in
            if let error = error {
                print("썸네일 업로드 실패: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            // 업로드 완료 후 다운로드 URL 요청
            storageRef.downloadURL { url, error in
                if let error = error {
                    print("썸네일 URL 가져오기 실패: \(error.localizedDescription)")
                    completion(nil)
                } else {
                    completion(url?.absoluteString) // URL 반환
                }
            }
        }
    }
}
