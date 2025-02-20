//
//  UploadMediaVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import AVKit
import PhotosUI
import UIKit

import RxSwift
import SnapKit

class UploadMediaVC: UIViewController {
    var coordinator: UploadMediaCoordinator?
    
    var onBackButton: (() -> Void)?
    var onNextButton: (([MediaUploadData]) -> Void)?
    
    var onLevelFilter: ((String) -> String)?
    var onHoldFilter: ((String) -> String)?
    
    var selectedMediaItems: [PHPickerResult] = []
    
    var gymInfo: Gym?
    
    lazy var gymButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = gymItem.name
        config.image = UploadMediaConst.UploadMediaVC.Image.gymBtn
        config.baseForegroundColor = UploadMediaConst.UploadMediaVC.Color.gymBtnBaseForeground
        config.baseBackgroundColor = UploadMediaConst.UploadMediaVC.Color.gymBtnbaseBackground
        config.titleAlignment = .trailing
        config.imagePlacement = .leading
        config.imagePadding = UploadMediaConst.UploadMediaVC.Size.gymButtonImagePadding
        
        var titleAttributes = AttributedString(gymItem.name)
        titleAttributes.font = UploadMediaConst.UploadMediaVC.Font.gymButton
        
        config.attributedTitle = titleAttributes
        
        let button = UIButton(configuration: config)
        button.tintColor = .white
        button.layer.zPosition = UploadMediaConst.UploadMediaVC.Size.gymButtonZPosition
        button.backgroundColor = UploadMediaConst.UploadMediaVC.Color.gymBtnbaseBackground
        button.layer.cornerRadius = UploadMediaConst.UploadMediaVC.Size.gymButtonCornerRadius
        
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = UploadMediaConst.UploadMediaVC.Color.separatorLine
        return view
    }()
    
    private let gymItem: SearchResultItem
    
    private let viewModel: UploadVM
    
    private let disposeBag = DisposeBag()
    private var uploadFeedView: UploadFeedView?
    private let uploadOptionView = UploadOptionView()
    
    private lazy var selectedMediaView: UIView = {
        let view = UIView()
        view.backgroundColor = UploadMediaConst.UploadMediaVC.Color.mediaView
        view.addSubview(callPHPickerButton)
        return view
    }()
    
    private lazy var callPHPickerButton: UIButton = {
        let button = UIButton()
        let imageAddIcon = UploadMediaConst.UploadMediaVC.Image.PHPickerBtn
        button.setImage(imageAddIcon, for: .normal)
        button.layer.cornerRadius = UploadMediaConst.UploadMediaVC.Size.PHPickerBtnCornerRadius
        button.imageView?.contentMode = .center
        button.contentHorizontalAlignment = .center
        button.contentVerticalAlignment = .center
        button.rx.tap
            .bind { [weak self] in
                self?.phpickerVCPresent()
            }
            .disposed(by: disposeBag)
        return button
    }()
    
    private lazy var safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UploadMediaConst.UploadMediaVC.Color.safeAreaBackgroundView
        return view
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let mediaItemsSubject = PublishSubject<[PHPickerResult]>()
    private var selectedGradeSubject = BehaviorSubject<String>(value: "")
    private let selectedHoldSubject = BehaviorSubject<String?>(value: nil)
    private let selectedMediaIndexSubject = BehaviorSubject<Int>(value: 0)
    
    private var shouldFeedUpdateUI = true
    
    var onDismiss: (() -> Void)?
    
    init(gymItem: SearchResultItem, viewModel: UploadVM) {
        self.gymItem = gymItem
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        selectedMediaItems.removeAll()
        mediaItemsSubject.onNext([])
        
        bindViewModel()
        setLayout()
        setNavigation()
        bindOptionButtonActions()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        VideoManager.shared.UploadStopVideo()
    }
    
    private func setNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.fillSolidDarkBlack
        
        navigationItem.title = UploadMediaConst.UploadMediaVC.Text.navigationTitle
        
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: UploadMediaConst.UploadMediaVC.Color.navigationForeground,
            .font: UploadMediaConst.UploadMediaVC.Font.navigation
        ]
        
        let closeIcon = UploadMediaConst.UploadMediaVC.Image.navigationCloseIcon
        let closeButton = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action: #selector(didTapCloseButton))
        closeButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = closeButton
    }
   
    @objc private func didTapCloseButton() {
        showAlert(title: UploadMediaConst.UploadMediaVC.Text.closeAlertTitle,
                  message: UploadMediaConst.UploadMediaVC.Text.closeAlertMessage,
                  CustomBtnTitle: UploadMediaConst.UploadMediaVC.Text.AlertDelete) { [weak self] in
            self?.onDismiss?()
        }
    }
    
    private func phpickerVCPresent() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = UploadMediaConst.UploadMediaVC.PHPicker.selectionLimit
        configuration.filter = .any(of: [.images, .videos])
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func bindViewModel() {
        let input = UploadVMImpl.Input(
            mediaSelection: mediaItemsSubject.asObservable(),
            gradeSelection: selectedGradeSubject
                .distinctUntilChanged()
                .flatMapLatest { grade in
                    self.selectedMediaIndexSubject
                        .take(1)
                        .map { index in (index, grade) }
                },
            holdSelection: selectedHoldSubject
                .distinctUntilChanged()
                .flatMapLatest { hold in
                    self.selectedMediaIndexSubject
                        .take(1)
                        .map { index in (index, hold) }
                },
            selectedMediaIndex: selectedMediaIndexSubject.distinctUntilChanged()
        )
        
        let output = viewModel.transform(input: input)
        
        output.mediaItems
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] mediaItems in
                guard let self = self, self.shouldFeedUpdateUI else { return }
                
                if mediaItems.isEmpty {
                    self.uploadFeedView?.removeFromSuperview()
                    self.callPHPickerButton.isHidden = false
                } else {
                    self.reloadMediaUI()
                }
            })
            .disposed(by: disposeBag)
        
        output.alertTrigger
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] (title, message) in
                self?.showAlert(title: title, message: message)
            })
            .disposed(by: disposeBag)
        
        
        selectedMediaIndexSubject
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] index in
                guard let self = self else { return }
                
                let mediaList = self.viewModel.mediaUploadDataRelay.value
                guard index >= 0, index < mediaList.count else { return }

                let selectedMedia = mediaList[index]
                
                self.uploadOptionView.updateOptionView(
                    grade: selectedMedia.grade,
                    hold: selectedMedia.hold ?? ""
                )
            })
            .disposed(by: disposeBag)
        
        viewModel.mediaUploadDataRelay
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] mediaList in
                guard let self = self else { return }

                let currentIndex = (try? self.selectedMediaIndexSubject.value()) ?? 0
                guard currentIndex >= 0, currentIndex < mediaList.count else { return }

                let selectedMedia = mediaList[currentIndex]
                
                self.uploadOptionView.updateOptionView(
                    grade: selectedMedia.grade,
                    hold: selectedMedia.hold
                )
            })
            .disposed(by: disposeBag)

        }

    private func reloadMediaUI() {
        if shouldFeedUpdateUI {
            self.uploadFeedView?.removeFromSuperview()
            
            let feed = UploadFeedView(frame: selectedMediaView.bounds, viewModel: self.viewModel)
            self.uploadFeedView = feed
            self.callPHPickerButton.isHidden = true
            self.selectedMediaView.addSubview(feed)
            
            feed.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
            
            shouldFeedUpdateUI = false
        }
        
        self.uploadFeedView?.onMediaIndexChanged = { [weak self] index in
            self?.selectedMediaIndexSubject.onNext(index)
        }
    }
    
    private func showAlert(title: String, message: String, CustomBtnTitle: String = UploadMediaConst.UploadMediaVC.Text.AlertConfirm, onConfirmAction: (() -> Void)? = nil) {
        let alert = DefaultAlertVC(alertType: .titleDescription, interfaceStyle: .dark)
        alert.setTitle(title, message)
        alert.setCustomButtonTitle(CustomBtnTitle)
        alert.customButtonTitleColor = UploadMediaConst.UploadMediaVC.Color.alertCustomBtnTitle
        
        alert.customAction = onConfirmAction

        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: false, completion: nil)
    }

    
    private func bindOptionButtonActions() {
        uploadOptionView.didTapBackButton = { [weak self] in
            self?.onBackButton?()
            VideoManager.shared.UploadStopVideo()
        }
        
        uploadOptionView.didTapNextButton = { [weak self] in
            guard let self = self else { return }
            
            let selectedMediaItems = self.viewModel.mediaUploadDataRelay.value
            
            if selectedMediaItems.isEmpty {
                self.showAlert(
                    title: UploadMediaConst.UploadMediaVC.Text.emptyMediaTitle,
                    message: UploadMediaConst.UploadMediaVC.Text.emptyMediaMessage
                )
                return
            }
            
            let hasMissingSelection = selectedMediaItems.contains { ($0.grade?.isEmpty ?? true) || $0.hold == nil }
            
            if hasMissingSelection {
                self.showAlert(
                    title: UploadMediaConst.UploadMediaVC.Text.missingSelectionTitle,
                    message: UploadMediaConst.UploadMediaVC.Text.missingSelectionMessage
                )
            } else {
                self.onNextButton?(selectedMediaItems)
                VideoManager.shared.UploadStopVideo()
            }
        }
        
        uploadOptionView.selectedLevelButton = { [weak self] in
            guard let self = self else { return }
            
            let selectedMediaItems = self.viewModel.mediaUploadDataRelay.value
            
            if selectedMediaItems.isEmpty {
                self.showAlert(
                    title: UploadMediaConst.UploadMediaVC.Text.noMediaForFilterTitle,
                    message: UploadMediaConst.UploadMediaVC.Text.noMediaForFilterMessage
                )
            } else {
                _ = self.onLevelFilter?(self.gymItem.name)
                VideoManager.shared.UploadStopVideo()
            }
        }
        
        uploadOptionView.selectedHoldButton = { [weak self] in
            guard let self = self else { return }
            
            let selectedMediaItems = self.viewModel.mediaUploadDataRelay.value
            
            if selectedMediaItems.isEmpty {
                self.showAlert(
                    title: UploadMediaConst.UploadMediaVC.Text.noMediaForFilterTitle,
                    message: UploadMediaConst.UploadMediaVC.Text.noMediaForFilterMessage
                )
            } else {
                _ = self.onHoldFilter?(self.gymItem.name)
                VideoManager.shared.UploadStopVideo()
            }
        }
        
        coordinator?.onLevelHoldFiltersApplied = { [weak self] levelFilters, holdFilters in
            guard let self = self else { return }
            
            let currentIndex = (try? self.selectedMediaIndexSubject.value()) ?? 0
            var mediaList = self.viewModel.mediaUploadDataRelay.value
            
            guard currentIndex >= 0, currentIndex < mediaList.count else { return }
            
            var selectedMedia = mediaList[currentIndex]
            
            let previousGrade = selectedMedia.grade ?? ""
            let previousHold = selectedMedia.hold ?? ""
            
            let convertedGrade = levelFilters.isEmpty ? previousGrade : LHColors.fromKoreanFull(levelFilters).toEng()
            let convertedHold = holdFilters.isEmpty ? previousHold : LHColors.fromKoreanFull(holdFilters).toHoldEng()
            
            if previousGrade != convertedGrade {
                self.selectedGradeSubject.onNext(convertedGrade)
                selectedMedia.grade = convertedGrade
            }
            if previousHold != convertedHold {
                self.selectedHoldSubject.onNext(convertedHold)
                selectedMedia.hold = convertedHold
            }
            
            mediaList[currentIndex] = selectedMedia
            self.viewModel.mediaUploadDataRelay.accept(mediaList)
            
            self.uploadOptionView.updateOptionView(
                grade: selectedMedia.grade,
                hold: selectedMedia.hold
            )
            
            self.uploadFeedView?.updateCurrentIndex()
        }
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.fillSolidDarkBlack
        
        [separatorLine, gymButton, selectedMediaView, callPHPickerButton, loadingIndicator, uploadOptionView, safeAreaBackgroundView]
            .forEach {
                view.addSubview($0)
            }
        
        separatorLine.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.height.equalTo(UploadMediaConst.UploadMediaVC.Layout.separatorLineHeight)
        }
        
        gymButton.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(UploadMediaConst.UploadMediaVC.Layout.gymButtonTop)
            $0.leading.equalToSuperview().offset(UploadMediaConst.UploadMediaVC.Layout.gymButtonLeading)
            $0.height.equalTo(UploadMediaConst.UploadMediaVC.Layout.gymButtonHeight)
        }
        
        selectedMediaView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(uploadOptionView.snp.top)
        }
        
        callPHPickerButton.snp.makeConstraints {
            $0.centerX.equalTo(selectedMediaView.snp.centerX)
            $0.centerY.equalTo(selectedMediaView.snp.centerY)
            $0.width.height.equalTo(UploadMediaConst.UploadMediaVC.Layout.PHPickerButtonSize)
        }
        
        uploadOptionView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        safeAreaBackgroundView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.top.equalTo(uploadOptionView.snp.bottom)
            $0.bottom.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalTo(selectedMediaView.snp.center)
        }
    }
}

extension UploadMediaVC: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {

        self.mediaItemsSubject.onNext(results)
        
        picker.dismiss(animated: true)
    }
}

