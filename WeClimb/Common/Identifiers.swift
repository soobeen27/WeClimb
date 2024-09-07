//
//  Identifiers.swift
//  WeClimb
//
//  Created by Soo Jang on 8/26/24.
//

import Foundation

enum Identifiers {
    // Upload 뷰용 아이디
    static let addVideoCell = "AddVideoCell"
    static let captionCell = "CaptionCell"
    static let uploadOptionCell = "UploadOptionCell"
    
//    //MainFeed CollectionView Cell
//    static let yourCollectionViewCellIdentifier = "YourCollectionViewCellIdentifier"
    
    //SFMainfeedVC 식별자
    static let mainCollectionViewCell = "MainCollectionViewCell"
    
    //SFCollectionViewCell 식별자
    static let collectionViewCell = "CollectionViewCell"
    
    // SectionTableViewCell
    static let sectionTableViewCell = "SectionTableViewCell"
    
    // sectionDetailTableViewCell
    static let sectionDetailTableViewCell = "SectionDetailTableViewCell"
}

// MARK: - 클래스 이름을 문자열로 반환
extension NSObject {
    
    // 인스턴스가 어떤 클래스의 객체인지 문자열로 반환
    var className: String {
        return String(describing: type(of: self))
    }
    
    // 클래스 자체의 타입 이름을 문자열로 반환
    class var className: String {
        return String(describing: self)
    }
    
}
