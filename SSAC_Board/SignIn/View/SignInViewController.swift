//
//  SignInViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import UIKit
import RxSwift
import RxCocoa

class SignInViewController: UIViewController {
    let disposeBag = DisposeBag()
    let signInView = SignInView()
    let viewModel = SignInViewModel()
    
    override func loadView() {
        self.view = signInView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
        bind()
    }
    
    func setNavigation() {
        self.title = "로그인"
        self.navigationController?.navigationBar.topItem?.backBarButtonItem =
        UIBarButtonItem(customView: signInView.backButton)
        self.navigationController?.navigationBar.topItem?.backBarButtonItem?.tintColor = .black
    }
    
    func bind() {
        let input = SignInViewModel.Input(
            email: signInView.emailTextField.rx.text,
            password: signInView.passwordTextField.rx.text,
            tap: signInView.signInButton.rx.tap
        )
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(output.validEmailStatus, output.validPasswordStatus) {
            a, b -> Bool in
            return a && b
        }.bind { result in
            self.signInView.signInButton.isEnabled = result
            if result {
                UIView.animate(withDuration: 0.5) {
                    self.signInView.signInButton.backgroundColor = .systemIndigo
                }
            } else {
                self.signInView.signInButton.backgroundColor = .lightGray
            }
        }.disposed(by: disposeBag)
        
        output.sceneTransition
            .subscribe { _ in
                let email = self.signInView.emailTextField.text ?? ""
                let password = self.signInView.passwordTextField.text ?? ""
                
                self.viewModel.requestUserSignIn(email: email, password: password) { error in
                    if let error = error {
                        self.view.makeToast(error.rawValue)
                    } else {
                        DispatchQueue.main.async {
                            guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
                            windowScene.windows.first?.rootViewController = UINavigationController(rootViewController: PostViewController())
                            windowScene.windows.first?.makeKeyAndVisible()
                        }
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
