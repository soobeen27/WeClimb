//
//  NicknameDuplicationCheckUseCase.swift
//  WeClimb
//
//  Created by 윤대성 on 1/9/25.
//

import Foundation

import RxSwift

protocol NicknameDuplicationCheckUseCase {
    func execute(name: String) -> Single<Bool>
}

final class NicknameDuplicationCheckUseCaseImpl: NicknameDuplicationCheckUseCase {
    private let NicknameDuplicationCheckRepository: NicknameDuplicationCheckRepository
    
    init(NicknameDuplicationCheckRepository: NicknameDuplicationCheckRepository) {
        self.NicknameDuplicationCheckRepository = NicknameDuplicationCheckRepository
    }
    
    func execute(name: String) -> Single<Bool> {
        return NicknameDuplicationCheckRepository.checkUserNameDuplication(name: name)
            .map { user in
                return user == nil
            }
    }
}
