//
//  EditPageVC.swift
//  WeClimb
//
//  Created by 강유정 on 8/29/24.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit

class EditPageVC: UIViewController {
    
    private let editPageViewModel = EditPageVM()
    private let disposeBag = DisposeBag()
    private let detailEditVM = DetailEditVM()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.isScrollEnabled = false // 스크롤 되지 않도록
        tableView.register(EditPageCell.self, forCellReuseIdentifier: EditPageCell.className)
        return tableView
    }()
    
    override func viewDidLoad() {
        setColor()
        setNavigation()
        setLayout()
        bind()
    }
    
    func setNavigation() {
        self.title = MypageNameSpace.edit
    }
    
    private func setLayout() {
        [profileImage, tableView]
            .forEach { view.addSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(20)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(100)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(336)
        }
    }
    
    // MARK: - 커스텀 색상 YJ
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
    
    private func bind() {
        editPageViewModel.items
            .bind(to: tableView.rx.items(cellIdentifier: EditPageCell.className, cellType: EditPageCell.self)) { row, item, cell in
                cell.configure(with: item)
            }
            .disposed(by: disposeBag)
        
        tableView.rx.itemSelected   // 셀을 선택했을 때 발생하는 이벤트를 방출
            .withLatestFrom(editPageViewModel.items) { indexPath, items in
                items[indexPath.row]
            }
            // 구독
            .subscribe(onNext: { [weak self] item in
                guard let self = self else { return }
                // 선택된 항목을 DetailEditVM에 전달
                self.detailEditVM.selectItem(item)
                
                // 화면 전환
                let detailVC = DetailEditVC(viewModel: detailEditVM)
                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
}
