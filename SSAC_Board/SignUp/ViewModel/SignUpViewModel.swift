//
//  SignInViewModel.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import Foundation
import RxCocoa
import RxSwift

protocol CommonViewModel {
    associatedtype Input
    associatedtype Output
    func transform(input: Input) -> Output
    var disposeBag: DisposeBag { get set }
}

class SignUpViewModel: CommonViewModel {
    var disposeBag: DisposeBag =  DisposeBag()
    var validNicknameText = BehaviorRelay<String>(value: "닉네임은 최소 2자 이상 필요합니다")
    var validEmailText = BehaviorRelay<String>(value: "적절한 이메일 형식이 아닙니다")
    var validPasswordText = BehaviorRelay<String>(value: "비밀번호는 최소 4자 이상 필요합니다")
    var differPasswordText = BehaviorRelay<String>(value: "작성한 비밀번호와 다릅니다")
    
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
        
        let validNicknameText: BehaviorRelay<String>
        let validEmailText: BehaviorRelay<String>
        let validPasswordText: BehaviorRelay<String>
        let differPasswordText: BehaviorRelay<String>
        
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
            
        return Output(validNicknameStatus: resultNickname, validEmailStatus: resultEmail, validPasswordStatus: resultPassword, differPasswordStatus: resultCheckPassword, validNicknameText: validNicknameText, validEmailText: validEmailText, validPasswordText: validPasswordText, differPasswordText: differPasswordText, sceneTransition: input.tap)
    }
    
    func isValidEmail(testStr:String) -> Bool {
          let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
          let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
          return emailTest.evaluate(with: testStr)
    }
    
    func requestUserSignIn(input: Input, completion: @escaping () -> ()) {
        var nickname: String?
        var email: String?
        var password: String?
        
        input.nickname.orEmpty
            .subscribe(onNext: { nickname = $0 })
            .disposed(by: disposeBag)

        input.email.orEmpty
            .subscribe(onNext: { email = $0 })
            .disposed(by: disposeBag)
        
        input.password.orEmpty
            .subscribe(onNext: { password = $0 })
            .disposed(by: disposeBag)
        
        APIService.signup(nickname: nickname!, email: email!, password: password!) { userData, error in
            guard let userData = userData else { return }
            UserDefaults.standard.set(userData.jwt, forKey: "token")
            UserDefaults.standard.set(userData.user.username, forKey: "nickname")
            UserDefaults.standard.set(userData.user.id, forKey: "id")
            UserDefaults.standard.set(userData.user.email, forKey: "email")
            completion()
        }
    }
}
