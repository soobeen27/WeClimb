//
//  PostVideoView.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/21/25.
//

import AVKit
import AVFoundation
import UIKit

import RxSwift
import RxCocoa
import Kingfisher

class PostVideoView: UIView {
    
    private var player: AVQueuePlayer?
    
    private var playerLooper: AVPlayerLooper?
    
    private var playerLayer: AVPlayerLayer?
    
    private var disposeBag = DisposeBag()
    
    private let loadComplete = BehaviorSubject<Bool>.init(value: false)
    
    private var isPlaying: Bool = false
            
    var videoInfo: (url: URL, uid: String)? {
        didSet {
            loadVideo()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func handleTap() {
        if isPlaying {
            VideoManager.shared.stopVideo()
            isPlaying.toggle()
        } else {
            guard let player else { return }
            VideoManager.shared.playVideo(player: player)
            isPlaying.toggle()
        }
    }
    
    private func loadVideo() {
        guard let videoInfo else { return }
        
        let cacheKey = "\(videoInfo.uid).mp4"
        
        streamAndCacheVideo(with: videoInfo.url, cacheKey: cacheKey)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] cachedURL in
                guard let self else { return }
                self.setupPlayer(with: cachedURL)
                self.loadComplete.onNext(true)
            }, onError: { error in
                print("StreamAndCacheVideoError: \(error)")
            })
            .disposed(by: disposeBag)
    }
    
    func resetToDefaultState() {
        videoInfo = nil
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
        loadComplete.onNext(false)
        disposeBag = DisposeBag()
    }
    
    private func setupPlayer(with url: URL) {
        let asset = AVAsset(url: url)
        let playerItem = AVPlayerItem(asset: asset)
        player = AVQueuePlayer()
        guard let player else { return }
        playerLooper = AVPlayerLooper(player: player, templateItem: playerItem)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.bounds
        playerLayer?.opacity = 1.0
        playerLayer?.backgroundColor = UIColor(hex: "#0B1013").cgColor
        guard let track = asset.tracks(withMediaType: .video).first else {
            print("비디오 트랙을 찾을 수 없습니다.")
            return
        }
        
        let size = track.naturalSize.applying(track.preferredTransform)
        let width = abs(size.width)
        let height = abs(size.height)
        let ratio = height / width
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            CATransaction.begin()
            CATransaction.setDisableActions(true)
            if ratio < 1.4 {
                self.playerLayer?.videoGravity = .resizeAspect
            } else {
                self.playerLayer?.videoGravity = .resizeAspectFill
            }
            CATransaction.commit()
        }
        
        if let playerLayer = playerLayer {
            self.layer.insertSublayer(playerLayer, at: 0)
        }
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.bounds
    }
    
    private func streamAndCacheVideo(with url: URL, cacheKey: String) -> Observable<URL> {
        return Observable.create { observer in
            guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
                print("캐시 디렉토리를 찾을 수 없음.")
                observer.onError(VideoError.cacheDirectory)
                return Disposables.create()
            }
            
            let cachedFileURL = cacheDirectory.appendingPathComponent(cacheKey)
            
            if FileManager.default.fileExists(atPath: cachedFileURL.path) {
                observer.onNext(cachedFileURL)
                return Disposables.create()
            }
            
            let task = URLSession.shared.downloadTask(with: url) { (location, response, error) in
                if let error = error {
                    print("Error downloading video: \(error.localizedDescription)")
                    observer.onError(error)
                    return
                }
                
                guard let location = location else {
                    print("다운로드된 파일이 없습니다.")
                    observer.onError(VideoError.noDownloadedFile)
                    return
                }
                
                do {
                    try FileManager.default.moveItem(at: location, to: cachedFileURL)
                    observer.onNext(cachedFileURL)
                } catch {
                    print("파일 이동 중 오류 발생: \(error.localizedDescription)")
                    observer.onError(error)
                }
            }
            task.resume()
            return Disposables.create()
        }
    }
    
    func playVideo() {
        loadComplete
            .asDriver(onErrorDriveWith: .empty())
            .drive(onNext: { [weak self] success in
                if success {
                    guard let self, let player = self.player else { return }
                    VideoManager.shared.playVideo(player: player)
                    self.isPlaying = true
                }
            })
            .disposed(by: disposeBag)
    }
}

enum VideoError: Error {
    case cacheDirectory
    case noDownloadedFile
    case fileMove
    case downloadFailed
    
    var description: String {
        switch self {
        case .cacheDirectory:
            return "캐시 디렉터리 못찾음"
        case .noDownloadedFile:
            return "다운로드된 파일 X"
        case .fileMove:
            return "파일 이동중 에러"
        case .downloadFailed:
            return "다운로드 실패"
        }
    }
}
