//
//  URLSession+Extension.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/03/03.
//

import UIKit

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
                
                switch response.statusCode {
                case 401:
                    completion(nil, .tokenExpired)
                    return
                case 200:
                    do {
                        let decoder = JSONDecoder()
                        let userData = try decoder.decode(T.self, from: data)
                        completion(userData, nil)
                        return
                    } catch {
                        completion(nil, .noData)
                    }
                case 400:
                    completion(nil, .invalidData)
                default:
                    completion(nil, .invalidResponse)
                    return
                }
            }
        }
    }
    
    static func request(_ session: URLSession = .shared, endPoint: URLRequest, completion: @escaping (APIError?) -> Void) {
        session.dataTask(endPoint) { data, response, error in
            DispatchQueue.main.async {
                guard error == nil else {
                    completion(.failed)
                    return
                }
                guard let response = response as? HTTPURLResponse else {
                    completion(.invalidResponse)
                    return
                }
                switch response.statusCode {
                case 401:
                    completion(.tokenExpired)
                    return
                case 200:
                    completion(nil)
                default:
                    completion(.failed)
                    return
                }
            }
        }
    }
}
