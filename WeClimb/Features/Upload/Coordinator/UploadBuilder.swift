//
//  UploadBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol UploadBuilder {
//    func buildUploadMedia() -> UploadMediaVC
//    func buildUploadPost() -> UploadPostVC
    func buildUploadMenuView() -> UploadMenuView
}

final class UploadBuilderImpl: UploadBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shared) {
        self.container = container
    }
    
    func buildUploadMenuView() -> UploadMenuView {
        let uploadMenuView = UploadMenuView()
        return uploadMenuView
    }
    
//    func buildUploadMedia() -> UploadMediaVC {
//        let viewModel: UploadMediaVM = container.resolve(UploadMediaVM.self)
//        return UploadMediaVC(viewModel: viewModel)
//    }
//    
//    func buildUploadPost() -> UploadPostVC {
//        let viewModel: UploadPostVM = container.resolve(UploadPostVM.self)
//        return UploadPostVC(viewModel: viewModel)
//    }
}
