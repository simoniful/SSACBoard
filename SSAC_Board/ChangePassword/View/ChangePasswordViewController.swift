//
//  ChangePasswordViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/06.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    let changePasswordView = ChangePasswordView()
    let viewModel = ChangePasswordViewModel()
    var btnActionHandler: (() -> ())?
    
    override func loadView() {
        self.view = changePasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "비밀번호 변경"

        viewModel.currentPassword.bind { text in
            self.changePasswordView.currentPasswordTextFiled.text = text
        }
        
        viewModel.newPassword.bind { text in
            self.changePasswordView.newPasswordTextField.text = text
        }
        
        viewModel.checkPassword.bind { text in
            self.changePasswordView.checkPasswordTextField.text = text
        }
        
        changePasswordView.currentPasswordTextFiled.addTarget(self, action: #selector(currentPasswordTextFiledDidChange(_:)), for: .editingChanged)
        
        changePasswordView.newPasswordTextField.addTarget(self, action: #selector(newPasswordTextFieldDidChange(_:)), for: .editingChanged)
        
        changePasswordView.checkPasswordTextField.addTarget(self, action: #selector(checkPasswordTextFieldDidChange(_:)), for: .editingChanged)
        
        changePasswordView.changeButton.addTarget(self, action: #selector(changeButtonClicked), for: .touchUpInside)
        
    }
    
    @objc func currentPasswordTextFiledDidChange(_ textfield: UITextField) {
        viewModel.currentPassword.value = textfield.text ?? ""
    }
    
    @objc func newPasswordTextFieldDidChange(_ textfield: UITextField) {
        viewModel.newPassword.value = textfield.text ?? ""
    }
    
    @objc func checkPasswordTextFieldDidChange(_ textfield: UITextField) {
        viewModel.checkPassword.value = textfield.text ?? ""
    }
    
    @objc func changeButtonClicked() {
        viewModel.requestChangeUserPassword {
            guard let btnActionHandler = self.btnActionHandler else { return }
            btnActionHandler()
            self.navigationController?.popViewController(animated: true)
        }
    }
}
