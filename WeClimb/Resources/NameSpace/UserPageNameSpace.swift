//
//  UserPageNameSpace.swift
//  WeClimb
//
//  Created by 강유정 on 8/28/24.
//

import Foundation
import UIKit

enum UserPageNameSpace {
    static let follow = "팔로우"
    static let following = "팔로잉"
    static let logout = "로그아웃"
    static let close = "닫기"
    static let none = "미정"

}


enum SomeViewConstants {
    enum Color {
        static let black = UIColor.black
    }
    
    enum Font {
        static let regular = UIFont.systemFont(ofSize: 14)
    }
    
    enum Image {
        static let close = UIImage(systemName: "xmark")
    }
    
    enum Size {
        static let padding: CGFloat = 16
    }
    
    enum Spacing {
        static let padding: CGFloat = 16
    }
    
    enum Text {
        static let none = "미정"
    }
}
