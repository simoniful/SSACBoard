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

// [To-Do] 페이지네이션, 소팅
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

extension URLSession {
    typealias Handler = (Data?, URLResponse?, Error?) -> ()
    
    @discardableResult
    func dataTask(_ endpoint: URLRequest, handler: @escaping Handler) -> URLSessionDataTask {
        let task = dataTask(with: endpoint, completionHandler: handler)
        task.resume()
        return task
    }
    
    static func request<T: Codable>(_ session: URLSession = .shared, endpoint: URLRequest, completion: @escaping (T?, APIError? ) -> ()) {
        session.dataTask(endpoint) { data, response, error in
            DispatchQueue.main.async {
                print(response)
                guard error == nil else {
                    completion(nil, .failed)
                    return
                }
                guard let data = data else {
                    completion(nil, .noData)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(nil, .invalidResponse)
                    return
                }
                // alert창 띄우고 확인 누르면 이동
                guard response.statusCode == 200 else {
                    if response.statusCode == 401 {
                        UserDefaults.standard.set("", forKey: "token")
                        UserDefaults.standard.set("", forKey: "nickname")
                        UserDefaults.standard.set("", forKey: "id")
                        UserDefaults.standard.set("", forKey: "email")
                        DispatchQueue.main.async {
                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: WelcomeViewController())
                            windowScene.windows.first?.makeKeyAndVisible()
                        }
                    }
                    completion(nil, .failed)
                    return
                }
                
                do {
                    let decorder = JSONDecoder()
                    let userData = try decorder.decode(T.self, from: data)
                    completion(userData, nil)
                } catch {
                    completion(nil, .invalidData)
                }
            }
        }
    }
}
