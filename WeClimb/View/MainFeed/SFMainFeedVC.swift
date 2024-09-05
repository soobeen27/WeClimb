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
        layout.minimumLineSpacing = 0
        return UICollectionView(frame: .zero, collectionViewLayout: layout) //레이아웃을 반환
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setCollectionView()
        setLayout()
    }
    
    
    
    
    private func setCollectionView() {
        collectionView.register(SFCollectionViewCell.self, forCellWithReuseIdentifier: "SFCollectionViewCell")
        
        collectionView.dataSource = self
        collectionView.delegate = self
        //        collectionView.register(VideoCell.self, forCellWithReuseIdentifier: "VideoCell")
        collectionView.frame = view.bounds  //컬렉션뷰 셀 프레임을 화면 전체에 맞춤
        collectionView.isPagingEnabled = true  //스크롤 시 한 화면씩 넘기기(페이징 모드 활성화)
    }
    
    private func setLayout() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

//MARK: - 컬렉션뷰 전체 레이아웃 설정
extension SFMainFeedVC: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SFCollectionViewCell", for: indexPath) as? SFCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        if let image = UIImage(named: "testImage") {
            cell.configure(userProfileImage: image,
                           userName: "더 클라임 신림",
                           address: "서울시 관악구 신림동",
                           caption: "클라이밍 재밌다아아아아아아아아아아아아아아아아아아아아아아아아아",
                           level: "V6",
                           sector: "1섹터",
                           dDay: "D-14",
                           likeCounter: "444")
        }
        cell.collectionView.delegate = self
        cell.collectionView.dataSource = self
        return cell
    }
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
}
