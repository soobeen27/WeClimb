//
//  UploadBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol UploadBuilder {
    func buildUploadMedia(gymItem: SearchResultItem) -> UploadMediaVC
    func buildUploadPost(gymName: String, mediaItems: [MediaUploadData]) -> UploadPostVC
    func buildUploadMenuView() -> UploadMenuVC
}

final class UploadBuilderImpl: UploadBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shared) {
        self.container = container
    }
    
    func buildUploadMenuView() -> UploadMenuVC {
        let uploadMenuView = UploadMenuVC()
        return uploadMenuView
    }
    
    func buildUploadMedia(gymItem: SearchResultItem) -> UploadMediaVC {
        let viewModel: UploadVM = container.resolve(UploadVM.self)
        return UploadMediaVC(gymItem: gymItem, viewModel: viewModel)
    }
    
    func buildUploadPost(gymName: String, mediaItems: [MediaUploadData]) -> UploadPostVC {
        let viewModel: UploadPostVM = container.resolve(UploadPostVM.self)
        return UploadPostVC(gymName: gymName, mediaItems: mediaItems, viewModel: viewModel)
    }
}
