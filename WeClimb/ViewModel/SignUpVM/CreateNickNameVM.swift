//
//  PersonalDetailsVM.swift
//  WeClimb
//
//  Created by 머성이 on 9/5/24.
//

import Foundation

import RxCocoa
import RxSwift

class CreateNickNameVM {
    // Input: 닉네임 텍스트
    let nicknameInput = BehaviorSubject<String>(value: "")
    private let checkDuplicationSubject = PublishSubject<Void>()
    
    // Output: 닉네임이 유효한지 여부
    var isNicknameValid: Observable<Bool> {
        return nicknameInput
            .map { [weak self] nickname in
                guard let self = self else { return false }
                let normalizedNickname = self.normalizeNickname(nickname)
                return normalizedNickname.count >= 2 && normalizedNickname.count <= 12
            }
            .distinctUntilChanged()
    }
    
    // Output: 닉네임의 글자 수 (0/12 형식, 정규화 후)
    var nicknameCharacterCount: Observable<String> {
        return nicknameInput
            .map { [weak self] nickname in
                guard let self else { return "0/12" }
                let normalizedNickname = self.normalizeNickname(nickname)
                return "\(normalizedNickname.count)/12"
            }
            .distinctUntilChanged()
    }
    
    // Output: 닉네임 중복 여부 (확인 버튼을 눌렀을 때만)
    var isNicknameDuplicateCheck: Observable<Bool> {
        return checkDuplicationSubject
            .withLatestFrom(nicknameInput)
            .flatMapLatest { nickname in
                return Observable<Bool>.create { observer in
                    FirebaseManager.shared.duplicationCheck(with: nickname) { isDuplicate in
                        observer.onNext(isDuplicate)
                        observer.onCompleted()
                    }
                    return Disposables.create()
                }
            }
    }
    
    // 닉네임 중복 체크 실행
    func checkNicknameDuplication() {
        checkDuplicationSubject.onNext(())
    }
    
    private func normalizeNickname(_ nickname: String) -> String {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        let regex = "^[가-힣a-zA-Z0-9]*$"
        return trimmed.range(of: regex, options: .regularExpression) != nil ? trimmed : ""
    }
}
