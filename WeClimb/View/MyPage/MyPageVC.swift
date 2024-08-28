//
//  MyPageVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import UIKit

import RxSwift
import SnapKit

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
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 5
        return button
    }()
    
    private let followCountLabel: UILabel = {
        let label = UILabel()
        label.text = "123"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let followingCountLabel: UILabel = {
        let label = UILabel()
        label.text = "456"
        label.font = UIFont.boldSystemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let followLabel: UILabel = {
        let label = UILabel()
        label.text = MypageNameSpace.follow
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
        label.textAlignment = .center
        return label
    }()
    
    private let followingLabel: UILabel = {
        let label = UILabel()
        label.text = MypageNameSpace.following
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = .black
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
        collectionView.register(MyPageCell.self, forCellWithReuseIdentifier: MypageNameSpace.id)
        
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        setupLayout()
        bind()
        setNavigation()
    }
    
    // MARK: - 로그아웃 버튼 YJ
    // 이 기능은 아직 보류지만 로그아웃을 위해 우선 여기에..
    func setNavigation() {
        let rightBarButton = UIBarButtonItem(
            image: UIImage(systemName: "ellipsis"),
            style: .plain,
            target: self,
            action: #selector(rightBarButtonTapped)
        )
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItem = rightBarButton
    }
    
    @objc private func rightBarButtonTapped() {
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        
        let logout = UIAlertAction(title: MypageNameSpace.logout, style: .default) { _ in
            guard let navigationController = self.tabBarController?.navigationController else { return }
            navigationController.popToRootViewController(animated: true)
        }
        
        let close = UIAlertAction(title: MypageNameSpace.close, style: .cancel)
        
        [logout, close]
            .forEach { actionSheet.addAction($0) }
        
        present(actionSheet, animated: true)
    }
    
    private func setupLayout() {
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
    
    private func bind() {
        viewModel.profileImages
            .bind(to: collectionView.rx.items(cellIdentifier: MypageNameSpace.id, cellType: MyPageCell.self)) { _, image, cell in
                cell.configure(with: image)
            }
            .disposed(by: disposeBag)
    }
}
