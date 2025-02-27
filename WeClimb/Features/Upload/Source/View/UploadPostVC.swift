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
        view.backgroundColor = UploadPostConst.UploadPostVC.Color.topSeparator
        return view
    }()
    
    lazy var gymButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = gymName
        config.image = UIImage.locationIconFill.resize(targetSize: UploadPostConst.UploadPostVC.Size.gymButtonImage)?
            .withTintColor(UploadPostConst.UploadPostVC.Color.gymButtonForeground, renderingMode: .alwaysOriginal)
        config.baseForegroundColor = UploadPostConst.UploadPostVC.Color.gymButtonForeground
        config.baseBackgroundColor = UploadPostConst.UploadPostVC.Color.gymButtonBackground
        config.titleAlignment = .trailing
        config.imagePlacement = .leading
        config.imagePadding = UploadPostConst.UploadPostVC.Size.gymButtonImagePadding
        
        var titleAttributes = AttributedString(gymName)
        titleAttributes.font = UploadPostConst.UploadPostVC.Font.gymButtonTitle
        
        config.attributedTitle = titleAttributes
        
        let button = UIButton(configuration: config)
        button.tintColor = UploadPostConst.UploadPostVC.Color.gymButtonForeground
        button.layer.zPosition = UploadPostConst.UploadPostVC.Layout.gymButtonZPosition
        button.backgroundColor = UploadPostConst.UploadPostVC.Color.gymButtonBackground
        button.layer.cornerRadius = UploadPostConst.UploadPostVC.Size.gymButtonCornerRadius
        
        return button
    }()
    
    lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.isPagingEnabled = false
        collectionView.decelerationRate = .fast
        collectionView.register(UploadPostCollectionCell.self, forCellWithReuseIdentifier: UploadPostCollectionCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UploadPostConst.UploadPostVC.Color.collectionViewBackground
        collectionView.layer.cornerRadius = UploadPostConst.UploadPostVC.Size.collectionViewCornerRadius
        return collectionView
    }()
    
    private let uploadTextView = UploadTextView()
    private var uploadTextViewBottomConstraint: Constraint?
    
    private let bottomSeparatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UploadPostConst.UploadPostVC.Color.bottomSeparator
        return view
    }()
    
    private let submitButton: WeClimbButton = {
        let button = WeClimbButton(style: .defaultRectangle)
        button.setTitle(UploadPostConst.UploadPostVC.Text.submitButtonTitle, for: .normal)
        button.titleLabel?.font = UploadPostConst.UploadPostVC.Font.submitButtonTitle
        button.setTitleColor(UploadPostConst.UploadPostVC.Color.submitButtonText, for: .normal)
        button.backgroundColor = UploadPostConst.UploadPostVC.Color.submitButtonBackground
        button.layer.zPosition = UploadPostConst.UploadPostVC.Layout.submitButtonZPosition
        return button
    }()
    
    private lazy var safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UploadPostConst.UploadPostVC.Color.safeAreaBackground
        return view
    }()
    
    private let captionTextSubject = PublishRelay<String>()
    private let submitButtonTap = PublishRelay<Void>()
    
    private let loadingOverlayView: UIView = {
        let view = UIView()
        view.backgroundColor = UploadPostConst.UploadPostVC.Color.loadingOverlay
        view.isHidden = true
        return view
    }()

    private let loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.color = UploadPostConst.UploadPostVC.Color.loadingIndicator
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
        navigationController?.navigationBar.barTintColor = UploadPostConst.UploadPostVC.Color.navigationBarBackground
        
        navigationItem.title = UploadPostConst.UploadPostVC.Text.navigationTitle
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UploadPostConst.UploadPostVC.Color.navigationTitleText,
            .font: UploadPostConst.UploadPostVC.Font.navigationTitle
        ]
        
        let backButton = UIBarButtonItem(
            image: UploadPostConst.UploadPostVC.Image.navigationBackIcon,
            style: .plain,
            target: self,
            action: #selector(didTapCloseButton)
        )
        backButton.tintColor = UploadPostConst.UploadPostVC.Color.navigationButtonTint
        
        navigationItem.leftBarButtonItem = backButton
    }
    
    @objc private func didTapCloseButton() {
        let alert = DefaultAlertVC(alertType: .titleDescription, interfaceStyle: .dark)
        alert.setTitle(
            UploadPostConst.UploadPostVC.Text.closeAlertTitle,
            UploadPostConst.UploadPostVC.Text.closeAlertMessage
        )
        alert.setCustomButtonTitle(UploadPostConst.UploadPostVC.Text.closeAlertButtonTitle)
        alert.customButtonTitleColor = UploadPostConst.UploadPostVC.Color.alertButtonText
        
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
        layout.minimumLineSpacing = UploadPostConst.UploadPostVC.Size.collectionViewItemSpacing
        
        layout.itemSize = CGSize(
            width: UploadPostConst.UploadPostVC.Size.collectionViewItemWidth,
            height: UploadPostConst.UploadPostVC.Size.collectionViewItemHeight
        )
        
        layout.sectionInset = UIEdgeInsets(
            top: UploadPostConst.UploadPostVC.Size.collectionViewSectionInsetTop,
            left: UploadPostConst.UploadPostVC.Size.collectionViewItemInset,
            bottom: UploadPostConst.UploadPostVC.Size.collectionViewSectionInsetBottom,
            right: UploadPostConst.UploadPostVC.Size.collectionViewItemInset
        )
        
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
            .bind(onNext: { [weak self] in
                self?.loadingOverlayView.isHidden = true
                self?.loadingIndicator.stopAnimating()
                self?.onDismiss?()
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
            .bind(onNext: { [weak self] in
                self?.loadingOverlayView.isHidden = false
                self?.loadingIndicator.startAnimating()
            })
            .disposed(by: disposeBag)
    }
    
    private func setLayout() {
        view.backgroundColor = UploadPostConst.UploadPostVC.Color.background
        
        [safeAreaBackgroundView, topSeparatorLine, gymButton, collectionView, uploadTextView, bottomSeparatorLine, submitButton, loadingOverlayView, loadingIndicator]
            .forEach { view.addSubview($0) }
        
        topSeparatorLine.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(UploadPostConst.UploadPostVC.Layout.topSeparatorHeight)
        }
        
        gymButton.snp.makeConstraints {
            $0.top.equalTo(topSeparatorLine.snp.bottom).offset(UploadPostConst.UploadPostVC.Layout.gymButtonTopOffset)
            $0.leading.equalToSuperview().offset(UploadPostConst.UploadPostVC.Layout.gymButtonLeadingOffset)
            $0.height.equalTo(UploadPostConst.UploadPostVC.Layout.gymButtonHeight)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(gymButton.snp.bottom).offset(UploadPostConst.UploadPostVC.Layout.collectionViewTopOffset)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(UploadPostConst.UploadPostVC.Layout.collectionViewHeight)
        }
        
        uploadTextView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            self.uploadTextViewBottomConstraint = $0.bottom.equalTo(bottomSeparatorLine.snp.top).constraint
        }
        
        bottomSeparatorLine.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(submitButton.snp.top).offset(UploadPostConst.UploadPostVC.Layout.bottomSeparatorTopOffset)
            $0.height.equalTo(UploadPostConst.UploadPostVC.Layout.bottomSeparatorHeight)
        }
        
        safeAreaBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(bottomSeparatorLine.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        submitButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(UploadPostConst.UploadPostVC.Layout.submitButtonBottomOffset)
            $0.leading.trailing.equalToSuperview().inset(UploadPostConst.UploadPostVC.Layout.submitButtonSideInset)
            $0.height.equalTo(UploadPostConst.UploadPostVC.Layout.submitButtonHeight)
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
        
        return updatedText.count <= UploadPostConst.UploadPostVC.Keyboard.TextLimit
    }
    
    private func bindTextView() {
        uploadTextView.textView.rx.text.orEmpty
            .map { text -> String in
                return text == UploadPostConst.UploadPostVC.Text.textViewPlaceholder ?
                String(format: UploadPostConst.UploadPostVC.Text.textViewCharCountFormat, 0) :
                String(format: UploadPostConst.UploadPostVC.Text.textViewCharCountFormat, text.count)
            }
            .bind(to: uploadTextView.textFieldCharCountLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        guard textView.textColor == UploadPostConst.UploadPostVC.Color.textViewDefault else { return }
        textView.text = nil
        textView.layer.borderColor = UploadPostConst.UploadPostVC.Color.textViewEditingBorder.cgColor
        textView.font = UploadPostConst.UploadPostVC.Font.textViewEditing
        textView.textColor = UploadPostConst.UploadPostVC.Color.textViewText
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UploadPostConst.UploadPostVC.Color.textViewDefault
            textView.text = UploadPostConst.UploadPostVC.Text.textViewPlaceholder
        }
    }
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else { return }

        let keyboardHeight = keyboardFrame.height - view.safeAreaInsets.bottom - UploadPostConst.UploadPostVC.Keyboard.extraPadding
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        ?? UploadPostConst.UploadPostVC.Keyboard.defaultAnimationDuration

        uploadTextViewBottomConstraint?.update(offset: -keyboardHeight)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc private func keyboardWillHide(_ notification: Notification) {
        let animationDuration = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
        ?? UploadPostConst.UploadPostVC.Keyboard.defaultAnimationDuration
        
        uploadTextViewBottomConstraint?.update(offset: UploadPostConst.UploadPostVC.Keyboard.defaultOffset)
        
        UIView.animate(withDuration: animationDuration) {
            self.view.layoutIfNeeded()
        }
    }
}
