//
//  ClimbingGymNameSpace.swift
//  WeClimb
//
//  Created by 머성이 on 9/3/24.
//

import Foundation

enum ClimbingGymNameSpace {

    static let follow = "팔로우"
    static let unFollow = "언팔로우"
    
    // GymHeaderView
    static let profileName = "000클라이밍"
    static var totalFollow: Int = 1999
    static var follower: String {
        return "\(totalFollow) 팔로워"
    }
    static let segmentFirst = "세팅"
    static let segmentSecond = "정보"
    
    // ClimbingGymInfoView
    static let facility = "시설정보"
    static let difficulty = "난이도"
    static let difficultyDescription = "총 8개의 난이도가 있어요!"
    static let noInfo = "정보가 없거나 잘못된 정보가 있다면 알려주세요!"
    
    static let FacilityFirst = "지구력"
    static let FacilitySecond = "스트레칭존"
    static let FacilityThird = "트레이닝존"
    static let FacilityFourth = "샤워실"
    
}
