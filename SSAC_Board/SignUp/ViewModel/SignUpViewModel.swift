//
//  SignInViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import Foundation
import RxCocoa
import RxSwift
import Toast

protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
    var disposeBag: DisposeBag { get set }
}

class SignUpViewModel: CommonViewModel {
    var disposeBag: DisposeBag =  DisposeBag()
   
    struct Input {
        let email: ControlProperty<String?>
        let nickname: ControlProperty<String?>
        let password: ControlProperty<String?>
        let checkPassword: ControlProperty<String?>
        let tap: ControlEvent<Void>
    }
    
    struct Output {
        let validNicknameStatus: Observable<Bool>
        let validEmailStatus: Observable<Bool>
        let validPasswordStatus: Observable<Bool>
        let differPasswordStatus: Observable<Bool>
        let sceneTransition: ControlEvent<Void>
    }
    
    func transform(input: Input) -> Output {
        let resultNickname = input.nickname
            .orEmpty
            .map { $0.count >= 2 }
            .share(replay: 1, scope: .whileConnected)
        
        let resultEmail = input.email
            .orEmpty
            .map { self.isValidEmail(testStr: $0) }
            .share(replay: 1, scope: .whileConnected)
        
        let resultPassword = input.password
            .orEmpty
            .map { $0.count >= 4 }
            .share(replay: 1, scope: .whileConnected)
        
        let resultCheckPassword = Observable.combineLatest(input.password.orEmpty, input.checkPassword.orEmpty) { a, b -> Bool in
            return a == b
        }.share(replay: 1, scope: .whileConnected)
            
        return Output(validNicknameStatus: resultNickname, validEmailStatus: resultEmail, validPasswordStatus: resultPassword, differPasswordStatus: resultCheckPassword, sceneTransition: input.tap)
    }
    
    func isValidEmail(testStr:String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: testStr)
    }
    
    func requestUserSignIn(nickname: String, email: String, password: String, completion: @escaping (String?) -> ()) {

        APIService.signup(nickname: nickname, email: email, password: password) { userData, error in
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
