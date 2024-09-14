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
    
    private lazy var viewModel: UploadVM = {
        return UploadVM()
    }()
    
    private let disposeBag = DisposeBag()
    private var feedView: FeedView?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        scroll.addSubview(contentView)
        return scroll
    }()
    
    private let gymView = UploadOptionView(symbolImage: UIImage(systemName: "figure.climbing") ?? UIImage(), optionText: UploadNameSpace.selectGym, showSelectedLabel: true)
    private let sectorView = UploadOptionView(symbolImage: UIImage(systemName: "flag") ?? UIImage(), optionText: UploadNameSpace.selectSector, showSelectedLabel: false)
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        [selectedMediaView, callPHPickerButton, gradeButton, textView, gymView, sectorView, loadingIndicator]
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
    
    private let gradeButton: UIButton = {
        let button = UIButton()
        button.setTitle("선택", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray3
        button.layer.cornerRadius = 15
        return button
    }()
    
    private let sectorButton: UIButton = {
        // UIButtonConfiguration 생성 및 설정
//        var configuration = UIButton.Configuration.plain()
//        configuration.title = "선택"
//        configuration.image = UIImage(systemName: "chevron.right")
//        configuration.imagePadding = 8
//        configuration.imagePlacement = .leading
//        configuration.titleAlignment = .trailing
//        configuration.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
//        
        // 버튼 생성 및 설정
        let button = CustomButton()
        button.tintColor = .secondaryLabel
        button.titleLabel?.font = .systemFont(ofSize: 15)
        button.setTitleColor(.secondaryLabel, for: .normal)
//        button.contentEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
//        button.setTitle("선택", for: .normal)
//        button.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        button.semanticContentAttribute = .forceRightToLeft
//        // 이미지와 텍스트 위치 조정
//         // 이미지의 오른쪽 여백을 8포인트로 설정
//         let imageWidth = button.imageView?.intrinsicContentSize.width ?? 0
//         button.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -8)
//         
//         // 텍스트의 왼쪽 여백을 이미지의 너비 + 8포인트로 설정
//         let titleWidth = button.titleLabel?.intrinsicContentSize.width ?? 0
//         button.titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - 8, bottom: 0, right: 0)
        
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
    
    private let postButton: UIButton = {
        let button = UIButton()
        button.setTitle(UploadNameSpace.post, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        button.backgroundColor = .mainPurple // 앱 틴트 컬러
        button.layer.cornerRadius = 10
        return button
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = UploadNameSpace.title
        textView.delegate = self
        setLayout()
        mediaItemsBind()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        setGymView()
        setAlert()
        setLoading()
        setNotifications()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        feedView?.pauseAllVideo()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        feedView?.playAllVideo()
    }
    
    private func setNotifications() {
        // 포그라운드로 돌아올때
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterForeground), name: UIApplication.didBecomeActiveNotification, object: nil)
        // 백그라운드로 전환될때
        NotificationCenter.default.addObserver(self, selector: #selector(didEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    @objc private func didEnterForeground() {
        feedView?.playAllVideo()
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
            .subscribe(onNext: { [weak self] items in
                guard let self else { return }
                
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
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: - UIView의 서브뷰 제거 YJ
    func removeAllSubview(view: UIView) {
        view.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
    }
    
    private func setGymView() {
        let gymTapGesture = UITapGestureRecognizer()
        gymView.isUserInteractionEnabled = true
        gymView.addGestureRecognizer(gymTapGesture)
        
        gymTapGesture.rx.event
            .observe(on: MainScheduler.instance)
            .bind { [weak self] _ in
                guard let self = self else { return }
                // 화면 전환
                let searchVC = SearchVC()
                let navigationController = UINavigationController(rootViewController: searchVC)
                navigationController.modalPresentationStyle = .pageSheet
                searchVC.ShowSegment = false // 세그먼트 컨트롤 숨기기
                searchVC.nextPush = false
                searchVC.onSelectedGym = { gymInfo in
                    self.setgradeButton(with: gymInfo)
                    self.setSectorButton(with: gymInfo)
                }
                self.present(navigationController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - 선택한 암장 기준으로 난이도 버튼 세팅 YJ
    private func setgradeButton(with gymInfo: Gym) {
        let grade = gymInfo.grade.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        
        let menuItems: [UIAction] = grade.map { level in
            UIAction(title: level) { [weak self] _ in
                self?.viewModel.optionSelected(optionText: level)
            }
        }
        
        let menu = UIMenu(title: "선택", options: .displayInline, children: menuItems)
        
        gradeButton.menu = menu
        gradeButton.showsMenuAsPrimaryAction = true
        gradeButton.changesSelectionAsPrimaryAction = true
        gradeButton.setTitle("선택", for: .normal)
    }
    
    private func setSectorButton(with gymInfo: Gym) {
        let sectors = gymInfo.sector.split(separator: ",").map { String($0).trimmingCharacters(in: .whitespaces) }
        
        let menuItems: [UIAction] = sectors.map { sector in
            UIAction(title: sector) { [weak self] _ in
                self?.viewModel.optionSelected(optionText: sector)
            }
        }
        
        let menu = UIMenu(title: "선택", options: .displayInline, children: menuItems)

        sectorButton.menu = menu
        sectorButton.showsMenuAsPrimaryAction = true // 버튼을 탭하면 메뉴 노출
        sectorButton.changesSelectionAsPrimaryAction = true
        sectorButton.setTitle("선택", for: .normal)
        sectorButton.setImage(UIImage(systemName: "chevron.right"), for: .normal)
        sectorButton.imageView?.tintColor = .secondaryLabel

        sectorView.addSubview(sectorButton)
        
        sectorButton.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.center.equalToSuperview()
//            $0.width.equalTo(sectorView).multipliedBy(2.0 / 3.0) // sectorView의 2/3
            $0.width.equalTo(sectorView)
            
        }
    }
 
    private func setAlert() {
        viewModel.showAlert
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                print("알림 이벤트 발생")
                
                let alertController = UIAlertController(
                    title: "알림",
                    message: "1분 미만 비디오를 업로드해주세요.",
                    preferredStyle: .alert
                )
                let okAction = UIAlertAction(title: "확인", style: .default) { _ in
                    self.phpickerVCPresent()
                }
                let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: { _ in
                    self.removeAllSubview(view: self.selectedMediaView) // 피드 뷰 제거
                    self.callPHPickerButton.isHidden = false
                })
                
                alertController.addAction(okAction)
                alertController.addAction(cancelAction) // 취소 버튼 추가
                
                self.present(alertController, animated: true, completion: {
                    print("설공적으로 알림 노출.")
                })
            })
            .disposed(by: disposeBag)
    }
    
    
    private func setLoading() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] isLoading in
                guard let self = self else { return }
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
        
        selectedMediaView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(view.frame.width)
        }
        
        callPHPickerButton.snp.makeConstraints {
            $0.centerX.equalTo(selectedMediaView.snp.centerX)
            $0.centerY.equalTo(selectedMediaView.snp.centerY).offset(-8)
            $0.size.equalTo(CGSize(width: 150, height: 150))
        }
        
        gradeButton.snp.makeConstraints {
            $0.leading.equalTo(selectedMediaView.snp.leading).offset(16)
            $0.bottom.equalTo(selectedMediaView.snp.bottom).offset(-16)
            $0.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        textView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.top.equalTo(selectedMediaView.snp.bottom).offset(8)
            $0.height.equalTo(80)
        }
        
        gymView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
        }
        
        sectorView.snp.makeConstraints {
            $0.top.equalTo(gymView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
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

extension UploadVC : PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        viewModel.mediaItems.accept(results)
        viewModel.setMedia()
        picker.dismiss(animated: true)
    }
}

class CustomButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 버튼의 텍스트와 이미지 위치 조정
        guard let imageView = imageView, let titleLabel = titleLabel else { return }
        
        let imageWidth = imageView.frame.width
        let titleWidth = titleLabel.frame.width
        let spacing: CGFloat = 8 // 이미지와 텍스트 간의 간격
        
        // 이미지와 텍스트의 위치 조정
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: -spacing)
        titleEdgeInsets = UIEdgeInsets(top: 0, left: -imageWidth - spacing, bottom: 0, right: 0)
    }
}
