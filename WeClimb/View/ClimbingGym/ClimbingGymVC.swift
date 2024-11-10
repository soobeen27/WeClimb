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
    private let climbingGymInfoView = ClimbingGymInfoView()
    private let climbingDetailGymVC = ClimbingDetailGymVC()
    private var gymData: Gym?
    
    // MARK: - 공통 헤더 뷰 - DS
    private let headerView = GymHeaderView()
    
    // MARK: - 테이블 뷰 구성 - DS
    private let difficultyTableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.showsVerticalScrollIndicator = true
        tableView.clipsToBounds = true
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = UIColor.label.withAlphaComponent(0.2)
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 32, bottom: 0, right: 32)
        tableView.rowHeight = 64
        tableView.register(DifficultyTableViewCell.self, forCellReuseIdentifier: DifficultyTableViewCell.className)
        return tableView
    }()
    
    // MARK: - 난이도 색상 구분 - DS
    private let easyLabel: UILabel = {
        let label = UILabel()
        label.text = "EASY"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let hardLabel: UILabel = {
        let label = UILabel()
        label.text = "HARD"
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    private let colorStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        return stackView
    }()
    
    // MARK: - 라이프사이클 - DS
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bindSectionData()
        bindData()
        actions()
    }
    
    func configure(with gym: Gym) {
        viewModel.setGymInfo(gymName: gym.gymName)
        climbingGymInfoView.viewModel = viewModel
    }
    
    private func navigateGymDetailView() {
        self.navigationController?.pushViewController(climbingDetailGymVC, animated: true)
    }
    
    // MARK: - 데이터 바인딩 - DS
    private func bindSectionData() {
        viewModel.gymData
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] gym in
                guard let self else { return }
                self.headerView.configure(with: gym)
            })
            .disposed(by: disposeBag)
        
        viewModel.isDataLoaded
            .filter { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                self.setupInitialUI()
            })
            .disposed(by: disposeBag)
        
        viewModel.items
            .bind(to: difficultyTableView.rx.items(cellIdentifier: DifficultyTableViewCell.className, cellType: DifficultyTableViewCell.self)) { row, item, cell in
                cell.configure(with: item.color, grade: item.grade)
            }
            .disposed(by: disposeBag)
        
        difficultyTableView.rx.itemSelected
            .subscribe(onNext: { [ weak self ] item in
                self?.navigateGymDetailView()
            })
            .disposed(by: disposeBag)
    }
    
    private func bindData() {
        viewModel.items
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] items in
                guard let self else { return }
                
                self.colorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                
                for item in items {
                    let colorView = UIView()
                    colorView.backgroundColor = item.color
                    colorView.layer.cornerRadius = 2
                    colorView.clipsToBounds = true
                    self.colorStackView.addArrangedSubview(colorView)
                    
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func setupInitialUI() {
        let initialSegmentIndex = viewModel.selectedSegment.value
        headerView.segmentControl.selectedSegmentIndex = initialSegmentIndex
        updateSegmentControlUI(selectedIndex: initialSegmentIndex)
    }
    
    private func updateSegmentControlUI(selectedIndex: Int) {
        if selectedIndex == 1 {
            difficultyTableView.isHidden = true
            climbingGymInfoView.isHidden = false
            easyLabel.isHidden = true
            hardLabel.isHidden = true
        } else {
            difficultyTableView.isHidden = false
            climbingGymInfoView.isHidden = true
            easyLabel.isHidden = false
            hardLabel.isHidden = false
        }
    }
    
    // MARK: - 세그먼트 컨트롤 및 버튼 액션 설정
    private func actions() {
        headerView.followButton.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            self.headerView.followButton.isHidden = true
            if self.headerView.followButton.title(for: .normal) == ClimbingGymNameSpace.follow {
                self.headerView.followButton.setTitle(ClimbingGymNameSpace.unFollow, for: .normal)
                self.headerView.followButton.backgroundColor = .lightGray
                self.headerView.followButton.setTitleColor(.black, for: .normal)
                ClimbingGymNameSpace.totalFollow += 1
            } else {
                self.headerView.followButton.setTitle(ClimbingGymNameSpace.follow, for: .normal)
                self.headerView.followButton.backgroundColor = .mainPurple
                self.headerView.followButton.setTitleColor(.white, for: .normal)
                if ClimbingGymNameSpace.totalFollow > 0 {
                    ClimbingGymNameSpace.totalFollow -= 1
                }
            }
            self.headerView.updateFollowersCount(ClimbingGymNameSpace.follower)
        }, for: .touchUpInside)
        
        headerView.segmentControl.addAction(UIAction { [weak self] _ in
            guard let self else { return }
            
            let selectedIndex = self.headerView.segmentControl.selectedSegmentIndex
            self.viewModel.selectedSegment.accept(selectedIndex)
            
            self.updateSegmentControlUI(selectedIndex: selectedIndex)
        }, for: .valueChanged)
    }
    
    // MARK: - 레이아웃 설정
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        climbingGymInfoView.isHidden = true
        
        [
            headerView,
            difficultyTableView,
            climbingGymInfoView,
            easyLabel,
            hardLabel,
            colorStackView,
//            countStackView
        ].forEach { view.addSubview($0) }
        
        headerView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        easyLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.top.equalTo(headerView.snp.bottom).offset(8)
        }
        
        hardLabel.snp.makeConstraints {
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(headerView.snp.bottom).offset(8)
        }
        
        colorStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.top.equalTo(easyLabel.snp.bottom).offset(4)
            $0.height.equalTo(16)
        }
        
        difficultyTableView.snp.makeConstraints {
            $0.top.equalTo(colorStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
        }
        
        climbingGymInfoView.snp.makeConstraints {
            $0.top.equalTo(headerView.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
    }
}
