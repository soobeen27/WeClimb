//
//  WebPageOpenUseCase.swift
//  WeClimb
//
//  Created by 강유정 on 11/29/24.
//

import RxSwift
import SafariServices

import WebKit
import UIKit

public protocol WebPageOpenUseCase {
    func openWeb(urlString: String)
}

public struct WebPageOpenUseCaseImpl: WebPageOpenUseCase {
    
    public func openWeb(urlString: String) {
        guard let url = URL(string: urlString) else {
            print("잘못된 URL")
            return
        }

        if UIApplication.shared.canOpenURL(url) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            print("URL을 열 수 없음")
        }
    }
}
