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
        setNavigation()
        bind()
    }
    
    func setNavigation() {
        self.title = "가입하기"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem =
        UIBarButtonItem(customView: signUpView.backButton)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .black
    }
    
    func bind() {
        let input = SignUpViewModel.Input(
            email: signUpView.emailTextField.rx.text,
            nickname: signUpView.nicknameTextFiled.rx.text,
            password: signUpView.passwordTextField.rx.text,
            checkPassword: signUpView.checkPasswordTextField.rx.text,
            singUpButtonTap: signUpView.signUpButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(output.validEmailStatus, output.validNicknameStatus, output.validPasswordStatus, output.differPasswordStatus) { a, b, c, d -> Bool in
            return a && b && c && d
        }.bind { [weak self] (result) in
            guard let self = self else { return }
            self.signUpView.signUpButton.isEnabled = result
            if result {
                UIView.animate(withDuration: 0.5) {
                    self.signUpView.signUpButton.backgroundColor = .systemIndigo
                }
            } else {
                self.signUpView.signUpButton.backgroundColor = .lightGray
            }
        }.disposed(by: disposeBag)
            
        output.sceneTransition
            .subscribe { [weak self] (_) in
                guard let self = self else { return }
                let nickname = self.signUpView.nicknameTextFiled.text ?? ""
                let email = self.signUpView.emailTextField.text ?? ""
                let password = self.signUpView.passwordTextField.text ?? ""
                
                self.viewModel.requestUserSignIn(nickname: nickname, email: email, password: password) { error in
                    if let error = error {
                        self.view.makeToast(error.rawValue)
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
