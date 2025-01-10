//
//  OnboardingBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol OnboardingBuilder {
//    func buildCreateNickname() -> CreateNicknameVC
//    func buildCreatePersonalDetail() -> CreatePersonalDetailVC
    func buildLogin() -> LoginVC
//    func buildPrivacyPolicy() -> PrivacyPolicyVC
//    func buildRegisterResult() -> RegisterResultVC
}

final class OnboardingBuilderImpl: OnboardingBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shared) {
        self.container = container
    }
    
    func buildLogin() -> LoginVC {
        let viewModel: LoginImpl = container.resolve(LoginImpl.self)
        return LoginVC(viewModel: viewModel)
    }
    
//    func buildCreateNickname() -> CreateNicknameVC {
//        let viewModel: CreateNicknameVM = container.resolve(CreateNicknameVM.self)
//        return CreateNicknameVC(viewModel: viewModel)
//    }
//    
//    func buildCreatePersonalDetail() -> CreatePersonalDetailVC {
//        let viewModel: CreatePersonalDetailVM = container.resolve(CreatePersonalDetailVM.self)
//        return CreatePersonalDetailVC(viewModel: viewModel)
//    }
//    
//    func buildLogin() -> LoginVC {
//        let viewModel: LoginVM = container.resolve(LoginVM.self)
//        return LoginVC(viewModel: viewModel)
//    }
//    
//    func buildPrivacyPolicy() -> PrivacyPolicyVC {
//        let viewModel: PrivacyPolicyVM = container.resolve(PrivacyPolicyVM.self)
//        return PrivacyPolicyVC(viewModel: viewModel)
//    }
//    
//    func buildRegisterResult() -> RegisterResultVC {
//        let viewModel: RegisterResultVM = container.resolve(RegisterResultVM.self)
//        return RegisterResultVC(viewModel: viewModel)
//    }
}
