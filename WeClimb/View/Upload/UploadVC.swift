//
//  UploadVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//
import AVKit
import PhotosUI
import UIKit

import RxCocoa
import RxRelay
import RxSwift
import SnapKit

class UploadVC: UIViewController {
    
    var gymInfo: Gym?
    
    private let viewModel: UploadVM
    private let isClimbingVideo: Bool
    
    private let disposeBag = DisposeBag()
    private var feedView: FeedView?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        scroll.addSubview(contentView)
        return scroll
    }()
    
    let gymView = UploadOptionView(symbolImage: UIImage(systemName: "figure.climbing") ?? UIImage(), optionText: UploadNameSpace.gym, showSelectedLabel: true)
    private let settingView = UploadOptionView(symbolImage: UIImage(systemName: "flag") ?? UIImage(), optionText: UploadNameSpace.setting, showSelectedLabel: false)
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        [selectedMediaView, callPHPickerButton, gradeButton, holdButton, textView, gymView, settingView, loadingIndicator, gymView, gymLabel]
            .forEach {
                view.addSubview($0)
            }
        return view
    }()
    
    private lazy var selectedMediaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        view.addSubview(callPHPickerButton)
        return view
    }()
    
    private lazy var callPHPickerButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "photo.badge.plus")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.tintColor = .secondarySystemBackground
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.imageView?.contentMode = .scaleAspectFit
        button.contentHorizontalAlignment = .fill
        button.contentVerticalAlignment = .fill
        button.rx.tap
            .bind { [weak self] in
                print("tapped")
                self?.phpickerVCPresent()
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    let gymLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.numberOfLines = 1
        label.layer.zPosition = 1
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
    private let gradeButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString()
        titleAttr.font = .systemFont(ofSize: 15.0)
        configuration.attributedTitle = titleAttr
        
        let image = UIImage(systemName: "square.fill")?
            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .large))
        configuration.image = image
        configuration.imagePadding = 5
        configuration.imagePlacement = .leading
        configuration.baseForegroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 18
        button.layer.zPosition = 1
        button.isHidden = true
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
//        button.backgroundColor = UIColor {
//            switch $0.userInterfaceStyle {
//            case .dark:
//                return UIColor.secondarySystemBackground
//            default:
//                return UIColor.white
//            }
//        }
        
        return button
    }()
    
    private let holdButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        
        var titleAttr = AttributedString()
        titleAttr.font = .systemFont(ofSize: 15.0)
        configuration.attributedTitle = titleAttr

         if let defaultImage = UIImage(named: "square.fill") {
             let resizedImage = defaultImage.resize(targetSize: CGSize(width: 25, height: 25))
             configuration.image = resizedImage
         }
        configuration.imagePadding = 5
        configuration.imagePlacement = .leading
        configuration.baseForegroundColor = .clear
        
        let button = UIButton(configuration: configuration)
        button.layer.borderWidth = 0.5
        button.layer.borderColor = UIColor.gray.cgColor
        button.layer.cornerRadius = 18
        button.layer.zPosition = 1
        button.isHidden = true
        button.imageView?.contentMode = .scaleAspectFit
        button.setTitleColor(.label, for: .normal)
        button.backgroundColor = .clear
//        button.backgroundColor = UIColor {
//            switch $0.userInterfaceStyle {
//            case .dark:
//                return UIColor.secondarySystemBackground
//            default:
//                return UIColor.white
//            }
//        }
        
        return button
    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .secondaryLabel
        textView.text = UploadNameSpace.placeholder
        textView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        textView.returnKeyType = .done
        return textView
    }()
    
    private lazy var postButton: UIButton = {
        let button = UIButton()
        button.setTitle(UploadNameSpace.post, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .mainPurple // 앱 틴트 컬러
        button.layer.cornerRadius = 10
        button.clipsToBounds = true

        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var isCurrentScreenActive: Bool = false
    private var isUploading = false
    
    private var loadingOverlay: UIView?
    
    init(uploadVM: UploadVM, isClimbingVideo: Bool) {
        self.viewModel = uploadVM
        self.isClimbingVideo = isClimbingVideo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.viewModel.feedRelay.accept([])
        self.viewModel.cellData.accept([])
        
        self.viewModel.bindGymDataToMedia()
        
        textView.delegate = self
        setLayout()
        mediaItemsBind()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        setNavigation()
        setAlert()
        setLoading()
        setNotifications()
        bindPostButton()
        bindGymName()
        bindSettingButton()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        feedView?.pauseAllVideo()
        feedView?.isPlaying = true
        isCurrentScreenActive = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        feedView?.playAllVideo()
        isCurrentScreenActive = true
    }
    
    private func setNavigation() {
        navigationItem.title = UploadNameSpace.title
        
        let cancelButton = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(self.cancelButtonTapped))
        navigationItem.rightBarButtonItem = cancelButton
        
        viewModel.cellData
            .asDriver()
            .drive(onNext: { data in
                if data.isEmpty {
                    cancelButton.isHidden = true
                } else {
                    cancelButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }

    
    @objc private func cancelButtonTapped() {
        initUploadVC()
    }
    
    private func setNotifications() {
        // 포그라운드로 돌아올때
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        // 백그라운드로 전환될때
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func didEnterForeground() {
        if isCurrentScreenActive {
            feedView?.playAllVideo()
            feedView?.isPlaying = true
        }
    }
    
    @objc private func didEnterBackground() {
        feedView?.pauseAllVideo()
    }
    
    @objc
    func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            textView.resignFirstResponder()
            scrollToTop()
        }
        sender.cancelsTouchesInView = false
    }
    
    func scrollToTop() {
        let offset = CGPoint(x: 0, y: selectedMediaView.frame.origin.y)
        scrollView.setContentOffset(offset, animated: true)
    }
    
    func phpickerVCPresent() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .any(of: [.images, .videos])
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    func mediaItemsBind() {
        viewModel.feedRelay
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] items in
                guard let self else { return }
                
                if self.viewModel.shouldUpdateUI {
                    // 기존 피드를 제거
                    self.removeAllSubview(view: self.selectedMediaView)
                    
                    if items.isEmpty {
                        self.callPHPickerButton.isHidden = false
                    } else {
                        let feed = FeedView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: self.view.frame.width)),
                                            viewModel: self.viewModel)
                        self.feedView = feed
                        self.callPHPickerButton.isHidden = true
                        self.selectedMediaView.addSubview(feed)
                        
                        feed.snp.makeConstraints {
                            $0.size.equalToSuperview()
                            $0.edges.equalToSuperview()
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UIView의 서브뷰 제거 YJ
    func removeAllSubview(view: UIView) {
        view.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    
    private func setAlert() {
        viewModel.showAlert
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self else { return }
                print("알림 이벤트 발생")
                let alert = Alert()
                alert.showAlert(from: self,
                                title: "알림",
                                message: "1분 미만 비디오를 업로드해주세요.",
                                includeCancel: false)
                self.initUploadVC()
            })
            .disposed(by: disposeBag)
    }
    
    private func setLoading() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self else { return }
                if isLoading {
                    self.callPHPickerButton.isHidden = true
                    self.loadingIndicator.startAnimating()
                } else {
                    self.callPHPickerButton.isHidden = false
                    self.loadingIndicator.stopAnimating()
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindSettingButton() {
        let gymTapGesture = UITapGestureRecognizer()
        settingView.addGestureRecognizer(gymTapGesture)
        
        let settingModalVC = SelectSettingModalVC(viewModel: self.viewModel)
        
        let navigationModal = UINavigationController(rootViewController: settingModalVC)
        
        gymTapGesture.rx.event
            .asDriver()
            .drive(onNext: { [weak self] _ in
                guard let self else { return }
                
                print("피드릴레이 ㅜ\(self.viewModel.feedRelay.value)")
                
                if self.viewModel.cellData.value.isEmpty {
                    let alert = UIAlertController(title: "알림", message: "미디어를 먼저 선택해주세요", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                    return
                }
                
//                self.viewModel.shouldUpdateUI = true
//                self.feedView?.collectionView.reloadData()
                
                self.presentCustomHeightModal(modalVC: navigationModal, heightRatio: 0.6)
            })
            .disposed(by: disposeBag)
        
        settingModalVC.okButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                self.dismiss(animated: true, completion: nil)
                setSettingButton()
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - 페이지 변경 이벤트 구독 및 버튼 초기화 YJ
    private func setSettingButton() {
        Driver.combineLatest(
            viewModel.pageChanged.asDriver(onErrorJustReturn: 0).startWith(0),
            viewModel.feedRelay.asDriver()
        )
        .drive(onNext: { [weak self] pageIndex, feedItems in
            guard let self else { return }
            let pageIndex = self.viewModel.pageChanged.value
            
            let selectedGrade = self.viewModel.selectedGrade
            let selectedHold = self.viewModel.selectedHold
            
            guard pageIndex >= 0 && pageIndex < feedItems.count else {
                print("잘못된 페이지 인덱스")
                return
            }
            
            let feedItem = feedItems[pageIndex]
            
            print("feeItem: \(feedItem)")
            print("feeItem즈: \(feedItems)")
            
            if feedItem.grade == nil, feedItem.hold == nil || feedItems.isEmpty || selectedGrade.value == nil || selectedHold.value == nil {
                self.gradeButton.isHidden = true
                self.settingView.selectedLabel.isHidden = false
                self.settingView.nextImageView.isHidden = false
                self.holdButton.isHidden = true
            }
            
            if feedItem.grade != nil {
                self.settingView.selectedLabel.isHidden = true
                self.settingView.nextImageView.isHidden = true
                self.gradeButton.isHidden = false
                self.gradeButton.setTitle(feedItem.grade?.colorInfo.text, for: .normal)
                self.gradeButton.backgroundColor = .clear
                
                let colorInfo = feedItem.grade?.colorInfo
                self.gradeButton.setImage(
                    UIImage(systemName: "circle.fill")?
                        .withTintColor(colorInfo?.color ?? UIColor.clear, renderingMode: .alwaysOriginal), for: .normal)
            }
            
            if let hold = feedItem.hold, feedItem.hold != nil {
                self.settingView.selectedLabel.isHidden = true
                self.settingView.nextImageView.isHidden = true
                self.holdButton.isHidden = false
                
                if let holdEnum = Hold.allCases.first(where: { $0.string == hold }) {
                    self.holdButton.setTitle(holdEnum.koreanHold, for: .normal)
                    self.holdButton.backgroundColor = .clear
                }
                
                if let holdImage = UIImage(named: hold) {
                    let resizedImage = holdImage.resize(targetSize: CGSize(width: 20, height: 20))
                    self.holdButton.imageView?.contentMode = .scaleAspectFit
                    self.holdButton.setImage(resizedImage, for: .normal)
                }
            }
        })
        .disposed(by: disposeBag)
    }
    
    private func bindGymName() {
        viewModel.gymRelay
            .map { $0?.gymName }
            .asDriver(onErrorJustReturn: "")
            .drive(gymLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [scrollView, postButton]
            .forEach {
                view.addSubview($0)
            }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(postButton.snp.top)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(postButton.snp.top)
        }
        
        gymLabel.snp.makeConstraints {
            $0.top.equalTo(gymView.snp.top)
            $0.height.equalTo(gymView.snp.height)
            $0.trailing.equalTo(gymView.snp.trailing).offset(-16)
        }
        
        selectedMediaView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            // SE 예외처리
            if UIScreen.main.bounds.size.width <= 375 {
                $0.height.equalTo(UIScreen.main.bounds.width * 0.9)
            } else {
                $0.height.equalTo(view.frame.width)
            }
        }
        
        callPHPickerButton.snp.makeConstraints {
            $0.centerX.equalTo(selectedMediaView.snp.centerX)
            $0.centerY.equalTo(selectedMediaView.snp.centerY).offset(-8)
            $0.size.equalTo(CGSize(width: 150, height: 150))
        }
        
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(selectedMediaView.snp.bottom).offset(8)
            
            if UIScreen.main.bounds.size.width <= 667 {
                $0.height.equalTo(UIScreen.main.bounds.height * 0.12)
            } else {
                $0.height.equalTo(UIScreen.main.bounds.height * 0.15)
            }
        }
        
        gymView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        settingView.snp.makeConstraints {
            $0.top.equalTo(gymView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        gradeButton.snp.makeConstraints {
            $0.top.equalTo(settingView.snp.top).inset(8)
            $0.bottom.equalTo(settingView.snp.bottom).inset(8)
            $0.centerY.equalTo(settingView.snp.centerY)
//            $0.height.equalTo(settingView.snp.height).multipliedBy(0.8)
//            $0.trailing.equalTo(settingView.snp.trailing).offset(-8)
        }
        
        holdButton.snp.makeConstraints {
            $0.top.equalTo(settingView.snp.top).inset(8)
            $0.bottom.equalTo(settingView.snp.bottom).inset(8)
            $0.centerY.equalTo(settingView.snp.centerY)
//            $0.height.equalTo(settingView.snp.height).multipliedBy(0.8)
            $0.leading.equalTo(gradeButton.snp.trailing).offset(8)
            $0.trailing.equalTo(settingView.snp.trailing).offset(-8)
        }
        
        postButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(50)
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalTo(selectedMediaView.snp.center)
        }
    }
}
//MARK: TexViewDelegate
extension UploadVC : UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        let offset = CGPoint(x: 0, y: textView.frame.origin.y)
        scrollView.setContentOffset(offset, animated: true)
        return true
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .secondaryLabel else { return }
        textView.text = nil
        textView.textColor = .label
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = .secondaryLabel
            textView.text = UploadNameSpace.placeholder
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if (text == "\n") {
            textView.resignFirstResponder()
            scrollToTop()
        }
        return true
    }
}
extension UploadVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        let mediaData: [(index: Int, mediaItem: PHPickerResult)] = results.enumerated().map { (index, mediaItem) in
            print("피커뷰에서 인덱스: \(index) 미디어아이템\(mediaItem.itemProvider)")
            return (index, mediaItem)
        }
        
        viewModel.mediaItems.accept(mediaData)
        
        picker.dismiss(animated: true) {
            self.viewModel.setMedia()
        }
    }
}

// MARK: 업로드 로직
extension UploadVC {
    private func bindPostButton() {
        postButton.rx.tap
            .do(onNext: { [weak self] in
                guard let self else { return }
                
            })
            .subscribe(onNext: { [weak self] in
                DispatchQueue.main.async {
                    guard let self else { return }
                    
                    if self.isUploading {
                        print("업로드 중, 업로드 버튼 클릭 무시.")
                        return
                    }
                    
                    self.postButton.backgroundColor = UIColor.systemGray6
                    self.addLoadingOverlay()
                    self.feedView?.pauseAllVideo()
                    
                    self.navigationController?.navigationBar.isUserInteractionEnabled = false
                    
                    print("업로드 버튼 클릭.")
                    
                    // 첫 번째 미디어 가져오기
                    guard let firstFeedItem = self.viewModel.feedRelay.value.first else {
                        print("첫 번째 미디어가 없습니다.")
                        let alert = Alert()
                        alert.showAlert(from: self, title: "알림", message: "정보가 부족합니다.")
                        self.removeLoadingOverlay()
                        self.postButton.backgroundColor = UIColor.mainPurple
                        return
                    }
                    
                    let media = self.viewModel.feedRelay.value.compactMap { feedItem -> (url: URL, hold: String?, grade: String?)? in
                        if let videoURL = feedItem.videoURL {
                            print("비디오 URL: \(videoURL)")
                            return (url: videoURL, hold: feedItem.hold, grade: feedItem.grade?.colorInfo.englishText)
                        }
                        if let imageURL = feedItem.imageURL {
                            print("이미지 URL: \(imageURL)")
                            return (url: imageURL, hold: feedItem.hold, grade: feedItem.grade?.colorInfo.englishText)
                        }
                        return nil
                    }
                    
                    for item in media {
                        if item.hold == nil || item.grade == nil {
                            let alert = Alert()
                            alert.showAlert(from: self, title: "알림", message: "모든 난이도 및 홀드색을 설정해주세요")
                            self.removeLoadingOverlay()
                            self.postButton.backgroundColor = UIColor.mainPurple
                            return
                        }
                    }
                    
                    var uploadStatus: UploadStatus = .success
                    let caption = self.textView.textColor == .secondaryLabel ? "" : (self.textView.text ?? "")
                    
                    if media.isEmpty {
                        uploadStatus = .fail
                    }
                    
                    let gym = self.gymLabel.text ?? ""
                    
                    self.uploadMedia(media: media, caption: caption, gym: gym, thumbnailURL: "", uploadStatus: uploadStatus)
                    
                }
            })
            .disposed(by: disposeBag)
    }

    private func addLoadingOverlay() {
        guard loadingOverlay == nil else { return }
        
        let overlay = UIView()
        overlay.frame = self.view.bounds
        overlay.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        let loadingIndicator = UIActivityIndicatorView(style: .large)
        let centerY = overlay.center.y - 50
        loadingIndicator.center = CGPoint(x: overlay.center.x, y: centerY)
        loadingIndicator.color = .white
        loadingIndicator.startAnimating()
        overlay.addSubview(loadingIndicator)
        
        loadingOverlay = overlay
        self.view.addSubview(overlay)
    }
    
    private func removeLoadingOverlay() {
        loadingOverlay?.removeFromSuperview()
        loadingOverlay = nil
    }
    
    private func uploadMedia(media: [(url: URL, hold: String?, grade: String?)], caption: String?, gym: String?, thumbnailURL: String, uploadStatus: UploadStatus) {
        let alert = Alert()
        switch uploadStatus {
        case .fail:
            alert.showAlert(from: self, title: "알림", message: "정보가 부족합니다.")
        case .success:
            isUploading = true
            
            self.viewModel.upload(media: media, caption: caption, gym: gym, thumbnailURL: thumbnailURL)
                .drive(onNext: { [weak self] in
                    guard let self else { return }
                    
                    print("업로드 성공")
                    alert.showAlert(from: self, title: "알림", message: "성공적으로 업로드되었습니다.")
                    
                    self.tabBarController?.selectedIndex = 0
                    self.navigationController?.navigationBar.isUserInteractionEnabled = true
                    self.navigationController?.popToRootViewController(animated: true)
                    
                    self.initUploadVC()
                    self.setNewUplodVC()
                    self.removeLoadingOverlay()
                    
                    self.removeFromParent()
                    
                    self.isUploading = false
                })
                .disposed(by: self.disposeBag)
        }
    }
    
    private func setNewUplodVC() {
        self.textView.text = ""
        self.postButton.backgroundColor = .mainPurple
        
        if textView.text == "" {
            textView.textColor = .secondaryLabel
            textView.text = UploadNameSpace.placeholder
        }
        
        self.viewModel.gymRelay.accept(nil)
    }
    
    // MARK: - 업로드뷰 초기화 YJ
    private func initUploadVC() {
        self.feedView?.pauseAllVideo()
        self.feedView = nil
        
        self.viewModel.pageChanged = BehaviorRelay<Int>(value: 0)
        
        self.viewModel.selectedGrade = BehaviorRelay<String?>(value: nil)
        self.viewModel.selectedHold = BehaviorRelay<Hold?>(value: nil)
        
        self.viewModel.feedRelay = BehaviorRelay(value: [])
        self.viewModel.cellData = BehaviorRelay(value: [FeedCellModel]())
        
        self.viewModel.shouldUpdateUI = true
        self.viewModel.mediaItems = BehaviorRelay<[(index: Int, mediaItem: PHPickerResult)]>(value: [])
        print("피드릴레이 확인하자: \(self.viewModel.feedRelay.value)")
        
        viewModel.feedRelay
            .asDriver(onErrorJustReturn: [])
            .drive(onNext: { [weak self] items in
                guard let self else { return }
                
                if self.viewModel.shouldUpdateUI {
                    
                    self.removeAllSubview(view: self.selectedMediaView)
                    
                    if items.isEmpty {
                        self.callPHPickerButton.isHidden = false
                    } else {
                        let feed = FeedView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: self.view.frame.width)),
                                            viewModel: self.viewModel)
                        self.feedView = feed
                        self.callPHPickerButton.isHidden = true
                        self.selectedMediaView.addSubview(feed)
                        
                        feed.snp.makeConstraints {
                            $0.size.equalToSuperview()
                            $0.edges.equalToSuperview()
                        }
                    }
                }
            })
            .disposed(by: disposeBag)
        
        self.viewModel.setMedia()
        self.setNavigation()
        
        self.gradeButton.isHidden = true
        self.settingView.selectedLabel.isHidden = false
        self.settingView.nextImageView.isHidden = false
        self.holdButton.isHidden = true
        
        navigationItem.rightBarButtonItem?.isHidden = true
    }
}
