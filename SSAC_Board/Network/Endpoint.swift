//
//  Endpoint.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import Foundation
import UIKit
import Toast

enum Method: String {
    case GET
    case POST
    case PUT
    case DELETE
}

enum Endpoint {
    case signup
    case signIn
    case changePassword
    case createPost
    case readPost
    case updatePost(id: Int)
    case deletePost(id: Int)
    case createComment
    case readComment(id: Int)
    case updateComment(id: Int)
    case deleteComment(id: Int)
}

extension Endpoint {
    var url: URL {
        switch self {
        case .signup:
            return .makeEndpoint("auth/local/register")
        case .signIn:
            return .makeEndpoint("auth/local")
        case .changePassword:
            return .makeEndpoint("custom/change-password")
        case .createPost:
            return .makeEndpoint("posts")
        case .readPost:
            return .makeEndpoint("posts?_sort=created_at:desc")
        case .updatePost(id: let id):
            return .makeEndpoint("posts/\(id)")
        case .deletePost(id: let id):
            return .makeEndpoint("posts/\(id)")
        case .createComment:
            return .makeEndpoint("comments")
        case .readComment(id: let id):
            return .makeEndpoint("comments?post=\(id)")
        case .updateComment(id: let id):
            return .makeEndpoint("comments/\(id)")
        case .deleteComment(id: let id):
            return .makeEndpoint("comments/\(id)")
        }
    }
}

extension URL {
    static let baseURL = "http://test.monocoding.com:1231/"
    static func makeEndpoint(_ endpoint: String) -> URL {
        URL(string: baseURL + endpoint)!
    }
}

