//
//  ClimbingGymVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class ClimbingGymVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = ClimbingGymVM()
    
    // MARK: - 간단 레이블 구성 DS
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .lightGray
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let profileNameLabel: UILabel = {
        let label = UILabel()
        label.text = "000 클라이밍"
        label.font = UIFont.boldSystemFont(ofSize: 17)
        return label
    }()
    
    private let followerLabel: UILabel = {
        let label = UILabel()
        label.text = "1999 팔로워"
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .gray
        return label
    }()
    
    private let followButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("팔로우", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 13)
        button.backgroundColor = .lightGray
        button.layer.cornerRadius = 10
        return button
    }()
    
    private let segmentControl: UISegmentedControl = {
        let segmentControl = UISegmentedControl(items: ["세팅", "정보"])
        segmentControl.selectedSegmentIndex = 0
        return segmentControl
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    // MARK: - 테이블 뷰
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = UIColor.lightGray
        tableView.clipsToBounds = true
        tableView.layer.cornerRadius = 10
        
        tableView.separatorStyle = .singleLine // 기본 선 스타일
        tableView.separatorColor = .black // 구분선 색상
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15) // 좌우 여백
        return tableView
    }()
    
    // MARK: - 라이프 사이클 DS
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindSectionData()
        actions()
        
        // 임시레지스터
        tableView.register(SectionTableViewCell.self, forCellReuseIdentifier: Identifiers.sectionTableViewCell)
    }
    
    // MARK: - addAction 부분 (버튼, 세그먼트 컨트롤) DS
    private func actions() {
        followButton.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            if self.followButton.title(for: .normal) == Identifiers.follow {
                self.followButton.setTitle(Identifiers.unFollow, for: .normal)
            } else {
                self.followButton.setTitle(Identifiers.follow, for: .normal)
            }
        }, for: .touchUpInside)
        
        segmentControl.addAction(UIAction { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.selectedSegment.accept(self.segmentControl.selectedSegmentIndex)
        }, for: .valueChanged)
    }
    
    // MARK: - 바인딩 DS
    private func bindSectionData() {
        viewModel.dummys
            .bind(to: tableView.rx.items(cellIdentifier: Identifiers.sectionTableViewCell, cellType: UITableViewCell.self)) { row, item, cell in
                cell.textLabel?.text = item.name
            }
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .bind(to: viewModel.itemSelected)
            .disposed(by: disposeBag)
    }
    
    // MARK: - 레이아웃 구성 DS
    private func setLayout() {
        view.backgroundColor = .white
    
        setupUI()
        setConstraints()
    }
    
    // MARK: - 에드섭뷰 해주기 DS
    private func setupUI() {
        [
            profileImageView,
            profileNameLabel,
            followerLabel,
            followButton,
            segmentControl,
            contentView
        ].forEach { view.addSubview($0) }
        
        [
            tableView
        ].forEach { contentView.addSubview($0) }
    }
    
    // MARK: - 레이아웃 잡기 DS
    private func setConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.width.height.equalTo(80)
        }
        
        profileNameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }

        followerLabel.snp.makeConstraints {
            $0.top.equalTo(profileNameLabel.snp.bottom).offset(8)
            $0.leading.equalTo(profileNameLabel.snp.leading)
        }
        
        followButton.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView.snp.centerY)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.equalTo(80)
            $0.height.equalTo(32)
        }
        
        segmentControl.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
        }
        
        contentView.snp.makeConstraints {
            $0.top.equalTo(segmentControl.snp.bottom).offset(16)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.bottom.equalToSuperview()
        }
        
        tableView.snp.makeConstraints {
            $0.edges.equalTo(contentView)
        }
    }
}

