//
//  AppDIContainer.swift
//  WeClimb
//
//  Created by 머성이 on 12/18/24.
//


import Swinject

final class AppDIContainer {
    static let shared = AppDIContainer()
    let assembler: Assembler
    let container: Container
    
    private init() {
        container = Container()
        
        assembler = Assembler([
            FeedSubDataSourceAssembly(),
            FeedSubRepositoryAssembly(),
            FeedSubUseCaseAssembly(),
            GymDataSourceAssembly(),
            GymRepositoryAssembly(),
            GymUseCaseAssembly(),
            LoginDataSourceAssembly(),
            LoginRepositoryAssembly(),
            LoginUseCaseAssembly(),
            PostDataSourceAssembly(),
            PostRepositoryAssembly(),
            PostUseCaseAssembly(),
            UploadDataSourceAssembly(),
            UploadRepositoryAssembly(),
            UploadUseCaseAssembly(),
            UserDataSourceAssembly(),
            UserRepositoryAssembly(),
            UserUseCaseAssembly(),
            FeedAssembly(),
            GymProfileAssembly(),
            NotificationAssembly(),
            LoginAssembly(),
            SearchAssembly(),
            SettingAssembly(),
            UploadAssembly(),
            UserPageAssembly(),
            TabBarAssembly(),
            LevelHoldFilterAssembly(),
        ], container: container)
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        guard let resolved = assembler.resolver.resolve(type) else {
            fatalError("resolve 단계에서 실패했어요!")
        }
        return resolved
    }
}
