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
//    private let climbingDetailGymVC = ClimbingDetailGymVC()
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
        actions()
    }
    
    func configure(with gym: Gym) {
        self.gymData = gym
        viewModel.setGymInfo(gymName: gym.gymName)
        climbingGymInfoView.viewModel = viewModel
    }
    
    private func navigateToClimbingDetailGymVC(with difficulty: String) {
        // gymUID와 difficulty 값을 기반으로 ClimbingDetailGymVC에 전달
//        print("선택된 난이도: \(difficulty)")
        guard let gymData = gymData else { return }
        let detailViewModel = ClimbingDetailGymVM(gym: gymData, difficulty: difficulty)
        let climbingDetailGymVC = ClimbingDetailGymVC(viewModel: detailViewModel)
        
        navigationController?.pushViewController(climbingDetailGymVC, animated: true)
    }
    
    // MARK: - 데이터 바인딩 - DS
    private func bindSectionData() {
        viewModel.output.gymData
            .drive(onNext: { [weak self] gym in
                guard let self else { return }
                if let gym {
                    self.headerView.configure(with: gym)
                }
            })
            .disposed(by: disposeBag)
        
        viewModel.output.isDataLoaded
            .filter { $0 }
            .drive(onNext: { [weak self] _ in
                self?.setupInitialUI()
            })
            .disposed(by: disposeBag)
        
        viewModel.output.items
            .drive(difficultyTableView.rx.items(cellIdentifier: DifficultyTableViewCell.className, cellType: DifficultyTableViewCell.self)) { row, item, cell in
                cell.configure(with: item.color, grade: item.grade)
            }
            .disposed(by: disposeBag)
        
        viewModel.output.items
            .drive(onNext: { [weak self] items in
                guard let self else { return }
                
                self.colorStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
                items.forEach { item in
                    let colorView = UIView()
                    colorView.backgroundColor = item.color
                    colorView.layer.cornerRadius = 2
                    self.colorStackView.addArrangedSubview(colorView)
                }
            })
            .disposed(by: disposeBag)
        
        difficultyTableView.rx.modelSelected((UIColor, String).self) // 셀 모델 직접 구독
            .subscribe(onNext: { [weak self] model in
                guard let self = self else { return }
                // 페이지 전환 로직 실행
                self.navigateToClimbingDetailGymVC(with: model.1) // model.1: 선택된 난이도
            })
            .disposed(by: disposeBag)
        
        // Input 이벤트
        difficultyTableView.rx.itemSelected
            .bind(to: viewModel.input.difficultySelected)
            .disposed(by: disposeBag)
        
        headerView.segmentControl.rx.value
            .bind(to: viewModel.input.segmentSelected)
            .disposed(by: disposeBag)
    }
    
    private func configureActions() {
           headerView.followButton.addAction(UIAction { [weak self] _ in
               guard let self else { return }
               self.headerView.followButton.isHidden.toggle()
               // follow 버튼 토글 로직 추가
           }, for: .touchUpInside)
       }
       
    private func setupInitialUI() {
        // ViewModel의 selectedSegment를 UI에 반영
        viewModel.output.selectedSegment
            .drive(onNext: { [weak self] initialSegmentIndex in
                guard let self else { return }
                self.headerView.segmentControl.selectedSegmentIndex = initialSegmentIndex
                self.updateSegmentControlUI(selectedIndex: initialSegmentIndex)
            })
            .disposed(by: disposeBag)
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
            self.viewModel.input.segmentSelected.accept(selectedIndex)
            
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
