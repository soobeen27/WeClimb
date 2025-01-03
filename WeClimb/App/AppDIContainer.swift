//
//  AppDIContainer.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//


import Swinject

final class AppDIContainer {
    static let shard = AppDIContainer()
    private let assembler: Assembler
    
    private init() {
        assembler = Assembler([
            FeedAssembly(),
            GymProfileAssembly(),
            NotificationAssembly(),
            LoginAssembly(),
            SearchAssembly(),
            SettingAssembly(),
            UploadAssembly(),
            UserPageAssembly(),
        ])
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = assembler.resolver.resolve(type) else {
            fatalError("resolve 단계에서 실패했어요!")
        }
        return resolved
    }
}
