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
        button.tintColor = .systemBackground

        return button
    }()
    
    private let okButton: UIButton = {
        let button = UIButton()
        button.setTitle(UploadNameSpace.okText, for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 23
        button.backgroundColor = .white
        button.isEnabled = false
        return button
    }()
    
    private let disposeBag = DisposeBag()
    private var gymInfo: Gym?
//    private let uploadVC = UploadVC(isClimbingVideo: true)
    private let uploadVM = UploadVM()
    private var uploadVC: UploadVC?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        selectGym()
        bindOKButton()
        
        uploadVC = UploadVC(uploadVM: uploadVM, isClimbingVideo: true)
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
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-view.frame.height * 0.03)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
            $0.height.equalTo(view.frame.height * 0.055)
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
                searchVC.onSelectedGym = { gymInfo in
                    self.gymInfo = gymInfo
//                    self.uploadVM.optionSelectedGym(gymInfo)
                    self.uploadVC?.setgradeButton(with: gymInfo)
//                    self.uploadVC.setSectorButton(with: gymInfo)
                    //                    self.uploadVC.gymInfo = gymInfo
//                    self.uploadVM.gymRelay.accept(gymInfo)
                    self.uploadVM.updateGymData(gymInfo)
                    
                    self.uploadVC?.gymView.isUserInteractionEnabled = true
                    self.uploadVC?.gymLabel.text = gymInfo.gymName
                    
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
                guard let self = self else { return }
                if let uploadVC = self.uploadVC {
//                    uploadVC = UploadVC(uploadVM: self.uploadVM, isClimbingVideo: true)
                    uploadVC.gymInfo = self.gymInfo
                    
                    self.navigationController?.pushViewController(uploadVC, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
