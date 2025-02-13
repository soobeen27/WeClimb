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

protocol UploadInput {
    var mediaSelection: Observable<[PHPickerResult]> { get }
    var gradeSelection: Observable<(Int, String)> { get }
    var holdSelection: Observable<(Int, String?)> { get }
    var selectedMediaIndex: Observable<Int> { get }
}

protocol UploadOutput {
    var mediaItems: Observable<[MediaUploadData]> { get }
    var alertTrigger: Observable<Void> { get }
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
        let alertTrigger: Observable<Void>
    }
    
    private let disposeBag = DisposeBag()
    
    private let mediaItemsRelay = BehaviorRelay<[PHPickerResult]>(value: [])
    private let alertTriggerRelay = PublishRelay<Void>()
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
                
                let convertedGrade = LHColors.fromKoreanFull(newGrade).toEng()
                
                if mediaList[index].grade == convertedGrade { return }
                
                var updatedMedia = mediaList[index]
                updatedMedia.grade = convertedGrade
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
                
                let convertedHold = LHColors.fromKoreanFull(newHold).toHoldEng()
                
                if mediaList[index].hold == convertedHold { return }
                
                var updatedMedia = mediaList[index]
                updatedMedia.hold = convertedHold
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
                    
                    let duration = self.getVideoDuration(url: tempVideoURL)
                    if duration > 120 {
                        DispatchQueue.main.async {
                            self.mediaUploadDataRelay.accept([])
                            self.alertTriggerRelay.accept(())
                        }
                        group.leave()
                        return
                    }
                    
                    let attributes = try? FileManager.default.attributesOfItem(atPath: url.path)
                    let creationDate = attributes?[.creationDate] as? Date
                    
                    models[index] = MediaUploadData(
                        url: tempVideoURL,
                        hold: nil,
                        grade: "",
                        thumbnailURL: tempVideoURL,
                        capturedAt: creationDate
                    )
                    group.leave()
                }
            } else if mediaItem.itemProvider.hasItemConformingToTypeIdentifier(UTType.image.identifier) {
                mediaItem.itemProvider.loadFileRepresentation(forTypeIdentifier: UTType.image.identifier) { [self] (url, error) in
                    guard let url = url, error == nil else {
                        print("이미지 로드 실패: \(error?.localizedDescription ?? "알 수 없는 오류")")
                        group.leave()
                        return
                    }
                    
                    let capturedAt = getCapturedDate(from: url)
                    
                    let tempImageURL = FileManager.default.temporaryDirectory
                        .appendingPathComponent(UUID().uuidString)
                        .appendingPathExtension("jpg")
                    
                    do {
                        try FileManager.default.copyItem(at: url, to: tempImageURL)
                        
                        models[index] = MediaUploadData(
                            url: tempImageURL,
                            hold: nil,
                            grade: "",
                            thumbnailURL: tempImageURL,
                            capturedAt: capturedAt
                        )
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
    
    func getCapturedDate(from imageURL: URL) -> Date? {
        guard let imageSource = CGImageSourceCreateWithURL(imageURL as CFURL, nil),
              let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [CFString: Any] else {
            print("이미지 메타데이터를 가져올 수 없음.")
            return nil
        }
        
        if let exifData = imageProperties[kCGImagePropertyExifDictionary] as? [CFString: Any],
           let dateString = exifData[kCGImagePropertyExifDateTimeOriginal] as? String {
            return parseExifDate(dateString)
        }
        
        if let tiffData = imageProperties[kCGImagePropertyTIFFDictionary] as? [CFString: Any],
           let dateString = tiffData[kCGImagePropertyTIFFDateTime] as? String {
            return parseExifDate(dateString)
        }
        
        let attributes = try? FileManager.default.attributesOfItem(atPath: imageURL.path)
        let creationDate = attributes?[.creationDate] as? Date
        
        return creationDate
    }
    
    private func parseExifDate(_ dateString: String) -> Date? {
        let possibleFormats = [
            "yyyy:MM:dd HH:mm:ss",
            "yyyy-MM-dd'T'HH:mm:ssZ",
            "yyyy:MM:dd HH:mm:ss.SSS",
            "EEE MMM dd HH:mm:ss Z yyyy"
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
    func getVideoDuration(url: URL) -> Double {
        let asset = AVAsset(url: url)
        return CMTimeGetSeconds(asset.duration)
    }
}
