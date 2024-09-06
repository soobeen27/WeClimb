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
    // Input: 닉네임 텍스트 (외부에서 접근할 수 있도록 public)
    let nicknameInput = PublishSubject<String>()
    
    // 정규화: 공백 제거 및 유효한 문자인지 검사하는 함수 (외부에 노출할 필요 없으므로 private)
    private func normalizeNickname(_ nickname: String) -> String {
        let trimmed = nickname.trimmingCharacters(in: .whitespaces)
        // 한글, 영어, 숫자만 허용하는 정규식
        let regex = "^[가-힣a-zA-Z0-9]*$"
        if trimmed.range(of: regex, options: .regularExpression) != nil {
            return trimmed
        } else {
            return ""
        }
    }
    
    // Output: 닉네임이 유효한지 여부 (2~12글자, 정규식 통과)
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
                guard let self = self else { return "0/12" }
                let normalizedNickname = self.normalizeNickname(nickname)
                return "\(normalizedNickname.count)/12"
            }
            .distinctUntilChanged()
    }
}
