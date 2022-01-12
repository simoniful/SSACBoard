//
//  SIgnInViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import Foundation

class SignInViewModel {
    var email: _Observable<String> = _Observable("")
    var password: _Observable<String> = _Observable("")
    
    func requestUserSignIn(completion: @escaping (String?) -> ()) {
        APIService.signIn(identifier: email.value, password: password.value) { userData, error in
            if let error = error {
                switch error {
                case .invalid:
                    completion("유효하지 않은 접근입니다")
                case .noData:
                    completion("이메일과 비밀번호를 다시 확인해주세요")
                case .failed:
                    completion("이메일과 비밀번호를 다시 확인해주세요")
                case .invalidResponse:
                    completion("유효하지 않은 접근입니다")
                case .invalidData:
                    completion("유효하지 않은 데이터 형식입니다")
                }
            }
            
            guard let userData = userData else { return }
            UserDefaults.standard.set(userData.jwt, forKey: "token")
            UserDefaults.standard.set(userData.user.username, forKey: "nickname")
            UserDefaults.standard.set(userData.user.id, forKey: "id")
            UserDefaults.standard.set(userData.user.email, forKey: "email")
            completion(nil)
        }
    }
}

