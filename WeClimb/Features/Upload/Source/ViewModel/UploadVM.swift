//
//  UploadVM.swift
//  WeClimb
//
//  Created by 강유정 on 2/3/25.
//

import RxSwift
import RxRelay
import PhotosUI
import ImageIO
import MobileCoreServices
import AVFoundation

protocol UploadInput {
    var mediaSelection: Observable<[PHPickerResult]> { get }
    var gradeSelection: Observable<(Int, String)> { get }
    var holdSelection: Observable<(Int, String?)> { get }
    var selectedMediaIndex: Observable<Int> { get }
}

protocol UploadOutput {
    var mediaItems: Observable<[MediaUploadData]> { get }
    var alertTrigger: Observable<(String, String)> { get }
}

protocol UploadVM {
    var mediaUploadDataRelay: BehaviorRelay<[MediaUploadData]> { get }
    func transform(input: UploadInput) -> UploadOutput
}

final class UploadVMImpl : UploadVM {
    
    struct Input: UploadInput {
        let mediaSelection: Observable<[PHPickerResult]>
        let gradeSelection: Observable<(Int, String)>
        let holdSelection: Observable<(Int, String?)>
        let selectedMediaIndex: Observable<Int>
    }
    
    struct Output: UploadOutput {
        let mediaItems: Observable<[MediaUploadData]>
        let alertTrigger: Observable<(String, String)>
    }
    
    private let disposeBag = DisposeBag()
    
    private let mediaItemsRelay = BehaviorRelay<[PHPickerResult]>(value: [])
    private let alertTriggerRelay = PublishRelay<(String, String)>()
    var mediaUploadDataRelay = BehaviorRelay<[MediaUploadData]>(value: [])
    
    func transform(input: UploadInput) -> UploadOutput {
        
        input.mediaSelection
            .subscribe(onNext: { [weak self] mediaItems in
                self?.mediaItemsRelay.accept(mediaItems)
                self?.processMediaItems(mediaItems: mediaItems)
            })
            .disposed(by: disposeBag)
        
        input.gradeSelection
            .subscribe(onNext: { [weak self] (index, newGrade) in
                guard let self = self else { return }

                var mediaList = self.mediaUploadDataRelay.value
                guard index >= 0, index < mediaList.count else { return }

                if mediaList[index].grade == newGrade { return }

                var updatedMedia = mediaList[index]
                updatedMedia.grade = newGrade
                mediaList[index] = updatedMedia

                self.mediaUploadDataRelay.accept(mediaList)
            })
            .disposed(by: disposeBag)

        input.holdSelection
            .subscribe(onNext: { [weak self] (index, newHold) in
                guard let self = self else { return }
                guard let newHold = newHold else { return }

                var mediaList = self.mediaUploadDataRelay.value
                guard index >= 0, index < mediaList.count else { return }

                if mediaList[index].hold == newHold { return }

                var updatedMedia = mediaList[index]
                updatedMedia.hold = newHold
                mediaList[index] = updatedMedia

                self.mediaUploadDataRelay.accept(mediaList)
            })
            .disposed(by: disposeBag)
        
        return Output(
            mediaItems: mediaUploadDataRelay.asObservable(),
            alertTrigger: alertTriggerRelay.asObservable()
        )
    }
    
    private func processMediaItems(mediaItems: [PHPickerResult]) {
        let group = DispatchGroup()
        var models = [MediaUploadData?](repeating: nil, count: mediaItems.count)
        let syncQueue = DispatchQueue(label: "com.upload.syncQueue")

        mediaItems.enumerated().forEach { index, mediaItem in
            group.enter()

            if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.movie.identifier) {
                mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.movie.identifier) { [weak self] (url, error) in
                    guard let self = self, let url = url, error == nil else {
                        print("비디오 파일 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }

                    let tempVideoURL = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension("mp4")

                    do {
                        try FileManager.default.copyItem(at: url, to: tempVideoURL)
                        print("비디오 파일이 임시 디렉토리에 저장됨: \(tempVideoURL.path)")
                    } catch {
                        print("비디오 파일 복사 실패: \(error.localizedDescription)")
                        group.leave()
                        return
                    }

                    Task {
                        let duration = await self.getVideoDuration(url: tempVideoURL)
                        if duration > 120 {
                            await MainActor.run {
                                self.mediaUploadDataRelay.accept([])
                                self.alertTriggerRelay.accept(("영상 길이 초과", "2분 이내의 영상을 업로드해주세요."))

                            }
                            return
                        }

                        let capturedDate = await self.getVideoMetadataCapturedDate(from: tempVideoURL)

                        syncQueue.sync {
                            models[index] = MediaUploadData(
                                url: tempVideoURL,
                                hold: nil,
                                grade: "",
                                thumbnailURL: tempVideoURL,
                                capturedDate: capturedDate
                            )
                        }

                        group.leave()
                    }
                }
            } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { [weak self] (url, error) in
                    guard let self = self, let url = url, error == nil else {
                        print("이미지 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }

                    let capturedAt = self.getImageMetadataCapturedDate(from: url)

                    let tempImageURL = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension("jpg")

                    do {
                        try FileManager.default.copyItem(at: url, to: tempImageURL)
                        print("이미지 저장 완료: \(tempImageURL.path)")

                        syncQueue.sync {
                            models[index] = MediaUploadData(
                                url: tempImageURL,
                                hold: nil,
                                grade: "",
                                thumbnailURL: tempImageURL,
                                capturedDate: capturedAt
                            )
                        }
                    } catch {
                        print("이미지 저장 실패: \(error.localizedDescription)")
                    }

                    group.leave()
                }
            } else {
                group.leave()
            }
        }

        group.notify(queue: .main) { [weak self] in
            guard let self = self else { return }
            let validModels = models.compactMap { $0 }
            self.mediaUploadDataRelay.accept(validModels)
        }
    }
}

extension UploadVMImpl {
    private func getImageMetadataCapturedDate(from imageURL: URL) -> Date? {
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil),
              let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else {
            return nil
        }
        
        if let exifData = imageProperties[kCGImagePropertyExifDictionary] as? [CFString: Any],
           let dateString = exifData[kCGImagePropertyExifDateTimeOriginal] as? String {
            return parseCapturedDate(dateString)
        }
        
        if let tiffData = imageProperties[kCGImagePropertyTIFFDictionary] as? [CFString: Any],
           let dateString = tiffData[kCGImagePropertyTIFFDateTime] as? String {
            return parseCapturedDate(dateString)
        }

        return nil
    }

    private func getVideoMetadataCapturedDate(from videoURL: URL) async -> Date? {
        let asset = AVAsset(url: videoURL)

        do {
            let metadata = try await asset.load(.metadata)
            for item in metadata {
                if item.commonKey == .commonKeyCreationDate {
                    if let dateString = try? await item.load(.value) as? String {
                        return parseCapturedDate(dateString)
                    }
                }
            }
        } catch {
            print("동영상 메타데이터 로드 실패: \(error.localizedDescription)")
        }
        return nil
    }

    private func parseCapturedDate(_ dateString: String) -> Date? {
        let possibleFormats = [
            "yyyy:MM:dd HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy:MM:dd HH:mm:ss.SSS",
            "EEE MMM dd HH:mm:ss Z yyyy",
            "yyyy-MM-dd HH:mm:ss"
        ]

        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(identifier: "UTC")

        for format in possibleFormats {
            formatter.dateFormat = format
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        return nil
    }
}

extension UploadVMImpl {
    func getVideoDuration(url: URL) async -> Double {
        let asset = AVAsset(url: url)
        do {
            let duration = try await asset.load(.duration)
            return CMTimeGetSeconds(duration)
        } catch {
            print("비디오 길이 로드 실패: \(error.localizedDescription)")
            return 0.0
        }
    }
}

