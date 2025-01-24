//
//  MyUIDUseCase.swift
//  WeClimb
//
//  Created by Soobeen Jang on 1/20/25.
//
protocol MyUIDUseCase {
    func execute() throws -> String
}

struct MyUIDUseCaseImpl: MyUIDUseCase {
    private let userReadRepository: UserReadRepository
    
    init(userReadRepository: UserReadRepository) {
        self.userReadRepository = userReadRepository
    }
    
    func execute() throws -> String {
        return try userReadRepository.myUID()
    }
}
