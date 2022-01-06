//
//  Comment.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import Foundation

// MARK: - CommentElement
struct CommentElement: Codable {
    let id: Int
    let comment: String
    let user: CommentUser
    let post: CommentPost
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, comment, user, post
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

//
// To read values from URLs:
//
//   let task = URLSession.shared.postTask(with: url) { post, response, error in
//     if let post = post {
//       ...
//     }
//   }
//   task.resume()

// MARK: - Post
struct CommentPost: Codable {
    let id: Int
    let text: String
    let user: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, text, user
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

// MARK: - User
struct CommentUser: Codable {
    let id: Int
    let username, email, provider: String
    let confirmed: Bool
    let blocked: Bool?
    let role: Int
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, username, email, provider, confirmed, blocked, role
        case createdAt = "created_at"
        case updatedAt = "updated_at"
    }
}

typealias Comment = [CommentElement]
