//
//  UploadDataSourceAssembly.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/9/25.
//
import Swinject

final class UploadDataSourceAssembly: Assembly {
    func assemble(container: Container) {
        container.register(UploadPostDataSource.self) { _ in
            UploadPostDataSourceImpl()
        }
    }
}
