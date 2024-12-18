//
//  GymProfileBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol GymProfileBuilder {
//    func buildGymProfile() -> GymProfileVC
}

final class GymProfileBuilderImpl: GymProfileBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shard) {
        self.container = container
    }
    
//    func buildGymProfile() -> GymProfileVC {
//        let viewModel: GymProfileVM = container.resolve(GymProfileVM.self)
//        return GymProfileVC(viewModel: viewModel)
//    }
}
