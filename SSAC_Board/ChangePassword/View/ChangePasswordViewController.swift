//
//  ChangePasswordViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/06.
//

import UIKit
import RxSwift
import RxCocoa

class ChangePasswordViewController: UIViewController {
    let disposeBag = DisposeBag()
    let changePasswordView = ChangePasswordView()
    let viewModel = ChangePasswordViewModel()
    var btnActionHandler: (() -> ())?
    
    override func loadView() {
        self.view = changePasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "비밀번호 변경"
        bind()
    }
    
    func bind() {
        let input = ChangePasswordViewModel.Input(currentPassword: changePasswordView.currentPasswordTextFiled.rx.text, passwordToChange: changePasswordView.newPasswordTextField.rx.text, checkPasswordToChange: changePasswordView.checkPasswordTextField.rx.text, tap: changePasswordView.changeButton.rx.tap)
        let output = viewModel.transform(input: input)
        
        Observable.combineLatest(output.validCurrentPasswordStatus, output.validPasswordToChange, output.validCheckPasswordToChange) {
            a, b, c -> Bool in
            return a && b && c
        }.bind { result in
            self.changePasswordView.changeButton.isEnabled = result
            if result {
                UIView.animate(withDuration: 0.5) {
                    self.changePasswordView.changeButton.backgroundColor = .systemIndigo
                }
            } else {
                self.changePasswordView.changeButton.backgroundColor = .lightGray
            }
        }.disposed(by: disposeBag)
        
        output.sceneTransition
            .subscribe { [weak self] _ in
                guard let self = self else { return }
                self.viewModel.requestChangeUserPassword(
                    currentPassword: self.changePasswordView.currentPasswordTextFiled.text!,
                    newPassword: self.changePasswordView.newPasswordTextField.text!,
                    checkPassword: self.changePasswordView.checkPasswordTextField.text!,
                    completion: { [weak self] (error) in
                        guard let btnActionHandler = self?.btnActionHandler else { return }
                        btnActionHandler()
                        self?.navigationController?.popViewController(animated: true)
                })
            }
            .disposed(by: disposeBag)
    }
}
