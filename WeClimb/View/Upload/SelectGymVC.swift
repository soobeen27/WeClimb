//
//  SelectGymVC.swift
//  WeClimb
//
//  Created by 강유정 on 11/12/24.
//

import UIKit

import SnapKit
import RxSwift

class SelectGymVC: UIViewController {
    
    private let image: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "LogoImage"))
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = UIColor.mainPurple
        imageView.alpha = 0.7
        return imageView
    }()
    
    private let gymButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 8
        configuration.imagePlacement = .trailing
        configuration.image = UIImage(systemName: "chevron.down")
        
        var titleAttr = AttributedString.init(UploadNameSpace.selectGym)
        titleAttr.font = .systemFont(ofSize: 17.0, weight: .medium)
        configuration.attributedTitle = titleAttr
        
        let button = UIButton(configuration: configuration)
        button.tintColor = .white
        
        return button
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.setTitle(UploadNameSpace.okText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 8
        button.backgroundColor = .white
        button.isEnabled = false
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private var gymInfo: Gym?
    private let viewModel = UploadVM()
    private var uploadVC: UploadVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        selectGym()
        bindOKButton()
        setGymButton()
        
        self.uploadVC = UploadVC(uploadVM: self.viewModel, isClimbingVideo: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setLayout() {
        view.backgroundColor = .darkGray.withAlphaComponent(0.5)
        
        [image, gymButton, okButton]
            .forEach {  view.addSubview($0) }
        
        image.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().multipliedBy(0.8)
            $0.width.equalToSuperview().multipliedBy(0.35)
            $0.height.equalTo(image.snp.width)
        }
        
        gymButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(image.snp.bottom).offset(16)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    private func selectGym() {
        gymButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                let searchVC = SearchVC()
                let navigationController = UINavigationController(rootViewController: searchVC)
                navigationController.modalPresentationStyle = .pageSheet
                searchVC.ShowSegment = false
                searchVC.nextPush = false
                searchVC.onSelectedGym = { [weak self] gymInfo in
                    guard let self else { return }
                    self.gymInfo = gymInfo
                    
                    self.uploadVC?.gymView.isUserInteractionEnabled = true
                    
                    self.viewModel.updateGymData(gymInfo)
                    
                    var titleAttr = AttributedString(gymInfo.gymName)
                    titleAttr.font = .systemFont(ofSize: 17.0, weight: .medium)
                    self.gymButton.configuration?.attributedTitle = titleAttr
                    self.okButton.isEnabled = true
                    
                    self.dismiss(animated: true, completion: nil)
                }
                self.present(navigationController, animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindOKButton() {
        okButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] in
                guard let self else { return }
                if let uploadVC = self.uploadVC {
                    uploadVC.gymInfo = self.gymInfo
                    uploadVC.hidesBottomBarWhenPushed = true
                    
                    self.navigationController?.pushViewController(uploadVC, animated: true)
                    self.navigationController?.setNavigationBarHidden(false, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setGymButton() {
        self.viewModel.gymRelay
                .asDriver(onErrorJustReturn: nil)
                .filter { $0 == nil }
                .drive(onNext: { [weak self] _ in
                    guard let self else { return }
                    self.initGymButton()
                })
                .disposed(by: disposeBag)
    }
    
    private func initGymButton() {
        var configuration = UIButton.Configuration.plain()
        configuration.imagePadding = 8
        configuration.imagePlacement = .trailing
        configuration.image = UIImage(systemName: "chevron.down")
        
        var titleAttr = AttributedString.init(UploadNameSpace.selectGym)
        titleAttr.font = .systemFont(ofSize: 17.0, weight: .medium)
        configuration.attributedTitle = titleAttr
        
        gymButton.configuration = configuration
        gymButton.tintColor = .white
    }
}
