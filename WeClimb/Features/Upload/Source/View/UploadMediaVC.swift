//
//  UploadMediaVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import AVKit
import PhotosUI
import UIKit

import RxCocoa
import RxRelay
import RxSwift
import SnapKit

class UploadMediaVC: UIViewController {
    var coordinator: UploadMediaCoordinator?
    
    var onBackButton: (() -> Void)?
    var onNextButton: (() -> Void)?
    
    var onLevelFilter: ((String) -> String)?
    var onHoldFilter: ((String) -> String)?
    
    var selectedMediaItems: [PHPickerResult] = []
    
    var gymInfo: Gym?
    
    lazy var gymButton: UIButton = {
        var config = UIButton.Configuration.plain()
        config.title = gymItem.name
        config.image = UIImage.locationIconFill.resize(targetSize: CGSize(width: 12, height: 12))?
            .withTintColor(UIColor.white, renderingMode: .alwaysOriginal)
        config.baseForegroundColor = UIColor.white
        config.baseBackgroundColor = UIColor.init(hex: "313235", alpha: 0.4) // fillOpacityDarkHeavy
        config.titleAlignment = .trailing
        config.imagePlacement = .leading
        config.imagePadding = 4
        
        var titleAttributes = AttributedString(gymItem.name)
        titleAttributes.font = UIFont.customFont(style: .caption1Medium)
        
        config.attributedTitle = titleAttributes
        
        let button = UIButton(configuration: config)
        button.tintColor = .white
        button.layer.zPosition = 1
        button.backgroundColor = UIColor.init(hex: "313235", alpha: 0.4) // fillOpacityDarkHeavy
        button.layer.cornerRadius = 8
        
        return button
    }()
    
    private let separatorLine: UIView = {
        let view = UIView()
        view.backgroundColor = .lineOpacityNormal
        return view
    }()
    
    private let gymItem: SearchResultItem
    
    private let viewModel: UploadVM
    
    private let disposeBag = DisposeBag()
    private var uploadFeedView: UploadFeedView?
    
    let uploadOptionView = UploadOptionView()
    
    private lazy var selectedMediaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fillSolidDarkBlack
        view.addSubview(callPHPickerButton)
        return view
    }()
    
    private lazy var callPHPickerButton: UIButton = {
        let button = UIButton()
        let imageAddIcon = UIImage.imageAddIcon.resize(targetSize: CGSize(width: 20, height: 20))?
            .withTintColor(UIColor.labelNormal, renderingMode: .alwaysOriginal)
        button.setImage(imageAddIcon, for: .normal)
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
    
    private lazy var safeAreaBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fillSolidDarkStrong
        return view
    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private let mediaItemsSubject = PublishSubject<[PHPickerResult]>()
    private let selectedGradeSubject = BehaviorSubject<String>(value: "")
    private let selectedHoldSubject = BehaviorSubject<String?>(value: nil)
    
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
        
        bindViewModel()
        setLayout()
        setNavigation()
        bindOptionButtonActions()
    }
    
    private func setNavigation() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        navigationController?.navigationBar.barStyle = .default
        navigationController?.navigationBar.barTintColor = UIColor.fillSolidDarkBlack
        
        navigationItem.title = "선택"
        
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
            self?.tabBarController?.selectedIndex = 0
            self?.tabBarController?.tabBar.isHidden = false
            UIView.animate(withDuration: 0.1, animations: {
                self?.tabBarController?.tabBar.alpha = 1
            })
        }
        
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        present(alert, animated: false, completion: nil)
    }
    
    private func phpickerVCPresent() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .any(of: [.images, .videos])
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func bindViewModel() {
        let input = UploadVM.Input(
            mediaSelection: mediaItemsSubject.asObservable(),
            gradeSelection: selectedGradeSubject.asObservable(),
            holdSelection: selectedHoldSubject.asObservable()
        )
        
        let output = viewModel.transform(input: input)
        
        output.mediaItems
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] mediaItems in
                guard let self = self else { return }

                if mediaItems.isEmpty {
                    print("선택된 미디어 없음")
                    self.uploadFeedView?.removeFromSuperview()
                    self.callPHPickerButton.isHidden = false
                } else {
                    self.reloadMediaUI()
                }
            })
            .disposed(by: disposeBag)
        
        output.selectedGrade
            .bind(onNext: { grade in
//                print("선택된 등급: \(grade)")
            })
            .disposed(by: disposeBag)
        
        output.selectedHold
            .bind(onNext: { hold in
//                print("선택된 홀드: \(hold ?? "없음")")
            })
            .disposed(by: disposeBag)
    }
    
    private func reloadMediaUI() {
        self.uploadFeedView?.removeFromSuperview()

        let feed = UploadFeedView(frame: CGRect(origin: .zero, size: CGSize(width: self.view.frame.width, height: self.view.frame.width)),
                                  viewModel: self.viewModel)
        self.uploadFeedView = feed
        self.callPHPickerButton.isHidden = true
        self.selectedMediaView.addSubview(feed)

        feed.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    private func bindOptionButtonActions() {
        uploadOptionView.didTapBackButton = { [weak self] in
            self?.onBackButton?()
        }
        uploadOptionView.didTapNextButton = { [weak self] in
            self?.onNextButton?()
        }
        
        uploadOptionView.selectedLevelButton = { [weak self] in
            guard let self = self else { return }
            _ = self.onLevelFilter?(self.gymItem.name)
        }

        uploadOptionView.selectedHoldButton = { [weak self] in
            guard let self = self else { return }
            _ = self.onHoldFilter?(self.gymItem.name)
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
            $0.height.equalTo(1)
        }
        
        gymButton.snp.makeConstraints {
            $0.top.equalTo(separatorLine.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.height.equalTo(26)
        }
        
        selectedMediaView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(uploadOptionView.snp.top)
        }
        
        callPHPickerButton.snp.makeConstraints {
            $0.centerX.equalTo(selectedMediaView.snp.centerX)
            $0.centerY.equalTo(selectedMediaView.snp.centerY)
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
        let mediaData: [(index: Int, mediaItem: PHPickerResult)] = results.enumerated().map { (index, mediaItem) in
            return (index, mediaItem)
        }
        
        let pickedMediaItems = mediaData.map { $0.mediaItem }
        
        mediaItemsSubject.onNext(pickedMediaItems)

        picker.dismiss(animated: true)
    }
}
