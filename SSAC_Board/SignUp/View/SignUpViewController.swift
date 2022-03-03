//
//  SignUpViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import UIKit
import RxSwift
import RxCocoa

class SignUpViewController: UIViewController {
    let disposeBag = DisposeBag()
    let signUpView = SignUpView()
    let viewModel = SignUpViewModel()
    
    override func loadView() {
        self.view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "새싹농장 가입하기"
        bind()
    }
    
    func bind() {
        let input = SignUpViewModel.Input(
            email: signUpView.emailTextField.rx.text,
            nickname: signUpView.nicknameTextFiled.rx.text,
            password: signUpView.passwordTextField.rx.text,
            checkPassword: signUpView.checkPasswordTextField.rx.text,
            tap: signUpView.signUpButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(output.validEmailStatus, output.validNicknameStatus, output.validPasswordStatus, output.differPasswordStatus) { a, b, c, d -> Bool in
            return a && b && c && d
        }.bind(onNext: { result in
            self.signUpView.signUpButton.isEnabled = result
            if result {
                UIView.animate(withDuration: 1) {
                    self.signUpView.signUpButton.backgroundColor = UIColor(red: 59/255, green: 195/255, blue: 113/255, alpha: 1)
                }
            } else {
                self.signUpView.signUpButton.backgroundColor = .lightGray
            }
        }).disposed(by: disposeBag)
            
        output.sceneTransition
            .subscribe { _ in
                let nickname = self.signUpView.nicknameTextFiled.text ?? ""
                let email = self.signUpView.emailTextField.text ?? ""
                let password = self.signUpView.passwordTextField.text ?? ""
                
                self.viewModel.requestUserSignIn(nickname: nickname, email: email, password: password) { errorMessage in
                    if let errorMessage = errorMessage {
                        self.view.makeToast(errorMessage)
                    } else {
                        DispatchQueue.main.async {
                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: SignInViewController())
                            windowScene.windows.first?.makeKeyAndVisible()
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
