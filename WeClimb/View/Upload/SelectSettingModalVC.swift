//
//  SelectSettingModalVC.swift
//  WeClimb
//
//  Created by 강유정 on 11/12/24.
//

import UIKit

import SnapKit
import RxCocoa
import RxSwift

class SelectSettingModalVC: UIViewController {
    
    private var viewModel: UploadVM
    private let disposeBag = DisposeBag()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: setCollectionLayout())
        collectionView.register(SelectSettingCell.self, forCellWithReuseIdentifier: SelectSettingCell.className)
        collectionView.register(UploadHeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: UploadHeaderView.className)
        
        collectionView.backgroundColor = UIColor {
            switch $0.userInterfaceStyle {
            case .dark:
                return UIColor(named: "BackgroundColor") ?? .black
            default:
                return UIColor.systemGroupedBackground
            }
        }
        collectionView.isScrollEnabled = true
        
        return collectionView
    }()
    
    let okButton: UIButton = {
        let button = UIButton()
        button.setTitle(UploadNameSpace.okText, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.isEnabled = false
        
        button.backgroundColor = UIColor {
            switch $0.userInterfaceStyle {
            case .dark:
                return UIColor.secondarySystemBackground
            default:
                return UIColor.white
            }
        }
        return button
    }()
    
    init(viewModel: UploadVM) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        setColor()
        setNavigation()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true

//        bindSettingCell()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        resetSetting()
        bindSettingCell()
    }
    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        bindSettingCell()
//    }
    
    private func setNavigation() {
        self.title = UploadNameSpace.setting
    }
    
    private func setLayout() {
        [collectionView, okButton]
            .forEach {  view.addSubview($0) }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(8)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(8)
            $0.bottom.equalTo(okButton.snp.top).offset(-16)
        }
        
        okButton.snp.makeConstraints {
            $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-20)
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().offset(-16)
            $0.height.equalTo(50)
        }
    }
    
    private func setColor() {
        view.backgroundColor = UIColor {
            switch $0.userInterfaceStyle {
            case .dark:
                return UIColor(named: "BackgroundColor") ?? .black
            default:
                return UIColor.systemGroupedBackground
            }
        }
    }
    
    private func resetSetting() {
        Driver.combineLatest(
            viewModel.pageChanged.asDriver(onErrorJustReturn: 0),
            viewModel.feedRelay.asDriver()
        )
        .drive(onNext: { [weak self] pageIndex, feedItems in
            guard let self else { return }
            
            self.viewModel.selectedGrade.accept("")
            self.viewModel.selectedHold.accept(.none)
            collectionView.reloadData()
            
        })
        .disposed(by: disposeBag)
    }
    
    private func bindSettingCell() {
        Driver.combineLatest(
            viewModel.pageChanged.asDriver(onErrorJustReturn: 0),
            viewModel.feedRelay.asDriver()
        )
        .drive(onNext: { [weak self] pageIndex, feedItems in
            guard let self else { return }
            
//            self.viewModel.selectedGrade.accept("")
//            self.viewModel.selectedHold.accept(.none)
//            collectionView.reloadData()
            
            guard pageIndex >= 0 && pageIndex < feedItems.count else {
                self.okButton.isEnabled = false
                return
            }
            
            let feedItem = feedItems[pageIndex]
            print("오케이버튼 눌렀을때: \(feedItems)")

//            let currentGrade = feedItem.grade
            let currentHold = feedItem.hold

            if let currentGrade = feedItem.grade {
                self.viewModel.selectedGrade.accept(currentGrade)
            } else {
                self.viewModel.selectedGrade.accept(nil)
            }
            
            if let currentHold = Hold.allCases.first(where: { $0.string == currentHold }) {
                self.viewModel.selectedHold.accept(currentHold)
            } else {
                self.viewModel.selectedHold.accept(nil)
            }
        })
        .disposed(by: disposeBag)

        Driver.combineLatest(
            viewModel.selectedGrade.asDriver(onErrorJustReturn: nil),
            viewModel.selectedHold.asDriver(onErrorJustReturn: nil)
        )
        .drive(onNext: { [weak self] selectedGrade, selectedHold in
            guard let self else { return }
            
            self.okButton.isEnabled = selectedGrade != nil && selectedHold != nil
            collectionView.reloadData()
        })
        .disposed(by: disposeBag)
    }

    private func setCollectionLayout() -> UICollectionViewLayout {
        let isSmallScreen = UIScreen.main.bounds.size.height <= 667
        
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.6)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let firstGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let firstGroup = NSCollectionLayoutGroup.horizontal(layoutSize: firstGroupSize, subitem: item, count: 1)
        
        let secondGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(0.5)
        )
        let secondGroup = NSCollectionLayoutGroup.horizontal(layoutSize: secondGroupSize, subitem: item, count: 1)
        
        let verticalGroupHeight: CGFloat = isSmallScreen ? 0.65 : 0.45
        
        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.23),
            heightDimension: .fractionalHeight(verticalGroupHeight)
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitems: [firstGroup, secondGroup]
        )
        verticalGroup.interItemSpacing = .fixed(0)
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 8, leading: 16, bottom: 8, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
        )
        
        let header = NSCollectionLayoutBoundarySupplementaryItem(
            layoutSize: headerSize,
            elementKind: UICollectionView.elementKindSectionHeader,
            alignment: .top
        )
        
        section.boundarySupplementaryItems = [header]
        
        return UICollectionViewCompositionalLayout(section: section)
    }
}

enum Section: Int, CaseIterable {
    case gradeSection
    case holdSection
    
    var title: String {
        switch self {
        case .gradeSection : return "난이도를 선택해주세요"
        case .holdSection : return "홀드를 선택해주세요"
        }
    }
}

extension SelectSettingModalVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .gradeSection:
            return viewModel.gradeRelayArray.value.count
        case .holdSection:
            return Hold.allCases.count
        default:
            return 0
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectSettingCell.className, for: indexPath) as? SelectSettingCell else {
            return UICollectionViewCell()
        }
        
        switch Section(rawValue: indexPath.section) {
        case .gradeSection:
            let grade = viewModel.gradeRelayArray.value[indexPath.row]
            cell.configure(item: grade)
            
            viewModel.selectedGrade
                .asDriver(onErrorJustReturn: nil)
                .map { $0 == grade }
                .drive(onNext: { isSelected in
                    print("Grade: \(grade), 셀렉트\(isSelected)")
                    cell.layer.borderColor = isSelected ? UIColor.mainPurple.cgColor : UIColor.clear.cgColor
                    cell.layer.borderWidth = isSelected ? 1 : 0
                })
                .disposed(by: disposeBag)
            
        case .holdSection:
            let hold = Hold.allCases[indexPath.row]
            cell.configure(item: hold)
            
            viewModel.selectedHold
                .asDriver(onErrorJustReturn: nil)
                .map { $0 == hold }
                .drive(onNext: { isSelected in
                    print("Hold: \(hold), 셀렉트\(isSelected)")
                    cell.layer.borderColor = isSelected ? UIColor.mainPurple.cgColor : UIColor.clear.cgColor
                    cell.layer.borderWidth = isSelected ? 1 : 0
                })
                .disposed(by: disposeBag)
            
        default:
            return UICollectionViewCell()
        }
        return cell
    }
}

extension SelectSettingModalVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch Section(rawValue: indexPath.section) {
        case .gradeSection:
            let grade = viewModel.gradeRelayArray.value[indexPath.row]
            
            if viewModel.selectedGrade.value == grade {
                viewModel.selectedGrade.accept(nil)
                viewModel.optionSelected(optionText: "", buttonType: "grade")
            } else {
                viewModel.selectedGrade.accept(grade)
                viewModel.optionSelected(optionText: grade, buttonType: "grade")
            }
            print("중간 확인 그레이드: \(String(describing: viewModel.selectedGrade.value)), \(grade)")
            
        case .holdSection:
            let hold = Hold.allCases[indexPath.row]
            
            if viewModel.selectedHold.value == hold {
                viewModel.selectedHold.accept(nil)
                viewModel.optionSelected(optionText: "", buttonType: "hold")
            } else {
                viewModel.selectedHold.accept(hold)
                viewModel.optionSelected(optionText: hold.string, buttonType: "hold")
            }
            print("중간 확인 홀드: \(String(describing: viewModel.selectedHold.value)), \(hold)")
            
        default:
            break
        }
        
//        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: UploadHeaderView.className,
            for: indexPath
        ) as? UploadHeaderView else {
            return UICollectionReusableView()
        }
        
        let sectionType = Section.allCases[indexPath.section]
        headerView.configure(with: sectionType.title)
        return headerView
    }
}
