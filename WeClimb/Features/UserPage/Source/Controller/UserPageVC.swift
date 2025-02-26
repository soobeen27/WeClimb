//
//  UserPageVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import Kingfisher
import SnapKit
import RxCocoa
import RxSwift

enum UserPageEvent {
    case showProfileSetting
    case showHomeGymSetting
}

class UserPageVC: UIViewController {
    var coordinator: UserPageCoordinator?
    
    private let disposeBag = DisposeBag()
    
    //    private let userPageVM: UserPageVM
    private let userFeedPageVM: UserFeedPageVM
    //    private let userSummaryPageVM: UserSummaryPageVM
    
    init(coordinator: UserPageCoordinator? = nil, userFeedPageVM: UserFeedPageVM /*userSummaryPageVM: UserSummaryPageVM*/) {
        self.coordinator = coordinator
        self.userFeedPageVM = userFeedPageVM
        //        self.userSummaryPageVM = userSummaryPageVM
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - 유저 정보
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "WeClimb"
        label.font = UserPageConst.userInfo.Font.userNameLabelFont
        label.textColor = UserPageConst.userInfo.Color.userNameLabelColor
        return label
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UserPageConst.userInfo.Image.baseImage
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 40
        return imageView
    }()
    
    private let userInfoLabel: UILabel = {
        let label = UILabel()
        label.font = UserPageConst.userInfo.Font.userInfoLabelFont
        label.textColor = UserPageConst.userInfo.Color.userInfoLabelColor
        return label
    }()
    
    private let homeGymButtonView: UIView = {
        let view = UIView()
        view.backgroundColor = UserPageConst.userInfo.Color.homeGymbackgroundColor
        view.layer.cornerRadius = 8
        return view
    }()
    
    private let homeGymButtonStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .horizontal
        stv.alignment = .center
        stv.distribution = .equalSpacing
        stv.spacing = 5
        return stv
    }()
    
    private let homeImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UserPageConst.userInfo.Image.homeImage
        return imageView
    }()
    
    private let homeGymButtonText: UILabel = {
        let label = UILabel()
        label.text = UserPageConst.userInfo.Text.homeGymSettingText
        label.font = UserPageConst.userInfo.Font.homeGymSettingTextFont
        label.textColor = UserPageConst.userInfo.Color.homeGymSettingColor
        label.setContentHuggingPriority(.required, for: .horizontal)
        return label
    }()
    
    private let chevronRightImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UserPageConst.userInfo.Image.chevronRightImage
        return imageView
    }()
    
    
    private let userEditButton: UIButton = {
        let button = UIButton()
        button.setTitle(UserPageConst.userInfo.Text.editButtonText, for: .normal)
        button.setTitleColor(UserPageConst.userInfo.Color.userEditButtonColor, for: .normal)
        button.titleLabel?.font = UserPageConst.userInfo.Font.userInfoLabelFont
        return button
    }()
    
    private let segmentedControl: CustomSegmentedControl = {
        let segCon = CustomSegmentedControl(items: ["피드"])
        return segCon
    }()
    
    private let indicatorBar: UIView = {
        let view = UIView()
        view.backgroundColor = UserPageConst.userInfo.Color.indicatorBarColor
        return view
    }()
    
    // MARK: - 피드 세그먼트
    
    // 피드쪽 날짜(월) 필터
    private let userFeedtableView: UITableView = {
        let tableView = UITableView()
        tableView.register(UserFeedTableCell.self, forCellReuseIdentifier: "UserFeedTableCell")
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .clear
        return tableView
    }()
    
    // MARK: - 기록 세그먼트
    private let favoritGymTitle: UILabel = {
        let label = UILabel()
        label.text = "즐겨찾기"
        return label
    }()
    
    private let favoriteGym: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        return button
    }()
    
    private let favoriteGymEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("관리", for: .normal)
        return button
    }()
    
    private let currentMonthStatisticsTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "이번 달 통계"
        return label
    }()
    
    private let homeGymLabel: UILabel = {
        let label = UILabel()
        label.text = "홈 암장"
        return label
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindTableFeed()
        bindUserInfo()
        mainFeedConnecting()
        bindUserEditButton()
        bindHomeGymButton()
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.white
        userInfoLayout()
        feedLayout()
    }
    
    private func userInfoLayout() {
        //        [
        //            userHeightInfo,
        //            userArmReachInfo,
        //        ].forEach { userInfoLabel.addArrangedSubview($0) }
        homeGymButtonView.addSubview(homeGymButtonStackView)
        
        [
            homeImageView,
            homeGymButtonText,
            chevronRightImageView
        ].forEach { homeGymButtonStackView.addArrangedSubview($0) }
        
        [
            userNameLabel,
            userImageView,
            userInfoLabel,
            homeGymButtonView,
            userEditButton,
            indicatorBar,
            segmentedControl,
        ].forEach { view.addSubview($0) }
        
        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.height.width.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(12)
            $0.trailing.equalTo(userEditButton.snp.leading)
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
        }
        
        userInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(2)
        }
        
        homeGymButtonView.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel)
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(12)
            $0.width.equalTo(116)
            $0.height.equalTo(26)
        }
        
        homeGymButtonStackView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        userEditButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        indicatorBar.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(userImageView.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(44)
        }
    }
    
    private func feedLayout() {
        [
            userFeedtableView,
        ].forEach { view.addSubview($0) }
        
        userFeedtableView.snp.makeConstraints {
            $0.top.equalTo(indicatorBar.snp.bottom)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindTableFeed() {
        let input = UserFeedPageVMImpl.Input()
        let output = userFeedPageVM.transform(input: input)
        
        input.fetchUserFeedTrigger.accept(())
        
        output.userFeedList
            .observe(on: MainScheduler.instance)
            .bind(to: userFeedtableView.rx.items(cellIdentifier: UserFeedTableCell.identifier, cellType: UserFeedTableCell.self)) { _, viewModel, cell in
                cell.configure(with: viewModel)
            }
            .disposed(by: disposeBag)
        
        userFeedtableView.rx.itemSelected
            .subscribe(onNext: { [weak self] indexPath in
                self?.userFeedtableView.deselectRow(at: indexPath, animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func mainFeedConnecting() {
        let input = UserFeedPageVMImpl.Input()
        let output = userFeedPageVM.transform(input: input)
        
        userFeedtableView.rx.itemSelected
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let self else { return }
                
                let allPosts = convertToPosts(from: output.userFeedList.value)
                
                guard !allPosts.isEmpty else { return }

                print("선택된 셀 인덱스: \(indexPath.row)")
                
                let postType = PostType.userPage(
                    post: BehaviorSubject(value: allPosts),
                    startIndex: BehaviorRelay(value: indexPath.row)
                )

                coordinator?.showFeed(postType: postType)
            })
            .disposed(by: disposeBag)
    }
    
    private func bindUserInfo() {
        let input = UserFeedPageVMImpl.Input()
        let output = userFeedPageVM.transform(input: input)
        
        input.fetchUserInfoTrigger.accept(())
        
        output.userInfo
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] user in
                guard let self = self else { return }
                
                self.userNameLabel.text = user.userName ?? "이름 없음"
                
                let height = user.height
                let armReach = user.armReach ?? nil
                
                self.userInfoLabel.text = self.heightArmReach(height: height, armReach: armReach)
                
                if let imageURL = user.profileImage, let url = URL(string: imageURL) {
                    self.userImageView.kf.setImage(with: url)
                } else {
                    self.userImageView.image = UIImage.wecilmbProfile
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func bindHomeGymButton() {
        let tapGesture = UITapGestureRecognizer()
        homeGymButtonView.addGestureRecognizer(tapGesture)

        tapGesture.rx.event
            .subscribe(onNext: { [weak self] _ in
                self?.coordinator?.handleEvent(.showHomeGymSetting)
            })
            .disposed(by: disposeBag)
    }
    
    private func convertToPosts(from cellVMs: [UserFeedTableCellVM]) -> [Post] {
        return cellVMs.compactMap { ($0 as? UserFeedTableCellVMImpl)?.postWithHold.post }
    }
    
    private func bindUserEditButton() {
        userEditButton.rx.tap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.coordinator?.handleEvent(.showProfileSetting)
            })
            .disposed(by: disposeBag)
    }

//    private func bindHomeGymButton() {
//        homeGymButtonStackView.rx.tapGesture()
//            .when(.recognized)
//            .subscribe(onNext: { [weak self] _ in
//                self?.coordinator?.handleEvent(.showHomeGymSetting)
//            })
//            .disposed(by: disposeBag)
//    }
    
    private func heightArmReach(height: Int?, armReach: Int?) -> String {
        if let height, let armReach {
            return "\(height)cmㆍ\(armReach)cm"
        } else if let height {
            return "\(height)cm"
        }
        return "정보가 없어용"
    }
}
