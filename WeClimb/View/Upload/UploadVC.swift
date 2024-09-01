//
//  UploadVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//
import AVKit
import PhotosUI
import UIKit

import SnapKit
import RxCocoa
import RxSwift

class UploadVC: UIViewController {
    
    private lazy var viewModel: UploadVM = {
        return UploadVM()
    }()
    
    private let disposeBag = DisposeBag()
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        scroll.addSubview(contentView)
        return scroll
    }()
    
    private let gymView = UploadOptionView()
    
    private let levelView = UploadOptionView()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        [selectedMediaView, callPHPickerButton, textView, gymView, levelView]
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
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .secondaryLabel
        textView.text = UploadNameSpace.placeholder
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = UploadNameSpace.title
        textView.delegate = self
        setLayout()
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:))))
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
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
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
        picker.dismiss(animated: true)
        let itemProvider = results.first?.itemProvider
        if let itemProvider = itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) { (image, error) in
                DispatchQueue.main.async {
                    //                              self.myImageView.image = image as? UIImage // 5
                }
            }
        } else {
        }
    }
    
    
}
