//
//  MainFeedVC_SF.swift
//  WeClimb
//
//  Created by 김솔비 on 9/5/24.
//

import UIKit

import SnapKit

class SFMainFeedVC: UIViewController {
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0  //셀간 여백 조정(효과없음)
//        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0) //플로우 레이아웃 인셋 조정(효과없음)
        return UICollectionView(frame: .zero, collectionViewLayout: layout) //레이아웃을 반환
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationBar()
        setCollectionView()
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setCollectionView() {
        collectionView.register(SFCollectionViewCell.self, forCellWithReuseIdentifier: Identifiers.mainCollectionViewCell)
        
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.frame = view.bounds  //컬렉션뷰 셀 프레임을 화면 전체에 맞춤
        collectionView.isPagingEnabled = true  //스크롤 시 한 화면씩 넘기기(페이징 모드 활성화)
        collectionView.contentInsetAdjustmentBehavior = .never  //네비게이션바 자동 여백 삭제
//        collectionView.contentInsetAdjustmentBehavior = .always  //네비게이션바 아래에서 컬렉션뷰 시작하기(효과없음)
//        collectionView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)  //컬렉션뷰 상단좌우 여백 삭제(효과없음)
//        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)  //스크롤 인디케이터 위치 조정(효과없음)
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//MARK: - 컬렉션뷰 프로토콜 설정
extension SFMainFeedVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.mainCollectionViewCell, for: indexPath) as? SFCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let image = UIImage(named: "testImage") {
            cell.configure(userProfileImage: image,
                           userName: "더 클라임 신림",
                           address: "서울시 관악구 신림동",
                           caption: "클라이밍 재밌다아아아아아아아아아아아아아아아아아아아아아아아아아",
                           level: "V6",
                           sector: "S1",
                           dDay: "D14",
                           likeCounter: "444")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
}
