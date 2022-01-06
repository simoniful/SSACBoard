//
//  SignInViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import Foundation

class SignUpViewModel {
    var email: Observable<String> = Observable("")
    var nickname: Observable<String> = Observable("")
    var password: Observable<String> = Observable("")
    var checkPassword: Observable<String> = Observable("")
    
    func requestUserSignIn(completion: @escaping () -> ()) {
        APIService.signup(nickname: nickname.value, email: email.value, password: password.value) { userData, error in
            guard let userData = userData else { return }
            UserDefaults.standard.set(userData.jwt, forKey: "token")
            UserDefaults.standard.set(userData.user.username, forKey: "nickname")
            UserDefaults.standard.set(userData.user.id, forKey: "id")
            UserDefaults.standard.set(userData.user.email, forKey: "email")
            completion()
        }
    }
}
