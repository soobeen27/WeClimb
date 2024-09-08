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
        return UploadVM(mediaItems: [])
    }()
    
    private let disposeBag = DisposeBag()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        scroll.addSubview(contentView)
        return scroll
    }()
    
    private let gymView = UploadOptionView(symbolImage: UIImage(systemName: "figure.climbing") ?? UIImage(), optionText: UploadNameSpace.selectGym)
    private let levelView = UploadOptionView(symbolImage: UIImage(systemName: "flag") ?? UIImage(), optionText: UploadNameSpace.selectSector)
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        [selectedMediaView, callPHPickerButton, levelButton, textView, gymView, levelView, /*loadingIndicator*/]
            .forEach {
                view.addSubview($0)
            }
        return view
    }()
    
    private lazy var selectedMediaView: UIView = {
        let view = UIView()
        view.backgroundColor = .secondarySystemBackground
        view.addSubview(callPHPickerButton)
        return view
    }()
    
    private lazy var callPHPickerButton: UIButton = {
        let button = UIButton()
        button.setTitle(UploadNameSpace.add, for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .medium)
        button.backgroundColor = .mainPurple // 앱 틴트 컬러
        button.layer.cornerRadius = 10
        button.rx.tap
            .bind { [weak self] in
                print("tapped")
                self?.phpickerVCPresent()
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    private let levelButton: UIButton = {
        let button = UIButton(primaryAction: nil)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.setTitleColor(.systemBlue, for: .normal)
        button.backgroundColor = .systemGray3
        button.layer.cornerRadius = 15
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
        textView.delegate = self
        setLayout()
        mediaItemsBind()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
        setGymView()
        setSectorView()
        setLevelButton()
        setAlert()
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
        viewModel.mediaItems
            .subscribe(onNext: { [weak self] items in
                guard let self else { return }
                
                if self.viewModel.mediaItems.value == [] {
                    self.callPHPickerButton.isHidden = false
                } else {
                    let uploadVM = UploadVM(mediaItems: items)
                    let feed = FeedView(frame: CGRect(origin: CGPoint(),
                                                      size: CGSize(width: self.view.frame.width, height: self.view.frame.width)),
                                        viewModel: uploadVM
                    )
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
                self.present(navigationController, animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    private func setSectorView() {
        let button = UIButton(primaryAction: nil)
        
        let menuItems: [UIAction] = ["섹터 1", "섹터 2", "섹터 3"].map { sector in
            UIAction(title: sector) { [weak self] _ in
                self?.viewModel.optionSelected(optionText: sector)
            }
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: menuItems)
        
        button.menu = menu
        button.showsMenuAsPrimaryAction = true  // 버튼을 탭하면 메뉴 노출
        button.backgroundColor = .clear
        
        levelView.addSubview(button)
        
        button.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.trailing.equalToSuperview()
            $0.width.equalTo(levelView).multipliedBy(2.0 / 3.0) // levelView의 2/3
        }
    }
    
    private func setLevelButton() {
        let menuItems: [UIAction] = ["레벨 1", "레벨 2", "레벨 3"].map { sector in
            UIAction(title: sector) { [weak self] _ in
                self?.viewModel.optionSelected(optionText: sector)
            }
        }
        
        let menu = UIMenu(title: "", options: .displayInline, children: menuItems)
        
        levelButton.menu = menu
        levelButton.showsMenuAsPrimaryAction = true
        levelButton.changesSelectionAsPrimaryAction = true
        levelButton.setTitle("선택", for: .normal)
        
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
                let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
                alertController.addAction(okAction)
                
                self.present(alertController, animated: true, completion: {
                    print("설공적으로 알림 노출.")
                })
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
            $0.left.right.equalToSuperview()
            $0.height.equalTo(view.frame.width)
        }
        
        callPHPickerButton.snp.makeConstraints {
            $0.center.equalTo(selectedMediaView.snp.center)
            $0.size.equalTo(CGSize(width: 100, height: 50))
        }
        
        levelButton.snp.makeConstraints {
            $0.leading.equalTo(selectedMediaView.snp.leading).offset(16)
            $0.bottom.equalTo(selectedMediaView.snp.bottom).offset(-16)
            $0.size.equalTo(CGSize(width: 50, height: 30))
        }
        
        textView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.top.equalTo(selectedMediaView.snp.bottom).offset(8)
            $0.height.equalTo(80)
        }
        
        gymView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        levelView.snp.makeConstraints {
            $0.top.equalTo(gymView.snp.bottom)
            $0.left.right.equalToSuperview()
        }
        
        postButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            $0.height.equalTo(50)
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
