//
//  MyPageVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import RxSwift
import SnapKit
import FirebaseAuth

class MyPageVC: UIViewController {
    
    private let disposeBag = DisposeBag()
    private let viewModel = MyPageVM()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .gray
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 40
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "iOSClimber"
        label.font = UIFont.systemFont(ofSize: 17)
        label.numberOfLines = 1
        return label
    }()
    
    private let levelLabel: UILabel = {
        let label = UILabel()
        label.text = "V6"
        label.backgroundColor = .purple
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .white
        label.layer.cornerRadius = 5
        label.layer.masksToBounds = true
        return label
    }()
    
    private let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "체형: 177cm | 183cm"
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 1
        return label
    }()
    
    private let editButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle(MypageNameSpace.edit, for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 13)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let followCountLabel: UILabel = {
        let label = UILabel()
        label.text = "123"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.text = "456"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let followLabel: UILabel = {
        let label = UILabel()
        label.text = MypageNameSpace.follow
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = MypageNameSpace.following
        label.font = UIFont.systemFont(ofSize: 13)
        label.textAlignment = .center
        return label
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .center
        return stackView
    }()
    
    private let profileStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 8
        stackView.alignment = .leading
        return stackView
    }()
    
    private let totalStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 32
        stackView.alignment = .center
        return stackView
    }()
    
    private let followStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private let followingStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 5
        stackView.alignment = .center
        return stackView
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        // 셀 사이의 스페이싱 설정
        layout.minimumInteritemSpacing = 1.0
        layout.minimumLineSpacing = 1.0
        
        let width = (UIScreen.main.bounds.width - 2 * 16 - 2 * 1.0) / 3 // 전체 화면 - 양옆 여백 - 셀끼리의 스페이싱 / 3
        layout.itemSize = CGSize(width: width, height: width)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(MyPageCell.self, forCellWithReuseIdentifier: MyPageCell.className)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        bind()
        setNavigation()
//        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    // MARK: - 설정 버튼 YJ
    func setNavigation() {
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        navigationController?.navigationBar.tintColor = .label
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
//    @objc private func rightBarButtonTapped() {
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        
//        let logout = UIAlertAction(title: MypageNameSpace.logout, style: .default) { _ in
//            guard let navigationController = self.tabBarController?.navigationController else { return }
//            navigationController.popToRootViewController(animated: true)
//        }
//        
//        let close = UIAlertAction(title: MypageNameSpace.close, style: .cancel)
//        
//        [logout, close]
//            .forEach { actionSheet.addAction($0) }
//        
//        present(actionSheet, animated: true)
//    }
    
    // WL 파이어베이스 로그아웃 로직 추가
    @objc private func rightBarButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        // 로그아웃 액션
        let logout = UIAlertAction(title: MypageNameSpace.logout, style: .default) { _ in
            do {
                // Firebase Auth에서 로그아웃 수행
                try Auth.auth().signOut()
                print("User logged out successfully.")
                
                // 네비게이션 스택을 초기화하고 루트 뷰 컨트롤러로 이동
                guard let navigationController = self.tabBarController?.navigationController else { return }
                navigationController.popToRootViewController(animated: true)
                
            } catch let signOutError as NSError {
                print("Error signing out: %@", signOutError)
            }
        }
        
        // 닫기 액션
        let close = UIAlertAction(title: MypageNameSpace.close, style: .cancel)
        
        [logout, close]
            .forEach { actionSheet.addAction($0) }
        
        present(actionSheet, animated: true)
    }
    
    //프로필 편집뷰 이동
    private func editButtonTapped() {
        let editPageVC = EditPageVC()
        navigationController?.pushViewController(editPageVC, animated: true)
    }
    
    //상세 피드뷰 이동
    private func navigateDetailFeedView(at indexPath: IndexPath) {
        let myPageDetailFeedVC = MyPageDetailFeedVC()
        navigationController?.pushViewController(myPageDetailFeedVC, animated: true)
    }

    //MARK: - 레이아웃
    private func setLayout() {
        view.backgroundColor = UIColor(named: "BackgroundColor") ?? .black
        
        [profileImage, profileStackView, totalStackView, collectionView]
            .forEach{ view.addSubview($0) }
        
        [nameStackView, infoLabel, editButton]
            .forEach{ profileStackView.addArrangedSubview($0) }
        
        [nameLabel, levelLabel]
            .forEach{ nameStackView.addArrangedSubview($0) }
        
        [followCountLabel, followLabel]
            .forEach{ followStackView.addArrangedSubview($0) }
        
        [followingCountLabel, followingLabel]
            .forEach{ followingStackView.addArrangedSubview($0) }
        
        [followStackView, followingStackView]
            .forEach{ totalStackView.addArrangedSubview($0) }
        
        profileImage.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.width.height.equalTo(80)
        }
        
        profileStackView.snp.makeConstraints {
            $0.leading.equalTo(profileImage.snp.trailing).offset(16)
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.height.equalTo(80)
        }
        
        editButton.snp.makeConstraints {
            $0.width.equalTo(120)
        }
        
        totalStackView.snp.makeConstraints {
            $0.leading.equalTo(profileStackView.snp.trailing).offset(32)
            $0.centerY.equalTo(profileImage.snp.centerY)
            $0.height.equalTo(80)
        }
        
        collectionView.snp.makeConstraints {
            $0.top.equalTo(profileStackView.snp.bottom).offset(32)
            $0.leading.trailing.equalToSuperview().inset(16)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(16)
        }
    }
    
    //MARK: - 바인드
    private func bind() {
        viewModel.profileImages
            .bind(to: collectionView.rx.items(cellIdentifier: MyPageCell.className, cellType: MyPageCell.self)) { _, image, cell in
                cell.configure(with: image)
            }
            .disposed(by: disposeBag)
        
        // 프로필 편집 버튼 눌렀을 때 YJ
        editButton.rx.tap
            .bind { [weak self] in
                print("editButton tapped")
                self?.editButtonTapped()
            }
            .disposed(by: disposeBag)
        
        collectionView.rx.itemSelected
            .bind { [weak self ] indexPath in
                self?.navigateDetailFeedView(at: indexPath)
            }
            .disposed(by: disposeBag)
    }
}
//extension MyPageVC: UICollectionViewDelegate {
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let modalVC = MyPageModalVC()
//        modalVC.modalPresentationStyle = .pageSheet
//        
//        if let sheet = modalVC.sheetPresentationController {
//            let customDetent = UISheetPresentationController.Detent.custom { context in
//                return context.maximumDetentValue * 0.9
//            }
//            sheet.detents = [customDetent]
//            sheet.preferredCornerRadius = 20
//        }
//
//        present(modalVC, animated: true, completion: nil)
//    }
//}

