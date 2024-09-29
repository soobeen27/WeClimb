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
    
    private let profileImagePicker = ProfileImagePickerVC()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 60
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "testStone") // 기본 프로필 이미지
        return imageView
    }()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.layer.cornerRadius = 20
        tableView.isScrollEnabled = false // 스크롤 되지 않도록
        tableView.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        tableView.register(EditPageCell.self, forCellReuseIdentifier: EditPageCell.className)
        tableView.separatorInset.left = 0
        //        tableView.separatorStyle = .none
        tableView.rowHeight = 60
        return tableView
    }()
    
    override func viewDidLoad() {
        setColor()
        setNavigation()
        setLayout()
        bind()
        
        // 이미지 탭 피커 임시 주석
//        setProfileImageTap()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        //화면 전환 후 뒤로가기 시 테이블뷰 리로드
        tableView.reloadData()
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
            $0.width.height.equalTo(120)
        }
        
        tableView.snp.makeConstraints {
            $0.top.equalTo(profileImage.snp.bottom).offset(40)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(119)
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
                (indexPath, items[indexPath.row])
            }
        // 구독
            .subscribe(onNext: { [weak self] (indexPath, item) in
                guard let self = self else { return }
                // 선택된 항목을 DetailEditVM에 전달
                
                // 클릭된 항목에 따라 분기 처리
                if indexPath.row == 0 {
                    // 첫 번째 항목 클릭 시 CreateNickNameVC로 이동
                    let editNickNameVC = EditNickNameVC()
                    self.navigationController?.pushViewController(editNickNameVC, animated: true)
                } else if indexPath.row == 1 {
                    // 두 번째 항목 클릭 시 PersonalDetailsVC로 이동
                    let editPersonalDetailsVC = EditPersonalDetailsVC()
                    self.navigationController?.pushViewController(editPersonalDetailsVC, animated: true)
                }
                //                self.detailEditVM.selectItem(item)
                //
                //                // 화면 전환
                //                let detailVC = DetailEditVC(viewModel: detailEditVM)
                //                self.navigationController?.pushViewController(detailVC, animated: true)
            })
            .disposed(by: disposeBag)
    }
    
    //MARK: - 탭 제스처를 추가하고, 이미지 피커 띄우기 YJ
    private func setProfileImageTap() {
        let tapGesture = UITapGestureRecognizer()
        profileImage.isUserInteractionEnabled = true
        profileImage.addGestureRecognizer(tapGesture)
        
        tapGesture.rx.event
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
                // 현재 인스턴스 메서드에 넣어주기
                self.profileImagePicker.presentImagePicker(from: self)
            })
            .disposed(by: disposeBag)
    }
}
