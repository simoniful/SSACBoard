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
    
    // [To-Do] 버튼 enable에 따른 UI 변화, 유효성 검사, 비밀번호란 변경 
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
        
        output.validEmailStatus
            .bind(to: signUpView.signUpButton.rx.isEnabled, signUpView.emailValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.validEmailText
            .bind(to: signUpView.emailValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validNicknameStatus
            .bind(to: signUpView.signUpButton.rx.isEnabled, signUpView.nicknameValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.validNicknameText
            .bind(to: signUpView.nicknameValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.validPasswordStatus
            .bind(to: signUpView.signUpButton.rx.isEnabled, signUpView.passwordValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.validPasswordText
            .bind(to: signUpView.passwordValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        output.differPasswordStatus
            .bind(to: signUpView.signUpButton.rx.isEnabled, signUpView.checkPasswordValidationLabel.rx.isHidden)
            .disposed(by: disposeBag)
        
        output.differPasswordText
            .bind(to: signUpView.checkPasswordValidationLabel.rx.text)
            .disposed(by: disposeBag)
        
        
            
        
        output.sceneTransition
            .subscribe { _ in
                self.viewModel.requestUserSignIn(input: input) {
                    DispatchQueue.main.async {
                        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                        windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: SignInViewController())
                        windowScene.windows.first?.makeKeyAndVisible()
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
