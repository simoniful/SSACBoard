//
//  SignUpViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import UIKit

class SignUpViewController: UIViewController {
    let signUpView = SignUpView()
    let viewModel = SignUpViewModel()
    
    // [To-Do] 버튼 enable에 따른 UI 변화, 유효성 검사, 비밀번호란 변경 
    override func loadView() {
        self.view = signUpView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "새싹농장 가입하기"
        
        viewModel.email.bind { text in
            self.signUpView.emailTextField.text = text
        }
        
        viewModel.nickname.bind { text in
            self.signUpView.nicknameTextFiled.text = text
        }
        
        viewModel.password.bind { text in
            self.signUpView.passwordTextField.text = text
        }
        
        viewModel.checkPassword.bind { text in
            self.signUpView.checkPasswordTextField.text = text
        }
        
        signUpView.emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        
        signUpView.nicknameTextFiled.addTarget(self, action: #selector(nicknameTextFiledDidChange(_:)), for: .editingChanged)
        
        signUpView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        
        signUpView.checkPasswordTextField.addTarget(self, action: #selector(checkPasswordTextFieldDidChange(_:)), for: .editingChanged)
        
        signUpView.signUpButton.addTarget(self, action: #selector(signUpButtonClicked), for: .touchUpInside)
    }
    
    @objc func emailTextFieldDidChange(_ textfield: UITextField) {
        viewModel.email.value = textfield.text ?? ""
    }
    
    @objc func nicknameTextFiledDidChange(_ textfield: UITextField) {
        viewModel.nickname.value = textfield.text ?? ""
    }
    
    @objc func passwordTextFieldDidChange(_ textfield: UITextField) {
        viewModel.password.value = textfield.text ?? ""
    }
    
    @objc func checkPasswordTextFieldDidChange(_ textfield: UITextField) {
        viewModel.checkPassword.value = textfield.text ?? ""
    }
    
    @objc func signUpButtonClicked() {
        viewModel.requestUserSignIn {
            DispatchQueue.main.async {
                guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: SignInViewController())
                windowScene.windows.first?.makeKeyAndVisible()
            }
        }
    }
}
