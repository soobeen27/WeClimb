//
//  Post.swift
//  WeClimb
//
//  Created by Soobeen Jang on 9/11/24.
//

import Foundation
import FirebaseFirestore

struct Media: Codable {
    let url: String
    let sector: String
    let grade: String
}

//게시글
struct Post: Codable {
    let postUID: String
    let authorUID: String
    let creationDate: Date
    let caption: String?
    let like: Int
    let gym: String?
    let medias: [Media]?
}

// 댓글
struct Comment: Codable {
    let commentUID: String
    let authorUID: String
    let content: String
    let creationDate: Date;
    let like: Int
    let postRef: DocumentReference
}

