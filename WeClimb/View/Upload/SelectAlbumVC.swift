//
//  SelectAlbumVC.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//
import Photos
import UIKit

import SnapKit

class SelectAlbumVC: UIViewController {
    
    private lazy var viewModel: UploadVM = {
        return UploadVM()
    }()
    
    private lazy var albumCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        let collectionCellWidth = (view.frame.width) / 3
        flowLayout.itemSize = CGSize(width: collectionCellWidth, height: collectionCellWidth + 40)
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        
        let collect = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collect.register(AlbumCell.self,
                         forCellWithReuseIdentifier: Identifiers.albumCell)
        collect.backgroundColor = .systemBackground
        collect.dataSource = self
        collect.delegate = self
        return collect
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLayout()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
            self.albumCollectionView.reloadData()
        }
    }
    
    private func setLayout() {
        view.backgroundColor = .systemBackground
        [albumCollectionView]
            .forEach {
                view.addSubview($0)
            }
        
        albumCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension SelectAlbumVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print(viewModel.albums.count)
        return viewModel.albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.albumCell, for: indexPath)
                as? AlbumCell,
                let albumName = self.viewModel.albums[indexPath.row].localizedTitle
        else { return UICollectionViewCell() }
        viewModel.fetchThumbnail(for: viewModel.albums[indexPath.row]) { image in
            guard let image
            else { return }
            cell.configure(image: image, name: albumName)
        }
        return cell
    }
    
    
}
