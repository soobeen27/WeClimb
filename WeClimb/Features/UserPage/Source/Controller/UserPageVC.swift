//
//  UserPageVC.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class UserPageVC: UIViewController {
    var coordinator: UserPageCoordinator?
    
    // MARK: - 유저 정보
    private let userNameLabel: UILabel = {
      let label = UILabel()
        label.text = "WeClimb"
        return label
    }()
    
    private let userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.circle")
        return imageView
    }()
    
    private let userInfoLabel: UILabel = {
        let label = UILabel()
        label.text = "180cm.212cm"
        return label
    }()
    
    private let homeGymButton: UIButton = {
        let button = UIButton()
        button.setTitle("홈짐 설정하기", for: .normal)
        button.tintColor = .black
        return button
    }()
    
    private let userEditButton: UIButton = {
        let button = UIButton()
        button.setTitle("편집", for: .normal)
        return button
    }()
    
    private let segmentedControl: CustomSegmentedControl = {
        let segCon = CustomSegmentedControl(items: ["요약", "피드"])
        return segCon
    }()
    
    private let indicatorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .gray
        return view
    }()
    
    // MARK: - 피드 세그먼트
    
    // 피드쪽 날짜(월) 필터
    
    private let userFeedtableView: UITableView = {
        let tableView = UITableView()
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
    }
    
    private func setLayout() {
        view.backgroundColor = UIColor.white
        userInfoLayout()
        feedLayout()
    }
    
    private func userInfoLayout() {
        [
            userNameLabel,
            userImageView,
            userInfoLabel,
            homeGymButton,
            userEditButton,
            indicatorBar,
            segmentedControl,
        ].forEach { view.addSubview($0) }
        
        userImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(32)
            $0.height.width.equalTo(80)
        }
        
        userNameLabel.snp.makeConstraints {
            $0.leading.equalTo(userImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(userEditButton.snp.leading).offset(-8)
            $0.top.equalToSuperview().offset(32)
        }
        
        userInfoLabel.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel)
            $0.top.equalTo(userNameLabel.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().offset(-16)
        }
        
        homeGymButton.snp.makeConstraints {
            $0.leading.equalTo(userNameLabel)
            $0.top.equalTo(userInfoLabel.snp.bottom).offset(12)
        }
        
        userEditButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalToSuperview().offset(16)
            $0.width.equalTo(120)
            $0.height.equalTo(26)
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
        }
    }
}
