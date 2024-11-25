//
//  SFFeedCell.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/26/24.
//

import AVKit
import AVFoundation
import UIKit

import SnapKit
import RxSwift
import RxCocoa
import Kingfisher

class SFFeedCell: UICollectionViewCell {
    var player: AVPlayer?
    var playerLayer: AVPlayerLayer?
    var stopToggle = false
    
    private var firstVideo = true
    
    var rePlay = true
    
    var disposeBag = DisposeBag()
    
    lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: contentView.bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    private lazy var gymImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var gradeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.clipsToBounds = true
        imageView.contentMode = .center
        imageView.backgroundColor = .white
        imageView.layer.cornerRadius = 16
        return imageView
    }()
    
    private lazy var gymGradeStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [gymImageView, gradeImageView])
        stackView.axis = .horizontal
        stackView.spacing = 8
        return stackView
    }()
    
    var gymTap = PublishRelay<String?>()
    var gradeTap = PublishRelay<Media?>()
    
    var media: Media?
    
    var completedLoad = PublishSubject<Void>()
    
    private var playerIsSetUp = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.overrideUserInterfaceStyle = .dark
        contentView.backgroundColor = UIColor(hex: "#0B1013")
//        contentView.backgroundColor = .clear
//        contentView.addSubview(playButton)
//        playButton.snp.makeConstraints {
//            $0.center.equalTo(contentView)
//            $0.size.equalTo(75)
//        }
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(toggleVideoPlayback))
        self.addGestureRecognizer(tapGesture)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if let playerLayer = playerLayer {
            playerLayer.removeFromSuperlayer()
        }
        imageView.removeFromSuperview()
        NotificationCenter.default.removeObserver(self)
        resetPlayer()
        gradeImageView.image = nil
        gradeImageView.backgroundColor = nil
        gymImageView.image = nil
        imageView.image = nil
        imageView.backgroundColor = .clear
        media = nil
        setLayout()
        disposeBag = DisposeBag()
//        imageViewGestureBind()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        playerLayer?.frame = self.contentView.bounds
    }
    
    func configure(with media: Media, viewModel: MainFeedVM) {
        guard let url = URL(string: media.url) else { return }
        imageView.image = nil
        resetPlayer()
        self.media = media
        
        if url.pathExtension == "mp4" {
            loadVideo(from: media)
        } else {
            loadImage(from: url)
        }
        gymGradeImageBind(media: media)
        imageViewGestureBind()
    }
    
    private func loadImage(from url: URL) {
        contentView.addSubview(imageView)
        contentView.sendSubviewToBack(imageView)
        imageView.kf.setImage(with: url)
        
        imageView.isUserInteractionEnabled = false
    }
    
    private func loadVideo(from media: Media) {
        guard let videoURL = URL(string: media.url) else { return }
        resetPlayer()
        let cacheKey = "\(media.mediaUID).mp4" // 예: userUID 또는 postID
        
        streamAndCacheVideo(with: videoURL, cacheKey: cacheKey) { [weak self] cachedURL in
            guard let self = self, let cachedURL = cachedURL else {
                print("비디오 다운로드 또는 캐싱 실패")
                return
            }
            
            DispatchQueue.main.async {
                self.setupPlayer(with: cachedURL)
                if self.firstVideo {
                    self.firstVideo = false
                    self.completedLoad.onNext(())
                    print("데이터 로드 완료")
                }
            }
        }
    }
    
    private func setupPlayer(with url: URL) {
        let asset = AVAsset(url: url)
        player = AVPlayer(url: url)
        playerLayer = AVPlayerLayer(player: player)
        playerLayer?.frame = self.contentView.bounds
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
            if width >= height {
                self.playerLayer?.videoGravity = .resizeAspect
            } else {
                self.playerLayer?.videoGravity = .resizeAspectFill
            }
            CATransaction.commit()
        }
        
        if let playerLayer = playerLayer {
            //            contentView.layer.insertSublayer(playerLayer, below: gymGradeStackView.layer)
            contentView.layer.insertSublayer(playerLayer, at: 0)
        }
        
        gymGradeImageBringToFront()
    }
    
    @objc func reStartVideo() {
        guard let player = player else { return }
        if rePlay {
            print("restartVideo 호출됨")
            playVideo(reStart: true)
            print("또 리플레이 할거임")
        } else {
            stopVideo()
        }
    }
    
    @objc func toggleVideoPlayback() {
        if stopToggle {
            stopVideo()
            self.rePlay = false
            print("스탑 비디오")
        } else {
            playVideo(reStart: false)
            self.rePlay = true
            print("플레이 비디오")
        }
    }
    
    func stopVideo() {
        print("Stop")
        player?.pause()
        self.rePlay = false
        stopToggle = false
    }
    
    func playVideo(reStart: Bool) {
        guard let player = player else { return }
        setNotifications()
        print("Play")
        if reStart {
            player.seek(to: .zero)
            player.play()
            print("처음으로 돌아갈거에요")
        } else {
            player.play()
        }
        
        stopToggle = true
    }
    
    private func resetPlayer() {
        player?.pause()
        playerLayer?.removeFromSuperlayer()
        player = nil
        playerLayer = nil
    }
    
    private func setNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(reStartVideo), name: .AVPlayerItemDidPlayToEndTime, object: player?.currentItem)
        print("AVPlayerItemDidPlayToEndTime 알림 등록")
    }
    
    func streamAndCacheVideo(with url: URL, cacheKey: String, completion: @escaping (URL?) -> Void) {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            print("캐시 디렉토리를 찾을 수 없음.")
            completion(nil)
            return
        }
        
        let cachedFileURL = cacheDirectory.appendingPathComponent(cacheKey)
        
        if FileManager.default.fileExists(atPath: cachedFileURL.path) {
            print("이미 캐시된 파일이 존재: \(cachedFileURL.path)")
            completion(cachedFileURL)
            return
        }
        
        let task = URLSession.shared.downloadTask(with: url) { (location, response, error) in
            if let error = error {
                print("Error downloading video: \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let location = location else {
                print("다운로드된 파일이 없습니다.")
                completion(nil)
                return
            }
            
            print("다운로드 완료, 파일 위치: \(location.path)")
            
            do {
                try FileManager.default.moveItem(at: location, to: cachedFileURL)
                print("파일을 캐시 디렉토리로 이동 완료: \(cachedFileURL.path)")
                completion(cachedFileURL)
            } catch {
                print("파일 이동 중 오류 발생: \(error.localizedDescription)")
                completion(nil)
            }
        }
        
        print("다운로드 시작: \(url.absoluteString)")
        task.resume()
    }
    
    func imageViewGestureBind() {
        let gymImageTapGesture = UITapGestureRecognizer()
        gymImageView.isUserInteractionEnabled = true
        gymImageView.addGestureRecognizer(gymImageTapGesture)
        gymImageTapGesture.rx.event
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .map { [weak self] _ in
//                print(self?.media?.gym)
                return self?.media?.gym
            }
            .bind(to: gymTap)
            .disposed(by: disposeBag)
        
        let gradeImageTapGesture = UITapGestureRecognizer()
        gradeImageView.isUserInteractionEnabled = true
        gradeImageView.addGestureRecognizer(gradeImageTapGesture)
        gradeImageTapGesture.rx.event
            .throttle(.milliseconds(1000), scheduler: MainScheduler.instance)
            .map { [weak self] _ in
//                print(self?.media?.gym)
                return self?.media
            }
            .bind(to: gradeTap)
            .disposed(by: disposeBag)
    }
    
    func gymGradeImageBind(media: Media) {
        guard let gymName = media.gym else { return }
        FirebaseManager.shared.gymInfo(from: gymName) { [weak self] gym in
            guard let self = self else { return }
            if let gym = gym, let gymImageString = gym.profileImage {
                FirebaseManager.shared.loadImage(from: gymImageString, into: self.gymImageView)
            }
        }
        
        if let hold = media.hold?.replacingOccurrences(of: "hold", with: "").lowercased(),
           let holdEnum = Hold(rawValue: hold),
           let holdImage = UIImage(named: holdEnum.string) {
            let resizedImage = holdImage.resize(targetSize: CGSize(width: 35, height: 35))
            gradeImageView.image = resizedImage
        }
        
        if let grade = media.grade {
            let gradeColorInfo = grade.colorInfo
            gradeImageView.backgroundColor = gradeColorInfo.color
        }
    }
    
    func gymGradeImageBringToFront() {
        contentView.bringSubviewToFront(gradeImageView)
        contentView.bringSubviewToFront(gymImageView)
    }
    
    func setLayout() {
//        [
//            gymImageView
//        ].forEach {
//            self.contentView.addSubview($0)
//        }
        [
            gymGradeStackView
        ].forEach {
            self.contentView.addSubview($0)
        }
        gymImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
//            $0.bottom.equalToSuperview().offset(-16)
//            $0.trailing.equalToSuperview().offset(-16)
        }
        gradeImageView.snp.makeConstraints {
            $0.size.equalTo(CGSize(width: 50, height: 50))
        }
        gymGradeStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-16)
            $0.trailing.equalToSuperview().offset(-16)
        }
    }
}
