//
//  SignInViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import Foundation
import UIKit

class SignInViewController: UIViewController {
    let signInView = SignInView()
    let viewModel = SignInViewModel()
    
    override func loadView() {
        self.view = signInView
    }
    
    // [To-Do] 버튼 enable에 따른 UI 변화, 유효성 검사, 비밀번호란 변경
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "새싹농장 로그인"
        
        viewModel.email.bind { text in
            self.signInView.emailTextField.text = text
        }
        
        viewModel.password.bind { text in
            self.signInView.passwordTextField.text = text
        }
        
        signInView.emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange(_:)), for: .editingChanged)
        
        signInView.passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange(_:)), for: .editingChanged)
        
        signInView.signInButton.addTarget(self, action: #selector(signInButtonClicked), for: .touchUpInside)
    }
    
    @objc func emailTextFieldDidChange(_ textfield: UITextField) {
        viewModel.email.value = textfield.text ?? ""
    }
    
    @objc func passwordTextFieldDidChange(_ textfield: UITextField) {
        viewModel.password.value = textfield.text ?? ""
    }
    
    @objc func signInButtonClicked() {
        viewModel.requestUserSignIn { errerMessage in
            if let errerMessage = errerMessage {
                self.view.makeToast(errerMessage)
            } else {
                DispatchQueue.main.async {
                    guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                    windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: PostViewController())
                    windowScene.windows.first?.makeKeyAndVisible()
                }
            }
        }
    }
}
