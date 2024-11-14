//
//  ClimbingFilterVC.swift
//  WeClimb
//
//  Created by 머성이 on 11/11/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class ClimbingFilterVC: UIViewController, UIScrollViewDelegate {
    
    private let viewModel = ClimbingFilterVM()
    private let disposeBag = DisposeBag()
    
    private let scrollView = UIScrollView()
    private let contentView = UIView()
    
    private let closeButton: UIButton = {
        let button = UIButton(type: .system)
        let closeImage = UIImage(systemName: "xmark")
        button.setImage(closeImage, for: .normal)
        button.tintColor = .label
        return button
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "필터"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textAlignment = .center
        return label
    }()
    
    private let holdLabel: UILabel = {
        let label = UILabel()
        label.text = "홀드"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let armReachLabel: UILabel = {
        let label = UILabel()
        label.text = "암리치"
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.textColor = .gray
        label.textAlignment = .center
        label.isUserInteractionEnabled = true
        return label
    }()
    
    private let viewOptionStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 20
        return stackView
    }()
    
    private let indicatorBar: UIView = {
        let view = UIView()
        view.backgroundColor = .lightGray
        return view
    }()
    
    private let holdCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.itemSize = CGSize(width: 100, height: 100)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SelectSettingCell.self, forCellWithReuseIdentifier: SelectSettingCell.className)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        return collectionView
    }()

    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setupScrollView()
        setupActions()
        setupCloseButtonAction()
        bindViewModel()
        
        scrollView.delegate = self
        holdCollectionView.delegate = self
        holdCollectionView.dataSource = self
    }
    
    // MARK: - Layout
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [
            closeButton,
            titleLabel,
            viewOptionStackView,
            indicatorBar,
            scrollView,
            holdCollectionView,
        ].forEach { view.addSubview($0) }
        
        [
            holdLabel,
            armReachLabel
        ].forEach { viewOptionStackView.addArrangedSubview($0) }
        
        closeButton.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.width.height.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(closeButton)
            $0.centerX.equalToSuperview()
        }
        
        viewOptionStackView.snp.makeConstraints {
            $0.top.equalTo(closeButton.snp.bottom).offset(16)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(40)
        }
        
        indicatorBar.snp.makeConstraints {
            $0.top.equalTo(viewOptionStackView.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        holdCollectionView.snp.makeConstraints {
            $0.top.equalTo(indicatorBar.snp.bottom).offset(8)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(60) // 높이 고정
        }
        
        scrollView.snp.makeConstraints {
            $0.top.equalTo(indicatorBar.snp.bottom).offset(8)
            $0.leading.trailing.bottom.equalToSuperview()
        }
        
        [
            contentView,
        ].forEach { scrollView.addSubview($0) }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.height.greaterThanOrEqualTo(view.snp.height)
        }
    }
    
    // MARK: - Actions Setup -DS
    private func setupActions() {
        let holdTap = UITapGestureRecognizer()
        holdLabel.addGestureRecognizer(holdTap)
        
        holdTap.rx.event
            .map { _ in }
            .bind(to: viewModel.input.holdSelected)
            .disposed(by: disposeBag)
        
        let armReachTap = UITapGestureRecognizer()
        armReachLabel.addGestureRecognizer(armReachTap)
        
        armReachTap.rx.event
            .map { _ in }
            .bind(to: viewModel.input.armReachSelected)
            .disposed(by: disposeBag)
    }
    
    private func setupCloseButtonAction() {
        closeButton.rx.tap
            .bind { [weak self] in
                self?.dismiss(animated: true, completion: nil)
            }
            .disposed(by: disposeBag)
    }
    
    // MARK: - Scroll View Setup -DS
    private func setupScrollView() {
        
        let holdSectionView = UIView()
        holdSectionView.backgroundColor = .clear
        
        let armReachSectionView = UIView()
        armReachSectionView.backgroundColor = .clear
        
        [
            holdSectionView,
            armReachSectionView,
        ].forEach { contentView.addSubview($0) }
        
        holdSectionView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(200)
        }
        
        armReachSectionView.snp.makeConstraints {
            $0.top.equalTo(holdSectionView.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(400)
            $0.bottom.equalToSuperview()
        }
    }
    
    private func bindViewModel() {
        viewModel.output.selectedTab
            .drive(onNext: { [weak self] selectedTab in
                self?.updateTabSelection(selectedTab: selectedTab)
            })
            .disposed(by: disposeBag)
        
    }
    
    private func updateTabSelection(selectedTab: ClimbingFilterVM.SelectedTab) {
        switch selectedTab {
        case .hold:
            holdLabel.textColor = .label
            armReachLabel.textColor = .gray
        case .armReach:
            holdLabel.textColor = .gray
            armReachLabel.textColor = .label
        }
    }
}

extension ClimbingFilterVC: UICollectionViewDelegate {
    // 셀 선택시 동작로직
}

extension ClimbingFilterVC: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Hold.allCases.count
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectSettingCell.className, for: indexPath) as? SelectSettingCell else {
            return UICollectionViewCell()
        }
        
        let hold = Hold.allCases[indexPath.item]
        cell.configure(item: hold)
        
        return cell
    }
}
