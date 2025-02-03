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
    
    //    let button : RectangleIconButton = {
    //        let button = RectangleIconButton()
    //        button.layer.cornerRadius = 10
    //       return button
    //    }()
    
    private let gymItem: SearchResultItem
    
    var gymInfo: Gym?
    
//    private let viewModel: UploadVM
//    private let isClimbingVideo: Bool
    
    private let disposeBag = DisposeBag()
    private var feedView: FeedView?
    
    private lazy var scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.backgroundColor = UIColor.fillSolidDarkBlack
        scroll.addSubview(contentView)
        return scroll
    }()
    
    let uploadOptionView = UploadOptionView()
    
    private lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fillSolidDarkBlack
        [selectedMediaView, callPHPickerButton, textView, loadingIndicator, uploadOptionView]
            .forEach {
                view.addSubview($0)
            }
        return view
    }()
    
    private lazy var selectedMediaView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.fillSolidDarkBlack
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
    
//    let gymLabel: UILabel = {
//        let label = UILabel()
//        label.font = .systemFont(ofSize: 16, weight: .bold)
//        label.textColor = .label
//        label.textAlignment = .center
//        label.numberOfLines = 1
//        label.layer.zPosition = 1
//        label.font = .systemFont(ofSize: 15)
//        return label
//    }()
    
//    private let gradeButton: UIButton = {
//        var configuration = UIButton.Configuration.plain()
//        
//        var titleAttr = AttributedString()
//        titleAttr.font = .systemFont(ofSize: 15.0)
//        configuration.attributedTitle = titleAttr
//        
//        let image = UIImage(systemName: "square.fill")?
//            .withConfiguration(UIImage.SymbolConfiguration(pointSize: 23, weight: .regular, scale: .large))
//        configuration.image = image
//        configuration.imagePadding = 5
//        configuration.imagePlacement = .leading
//        configuration.baseForegroundColor = .clear
//        
//        let button = UIButton(configuration: configuration)
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = UIColor.gray.cgColor
//        button.layer.cornerRadius = 18
//        button.layer.zPosition = 1
//        button.isHidden = true
//        button.setTitleColor(.label, for: .normal)
//        button.backgroundColor = .clear
////        button.backgroundColor = UIColor {
////            switch $0.userInterfaceStyle {
////            case .dark:
////                return UIColor.secondarySystemBackground
////            default:
////                return UIColor.white
////            }
////        }
//        
//        return button
//    }()
    
//    private let holdButton: UIButton = {
//        var configuration = UIButton.Configuration.plain()
//        
//        var titleAttr = AttributedString()
//        titleAttr.font = .systemFont(ofSize: 15.0)
//        configuration.attributedTitle = titleAttr
//
//         if let defaultImage = UIImage(named: "square.fill") {
//             let resizedImage = defaultImage.resize(targetSize: CGSize(width: 25, height: 25))
//             configuration.image = resizedImage
//         }
//        configuration.imagePadding = 5
//        configuration.imagePlacement = .leading
//        configuration.baseForegroundColor = .clear
//        
//        let button = UIButton(configuration: configuration)
//        button.layer.borderWidth = 0.5
//        button.layer.borderColor = UIColor.gray.cgColor
//        button.layer.cornerRadius = 18
//        button.layer.zPosition = 1
//        button.isHidden = true
//        button.imageView?.contentMode = .scaleAspectFit
//        button.setTitleColor(.label, for: .normal)
//        button.backgroundColor = .clear
////        button.backgroundColor = UIColor {
////            switch $0.userInterfaceStyle {
////            case .dark:
////                return UIColor.secondarySystemBackground
////            default:
////                return UIColor.white
////            }
////        }
//        
//        return button
//    }()
    
    private let textView: UITextView = {
        let textView = UITextView()
        textView.font = .systemFont(ofSize: 15)
        textView.textColor = .secondaryLabel
        textView.text = UploadNameSpace.placeholder
        textView.backgroundColor = UIColor.fillSolidDarkBlack
        textView.returnKeyType = .done
        return textView
    }()
    
//    private lazy var postButton: UIButton = {
//        let button = UIButton()
//        button.setTitle(UploadNameSpace.post, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
//        button.backgroundColor = .mainPurple // 앱 틴트 컬러
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//
//        return button
//    }()
    
//    private let backButton: UIButton = {
//        let button = UIButton()
//        button.setTitle(UploadNameSpace.post, for: .normal)
//        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .regular)
//        button.backgroundColor = UIColor.init(hex: "313235") //FillSolidDarkLight
//        button.layer.cornerRadius = 10
//        button.clipsToBounds = true
//        
//        return button
//    }()
    
    private lazy var loadingIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.hidesWhenStopped = true
        return indicator
    }()
    
    private var isCurrentScreenActive: Bool = false
    private var isUploading = false
    
    private var loadingOverlay: UIView?

    init(gymItem: SearchResultItem) {
        self.gymItem = gymItem
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setNavigation()
    }
    
//    private func setNavigation() {
//        navigationController?.setNavigationBarHidden(false, animated: false)
//        navigationController?.navigationBar.barTintColor = UIColor.fillSolidDarkBlack
//        navigationItem.title = "선택"
//        let backIcon = UIImage(named: "closeIcon")?.withRenderingMode(.alwaysOriginal)
//        let backButton = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(didTapBackButton))
//        navigationItem.leftBarButtonItem = backButton
//    }

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
        let backButton = UIBarButtonItem(image: backIcon, style: .plain, target: self, action: #selector(didTapBackButton))
        backButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = backButton
    }

    
    @objc private func didTapBackButton() {
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
    
    func phpickerVCPresent() {
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 10
        configuration.filter = .any(of: [.images, .videos])
        configuration.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: configuration)
//        picker.delegate = self
        self.present(picker, animated: true, completion: nil)
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.fillSolidDarkStrong
        scrollView.contentSize = contentView.frame.size

        [scrollView]
            .forEach {
                view.addSubview($0)
            }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalTo(scrollView.contentLayoutGuide)
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.bottom.equalTo(view.safeAreaLayoutGuide)
        }
        
//        gymLabel.snp.makeConstraints {
//            $0.top.equalTo(gymView.snp.top)
//            $0.height.equalTo(gymView.snp.height)
//            $0.trailing.equalTo(gymView.snp.trailing).offset(-16)
//        }
        
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
            $0.size.equalTo(CGSize(width: 48, height: 48))
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
        
        uploadOptionView.snp.makeConstraints {
//            $0.top.equalTo(textView.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
//        gymView.snp.makeConstraints {
//            $0.top.equalTo(textView.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//        }
//        
//        settingView.snp.makeConstraints {
//            $0.top.equalTo(gymView.snp.bottom)
//            $0.leading.trailing.equalToSuperview()
//        }
//        
//        gradeButton.snp.makeConstraints {
//            $0.top.equalTo(settingView.snp.top).inset(8)
//            $0.bottom.equalTo(settingView.snp.bottom).inset(8)
//            $0.centerY.equalTo(settingView.snp.centerY)
////            $0.height.equalTo(settingView.snp.height).multipliedBy(0.8)
////            $0.trailing.equalTo(settingView.snp.trailing).offset(-8)
//        }
//        
//        holdButton.snp.makeConstraints {
//            $0.top.equalTo(settingView.snp.top).inset(8)
//            $0.bottom.equalTo(settingView.snp.bottom).inset(8)
//            $0.centerY.equalTo(settingView.snp.centerY)
////            $0.height.equalTo(settingView.snp.height).multipliedBy(0.8)
//            $0.leading.equalTo(gradeButton.snp.trailing).offset(8)
//            $0.trailing.equalTo(settingView.snp.trailing).offset(-8)
//        }
        
        loadingIndicator.snp.makeConstraints {
            $0.center.equalTo(selectedMediaView.snp.center)
        }
    }
    
}
