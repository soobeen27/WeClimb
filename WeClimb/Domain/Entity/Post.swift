//
//  Post.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/11/24.
//

import Foundation
import FirebaseFirestore

struct Media: Codable {
    let mediaUID: String
    let url: String
    let hold: String?
    let grade: String?
    let gym: String?
    let creationDate: Date?
    let postRef: DocumentReference?
    let thumbnailURL: String?
    let height: Int?
    let armReach: Int?
    //    let authorUID: String
    //    let postUID: String
    //    let gym: String?
}

//게시글
struct Post: Codable {
    let postUID: String
    let authorUID: String
    let creationDate: Date
    let caption: String?
    let like: [String]?
    let gym: String?
    let medias: [DocumentReference]?
    let thumbnail: String?
    let commentCount: Int?
//    let medias: [Media]?
}

// 댓글
struct Comment: Codable {
    let commentUID: String
    let authorUID: String
    let content: String
    let creationDate: Date
    let like: [String]?
    let postRef: DocumentReference
}

