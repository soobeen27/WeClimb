//
//  Post.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/11/24.
//

import Foundation

// 게시글
struct Post: Codable {
    let postUID: String // 글 유아이디
    let creationDate: Date // 생성날짜
    let caption: String?
    let medias: [String]
    let like: Int
}

// 댓글
struct Comment: Codable {
    let commentUID: String // 댓글 유아이디
    let text: String
    let from: String //댓글 쓴 사람 uid
    let creationDate: Date
    let like: Int
}
