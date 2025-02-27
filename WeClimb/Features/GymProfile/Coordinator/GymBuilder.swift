//
//  GymProfileBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol GymBuilder {
    func buildGymProfile(gymName: String, level: LHColors?, hold: LHColors?) -> GymProfileVC
}

final class GymBuilderImpl: GymBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shared) {
        self.container = container
    }
    
    func buildGymProfile(gymName: String, level: LHColors?, hold: LHColors?) -> GymProfileVC {
        let viewModel: GymProfileVM = container.resolve(GymProfileVM.self)
        return GymProfileVC(viewModel: viewModel, gymName: gymName, level: level, hold: hold)
    }
}
