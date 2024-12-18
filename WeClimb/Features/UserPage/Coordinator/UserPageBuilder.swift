//
//  UserPageBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol UserPageBuilder {
//    func buildBookMarkSearch() -> BookMarkSearchVC
//    func buildManageBookMark() -> ManageBookMarkVC
//    func buildUserPage() -> UserPageVC
}

final class UserPageBuilderImpl: UploadBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shard) {
        self.container = container
    }
    
//    func buildBookMarkSearch() -> BookMarkSearchVC {
//        let viewModel: BookMarkSearchVM = container.resolve(BookMarkSearchVM.self)
//        return BookMarkSearchVC(viewModel: viewModel)
//    }
//    
//    func buildManagerBookMark() -> ManageBookMarkVC {
//        let viewModel: ManageBookMarkVM = container.resolve(ManageBookMarkVM.self)
//        return ManageBookMarkVC(viewModel: viewModel)
//    }
//    
//    func buildUserPage() -> UserPageVC {
//        let viewModel: UserPageVM = container.resolve(UserPageVM.self)
//        return UserPageVC(viewModel: viewModel)
//    }
}
