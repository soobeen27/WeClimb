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
    func buildUserPage() -> UserPageVC
    func buildUserProfileSettingPage() -> UserProfileSettingVC
    func buildUserHomeGymSettingPage() -> HomeGymSettingVC
}

final class UserPageBuilderImpl: UserPageBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shared) {
        self.container = container
    }
    
    func buildUserPage() -> UserPageVC {
        let userUID = try! FirestoreHelper.userUID()
        
        let userFeedPageVM = container.assembler.resolver.resolve(UserFeedPageVM.self, argument: userUID)!
        
//        let userSummaryPageVM: UserSummaryPageVM = container.resolve(UserSummaryPageVM.self)
        
        return UserPageVC(userFeedPageVM: userFeedPageVM/*, userSummaryPageVM: userSummaryPageVM*/)
    }
    
    func buildUserProfileSettingPage() -> UserProfileSettingVC {
        let userUID = try! FirestoreHelper.userUID()
        
        let userProfileSettingVM = container.assembler.resolver.resolve(UserProfileSettingVM.self, argument: userUID)!
        
        return UserProfileSettingVC(viewModel: userProfileSettingVM)
    }
    
    func buildUserHomeGymSettingPage() -> HomeGymSettingVC {
        let homeGymSettingVM = container.assembler.resolver.resolve(HomeGymSettingVM.self)!
        
        return HomeGymSettingVC(viewModel: homeGymSettingVM)
    }
}
