//
//  UploadPostVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit
import RxSwift
import RxRelay

class UploadPostVC: UIViewController {
    var coordinator: UploadPostCoordinator?
    
    private let gymName: String
    private let mediaItems: [MediaUploadData]
    private let viewModel: UploadPostVM
    private var disposeBag = DisposeBag()
    
    private let topSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lineOpacityNormal
        return view
    }()
    
    lazy var gymButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = gymName
        config.image = UIImage.locationIconFill.resize(targetSize: CGSize(width: 12, height: 12))?
            .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        config.baseForegroundColor = UIColor.white
        config.baseBackgroundColor = UIColor.init(hex: "313235", alpha: 0.4) // fillOpacityDarkHeavy
        config.titleAlignment = .trailing
        config.imagePlacement = .leading
        config.imagePadding = 4
        
        var titleAttributes = AttributedString(gymName)
        titleAttributes.font = UIFont.customFont(style: .caption1Medium)
        
        config.attributedTitle = titleAttributes
        
        let button = UIButton(configuration: config)
        button.tintColor = .white
        button.layer.zPosition = 1
        button.backgroundColor = UIColor.init(hex: "313235", alpha: 0.4) // fillOpacityDarkHeavy
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.register(UploadPostCollectionCell.self, forCellWithReuseIdentifier: UploadPostCollectionCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.fillSolidDarkBlack
        collectionView.layer.cornerRadius = 11
        return collectionView
    }()
    
    private let uploadTextView = UploadTextView()
    private var uploadTextViewBottomConstraint: Constraint?
    
    private let bottomSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lineOpacityNormal
        return view
    }()
    
    private let submitButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle("등록", for: .normal)
        button.titleLabel?.font = UIFont.customFont(style: .label1SemiBold)
        button.setTitleColor(.labelStrong, for: .normal)
        button.backgroundColor = UIColor.white
        button.layer.zPosition = 1
        return button
    }()
    
    private lazy var safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fillSolidDarkStrong
        return view
    }()
    
    private let captionTextSubject = PublishRelay<String>()
    private let submitButtonTap = PublishRelay<Void>()
    
    private let loadingOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        view.isHidden = true
        return view
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = .white
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    var onDismiss: (() -> Void)?
    
    init(gymName: String, mediaItems: [MediaUploadData], viewModel: UploadPostVM) {
        self.gymName = gymName
        self.mediaItems = mediaItems
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        setLayout()
        self.uploadTextView.textView.delegate = self
        setupKeyboardObservers()
        bindViewModel()
        bindButtons()
        bindTextView()
    }
    
    deinit {
          NotificationCenter.default.removeObserver(self)
      }
    
    private func setNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.fillSolidDarkBlack
        
        navigationItem.title = "편집"
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UIColor.white,
            .font: UIFont.customFont(style: .heading2SemiBold)
        ]
        
        let backIcon = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysTemplate)
        let backButton = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(didTapCloseButton))
        backButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func didTapCloseButton() {
        let alert = DefaultAlertVC(alertType: .titleDescription, interfaceStyle: .dark)
        alert.setTitle("정말 나가시겠어요?", "입력된 내용은 저장되지 않아요.")
        alert.setCustomButtonTitle("삭제")
        alert.customButtonTitleColor = UIColor.init(hex: "FB283E")  //StatusNegative
        
        alert.customAction = { [weak self] in
            self?.onDismiss?()
        }
        
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: false, completion: nil)
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 12
        
        let itemWidth: CGFloat = 125
        let itemHeight: CGFloat = 222
        
        layout.itemSize = CGSize(width: itemWidth, height: itemHeight)
        
        let inset: CGFloat = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
        
        return layout
    }
    
    private func bindViewModel() {
        let submitTap = submitButton.rx.tap.asObservable()

        let input = UploadPostVMImpl.Input(
            submitButtonTap: submitTap,
            captionText: submitTap.withLatestFrom(uploadTextView.textView.rx.text.orEmpty),
            gymName: gymName,
            mediaItems: mediaItems
        )

        let output = viewModel.transform(input: input)

        output.uploadResult
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                switch result {
                case .success:
                    print("게시물이 성공적으로 업로드됨")
                    self?.loadingOverlayView.isHidden = true
                    self?.loadingIndicator.stopAnimating()
                    
                    self?.onDismiss?()
                case .failure(let error):
                    print("게시물 업로드 실패: \(error.localizedDescription)")
                }
            })
            .disposed(by: disposeBag)

        Observable.just(mediaItems)
            .bind(to: collectionView.rx.items(
                cellIdentifier: UploadPostCollectionCell.className,
                cellType: UploadPostCollectionCell.self)
            ) { row, data, cell in
                cell.configure(with: data)
            }
            .disposed(by: disposeBag)
    }
    
    private func bindButtons() {
        submitButton
            .rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                self?.loadingOverlayView.isHidden = false
                self?.loadingIndicator.startAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.fillSolidDarkBlack
        
        [safeAreaBackgroundView, topSeparatorLine, gymButton, collectionView, uploadTextView, bottomSeparatorLine, submitButton, loadingOverlayView, loadingIndicator]
            .forEach { view.addSubview($0) }
        
        topSeparatorLine.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(1)
        }
        
        gymButton.snp.makeConstraints {
            $0.top.equalTo(topSeparatorLine.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(26)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(gymButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(222)
        }
        
        uploadTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            self.uploadTextViewBottomConstraint = $0.bottom.equalTo(bottomSeparatorLine.snp.top).constraint
        }
        
        bottomSeparatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(submitButton.snp.top).offset(-16)
            $0.height.equalTo(1)
        }
        
        safeAreaBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(bottomSeparatorLine.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        submitButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(48)
        }
        
        loadingOverlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension UploadPostVC: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        
        let currentText = textView.text ?? ""
        
        guard let textRange = Range(range, in: currentText) else { return true }
        let updatedText = currentText.replacingCharacters(in: textRange, with: text)
        
        return updatedText.count <= 1000
    }
    
    private func bindTextView() {
        uploadTextView.textView.rx.text.orEmpty
            .map { text -> String in
                return text == " 내용을 입력해주세요." ? "0/1000" : "\(text.count)/1000"
            }
            .bind(to: uploadTextView.textFieldCharCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == .labelNormal else { return }
        textView.text = nil
        textView.layer.borderColor = UIColor.white.cgColor
        textView.font = .customFont(style: .body2SemiBold)
        textView.textColor = .white
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            textView.textColor = .labelNormal
            textView.text = " 내용을 입력해주세요."
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {

        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom - 80
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3

        uploadTextViewBottomConstraint?.update(offset: -keyboardHeight)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double ?? 0.3
        
        uploadTextViewBottomConstraint?.update(offset: 0)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
