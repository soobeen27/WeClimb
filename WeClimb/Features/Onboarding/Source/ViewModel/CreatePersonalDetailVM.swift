//
//  CreatePersonalDetailVM.swift
//  WeClimb
//
//  Created by 윤대성 on 1/10/25.
//

import UIKit

import RxCocoa
import RxSwift

protocol CreatePersonalDetailVM {
    func transform(input: CreatePersonalDetailImpl.Input) -> CreatePersonalDetailImpl.Output
}

class CreatePersonalDetailImpl: CreatePersonalDetailVM {
    private let disposeBag = DisposeBag()
    private let updateUseCase: PersonalDetailUseCase
    
    init(updateUseCase: PersonalDetailUseCase) {
        self.updateUseCase = updateUseCase
    }
    
    struct Input {
        let height: Observable<String>
        let armReach: Observable<String?>
        let confirmButtonTap: Observable<Void>
    }
    
    struct Output {
        let isHeightValid: Observable<Bool>
        let isFormValid: Observable<Bool>
        let updateResult: Completable
    }
    
    func transform(input: Input) -> Output {
        let isHeightValid = input.height
            .map { !$0.isEmpty && Int($0) != nil }
            .share(replay: 1, scope: .whileConnected)
        
        let isFormValid = isHeightValid
        
        let updateResult = input.confirmButtonTap
            .withLatestFrom(Observable.combineLatest(input.height, input.armReach))
            .flatMapLatest { [weak self] (height: String, armReach: String?) -> Completable in
                guard let self else { return Completable.error(AppError.unknown) }
                
                let heightUpdate = self.updateUseCase.execute(height: height)
                
                if let armReach = armReach, !armReach.isEmpty {
                    let armReachUpdate = self.updateUseCase.execute(armReach: armReach)
                    return Completable.zip(heightUpdate, armReachUpdate)
                }
                
                return heightUpdate
            }
            .asCompletable()
            
        return Output(
            isHeightValid: isHeightValid,
            isFormValid: isFormValid,
            updateResult: updateResult
        )
    }
}
