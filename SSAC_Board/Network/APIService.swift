//
//  APIService.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import Foundation

enum APIError: String, Error {
    case invalid = "유효하지 않은 접근입니다"
    case noData = "이메일과 비밀번호를 기입해주세요"
    case failed = "이메일과 비밀번호를 다시 확인해주세요"
    case invalidResponse = "정상적인 접근이 아닙니다"
    case invalidData = "입력값이 올바르지 않습니다. 다시 확인해주세요"
    case tokenExpired = "유효하지 않은 접근입니다. 다시 로그인해주세요"
}

class APIService {
    static func signup(nickname: String, email: String, password: String, completion: @escaping (User?, APIError? ) -> ()) {
        var request = URLRequest(url: Endpoint.signup.url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "username=\(nickname)&email=\(email)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func signIn(identifier: String, password: String, completion: @escaping (User?, APIError? ) -> ()) {
        var request = URLRequest(url: Endpoint.signIn.url)
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "identifier=\(identifier)&password=\(password)".data(using: .utf8, allowLossyConversion: false)
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func changePassword(currentPassword: String, newPassword: String, checkPassword: String, completion: @escaping (User?, APIError? ) -> ()) {
        var request = URLRequest(url: Endpoint.changePassword.url)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.httpMethod = Method.POST.rawValue
        request.httpBody = "currentPassword=\(currentPassword)&newPassword=\(newPassword)&confirmNewPassword=\(checkPassword)".data(using: .utf8, allowLossyConversion: false)
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func readPost(start: Int, limit: Int, completion: @escaping ([Post]?, APIError? ) -> ()) {
        let urlString = "http://test.monocoding.com:1231/posts"
        var component = URLComponents(string: urlString)
                
        let order = URLQueryItem(name: "_sort", value: "created_at:desc")
        let start = URLQueryItem(name: "_start", value: "\(start)")
        let limit = URLQueryItem(name: "_limit", value: "\(limit)")
        component?.queryItems = [order, start, limit]
        
        let url = component?.url
        
        var request = URLRequest(url: url!)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.httpMethod = Method.GET.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func createPost(text: String, completion: @escaping (Post?, APIError?) -> ()) {
        var request = URLRequest(url: Endpoint.createPost.url)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.httpMethod = Method.POST.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func updatePost(text: String, postId: Int, completion: @escaping (Post?, APIError?) -> ()) {
        var request = URLRequest(url: Endpoint.updatePost(id: postId).url)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.httpMethod = Method.PUT.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = "text=\(text)".data(using: .utf8, allowLossyConversion: false)
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func deletePost(postId: Int, completion: @escaping (Post?, APIError?) -> ()) {
        var request = URLRequest(url: Endpoint.deletePost(id: postId).url)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.httpMethod = Method.DELETE.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func countPost(completion: @escaping (Int?, APIError?) -> Void) {
        var request = URLRequest(url: Endpoint.countPost.url)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.setValue("bearer \(token)", forHTTPHeaderField: "Authorization")
        
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func readComment(postId: Int, completion: @escaping (Comment?, APIError?) -> ()) {
        var request = URLRequest(url: Endpoint.readComment(id: postId).url)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.httpMethod = Method.GET.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func createComment(postId: Int, comment: String ,completion: @escaping (CommentElement?, APIError?) -> ()) {
        var request = URLRequest(url: Endpoint.createComment.url)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.httpMethod = Method.POST.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = "comment=\(comment)&post=\(postId)".data(using: .utf8, allowLossyConversion: false)
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func updateComment(commentId: Int, postId: Int ,comment: String ,completion: @escaping (CommentElement?, APIError?) -> ()) {
        var request = URLRequest(url: Endpoint.updateComment(id: commentId).url)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.httpMethod = Method.PUT.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        request.httpBody = "comment=\(comment)&post=\(postId)".data(using: .utf8, allowLossyConversion: false)
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
    
    static func deleteCommet(commentId: Int, completion: @escaping (CommentElement?, APIError?) -> ()) {
        var request = URLRequest(url: Endpoint.deleteComment(id: commentId).url)
        let token = UserDefaults.standard.string(forKey: "token")!
        request.httpMethod = Method.DELETE.rawValue
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.addValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        // request.addValue(“YOUR NAME”, forHTTPHeaderField: “name”)
        URLSession.request(.shared, endpoint: request, completion: completion)
    }
}
