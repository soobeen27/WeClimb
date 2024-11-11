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
        collectionView.register(HeaderView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: HeaderView.className)
        
        collectionView.backgroundColor = UIColor {
            switch $0.userInterfaceStyle {
            case .dark:
                return UIColor(named: "BackgroundColor") ?? .black
            default:
                return UIColor.systemGroupedBackground
            }
        }
        return collectionView
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
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = true
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(16)
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(8)
            $0.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(8)
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(8)
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
    
    private func setCollectionLayout() -> UICollectionViewLayout {
        
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
        
        let verticalGroupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(0.23),
            heightDimension: .fractionalHeight(0.4)
        )
        let verticalGroup = NSCollectionLayoutGroup.vertical(
            layoutSize: verticalGroupSize,
            subitems: [firstGroup, secondGroup]
        )
        
        let section = NSCollectionLayoutSection(group: verticalGroup)
        section.orthogonalScrollingBehavior = .continuous
        section.interGroupSpacing = 16
        section.contentInsets = .init(top: 16, leading: 16, bottom: 16, trailing: 16)
        
        let headerSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .estimated(40)
            //                heightDimension: .absolute(50)
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
        case .holdSection : return "홀더를 선택해주세요"
        }
    }
}

extension SelectSettingModalVC : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .gradeSection:
            return viewModel.gradeDataRelay.value.count
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
            let grade = viewModel.gradeDataRelay.value[indexPath.row]
            print("Grade: \(grade)")
            cell.configure(item: grade)
            
        case .holdSection:
            let hold = Hold.allCases[indexPath.row]
            print("Hold: \(hold)")
            cell.configure(item: hold)
        default:
            return UICollectionViewCell()
        }
        
        return cell
    }
}

extension SelectSettingModalVC: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard kind == UICollectionView.elementKindSectionHeader else {
            return UICollectionReusableView()
        }
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: HeaderView.className,
            for: indexPath
        ) as? HeaderView else {
            return UICollectionReusableView()
        }
        
        let sectionType = Section.allCases[indexPath.section]
        headerView.configure(with: sectionType.title)
        return headerView
    }
}

// MARK: - 헤더뷰
class HeaderView: UICollectionReusableView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.textColor = .label
        label.textAlignment = .left
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(10)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with title: String) {
        titleLabel.text = title
        titleLabel.sizeToFit()
    }
}
