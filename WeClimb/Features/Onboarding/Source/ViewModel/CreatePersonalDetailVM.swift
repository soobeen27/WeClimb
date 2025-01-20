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
        let height: Observable<Int>
        let armReach: Observable<Int?>
        let confirmButtonTap: Observable<Void>
    }
    
    struct Output {
        let isHeightValid: Observable<Bool>
        let isFormValid: Observable<Bool>
        let updateResult: Completable
    }
    
    func transform(input: Input) -> Output {
        let isHeightValid = input.height
            .map { $0 > 1 }
            .share(replay: 1, scope: .whileConnected)
        
        let isFormValid = isHeightValid
        
        let updateResult = input.confirmButtonTap
            .withLatestFrom(Observable.combineLatest(input.height, input.armReach))
            .flatMapLatest { [weak self] (height: Int, armReach: Int?) -> Completable in
                guard let self else { return Completable.error(AppError.unknown) }
                
                let heightUpdate = self.updateUseCase.execute(height: height)
                
                if let armReach = armReach {
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
