//
//  UploadVM.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import Photos
import UIKit

class UploadVM {
    
    var albums: [PHAssetCollection] = []
    let imageManager = PHCachingImageManager()
    
    init() {
        photoAuthorization()
    }

    func fetchThumbnail(for collection: PHAssetCollection, completion: @escaping (UIImage?) -> Void) {
        // 해당 앨범의 PHAsset을 가져옴
        let fetchOptions = PHFetchOptions()
        fetchOptions.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        fetchOptions.fetchLimit = 1 // 첫 번째 asset만 가져옴
        let assets = PHAsset.fetchAssets(in: collection, options: fetchOptions)

        guard let asset = assets.firstObject else {
            completion(nil)
            return
        }

        // 썸네일 요청
        let targetSize = CGSize(width: 100, height: 100) // 원하는 썸네일 크기
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.deliveryMode = .highQualityFormat
        options.isSynchronous = false

        imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: .aspectFill, options: options) { image, _ in
            completion(image)
        }
    }
    
    func fetchAlbums() {
        let fetchOptions = PHFetchOptions()
        
        let recentAlbums = PHAssetCollection.fetchAssetCollections(with: .smartAlbum, subtype: .smartAlbumUserLibrary, options: fetchOptions)
        let userAlbums = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .albumRegular , options: fetchOptions)
        
        albums = [recentAlbums.object(at: 0)]
        userAlbums.enumerateObjects { (collection, _, _) in
            print("success")
            self.albums.append(collection)
        }
    }
    
    func photoAuthorization() {
        PHPhotoLibrary.requestAuthorization { status in
            switch status {
            case .authorized:
                self.fetchAlbums()
            case .denied, .restricted, .notDetermined:
                // 접근 권한이 없을 경우의 처리
                print("Photo Library access denied.")
            case .limited:
                print("Photo Library access denied.")
            @unknown default:
                fatalError()
            }
        }
    }
}
