//
//  UploadBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol UploadBuilder {
    func buildUploadMedia(gymItem: SearchResultItem) -> UploadMediaVC
    func buildUploadPost(gymName: String) -> UploadPostVC
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
    
    func buildUploadPost(gymName: String) -> UploadPostVC {
        let viewModel: UploadVM = container.resolve(UploadVM.self)
        return UploadPostVC(gymName: gymName, viewModel: viewModel)
    }
}
