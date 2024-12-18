//
//  NotificationBuilder.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//

import Foundation

protocol NotificationBuilder {
//    func buildPushNotification() -> PushNotificationVC
}

final class NotificationBuilderImpl: NotificationBuilder {
    private let container: AppDIContainer
    
    init(container: AppDIContainer = .shard) {
        self.container = container
    }
    
//    func buildPushNotification() -> PushNotificationVC {
//        let viewModel: PushNotificationVM = container.resolve(PushNotificationVM.self)
//        return PushNotificationVC(viewModel: viewModel)
//    }
}
