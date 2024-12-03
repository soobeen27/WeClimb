//
//  FeedNameSpace.swift
//  WeClimb
//
//  Created by 김솔비 on 9/10/24.
//

import Foundation

enum FeedNameSpace {
    //report Modal 신고하기 모달
    static let reportTitle = "신 고"
    static let reportLabel = """
       신고 사유를 아래에서 선택해 주세요
       신고된 내역은 위클 운영팀에서 확인 후 조치됩니다
       """
    static let reportReason1 = "스팸 또는 허가되지 않은 광고게시물"
    static let reportReason2 = "타인 비방 조장 게시물"
    static let reportReason3 = "음란&폭력성 게시물"
    static let reportReason4 = "암장 정보가 일치하지 않음"
    static let reportReason5 = "클라이밍 관련 게시물이 아님"
    static let reportReason6 = "기타 사유"
    
    static let reportReasons = [
        reportReason1,
        reportReason2,
        reportReason3,
        reportReason4,
        reportReason5,
        reportReason6
    ]
    
    static let commentTest1 = "혹시 오랑우탄 인가요?"
    static let commentTest2 = "대표님 멋있어용"
    static let commentTest3 = "퍼가요~🤍"
    
    static let commentList = [
        commentTest1,
        commentTest2,
        commentTest3
    ]
    
    static let likeCount = "0"
    static let commentCount = "0"
}
