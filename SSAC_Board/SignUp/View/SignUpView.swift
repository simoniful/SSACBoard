//
//  SignUpView.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import UIKit
import SnapKit

class SignUpView: UIView, ViewRepresentable {
    let emailTextField = InsetTextField()
    let nicknameTextFiled = InsetTextField()
    let passwordTextField = InsetTextField()
    let checkPasswordTextField = InsetTextField()
    let signUpButton = UIButton()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
        setupConstraints()
    }
    
    func setupView() {
        self.backgroundColor = .white
        addSubview(emailTextField)
        addSubview(nicknameTextFiled)
        addSubview(passwordTextField)
        addSubview(checkPasswordTextField)
        addSubview(signUpButton)
        signUpButton.backgroundColor = UIColor(red: 59/255, green: 195/255, blue: 113/255, alpha: 1)
        customizeTextFiled(emailTextField, "이메일 주소")
        customizeTextFiled(nicknameTextFiled, "닉네임")
        customizeTextFiled(passwordTextField, "비밀번호")
        customizeTextFiled(checkPasswordTextField, "비밀번호 확인")
        
        signUpButton.setTitle("회원가입", for: .normal)
        signUpButton.setTitleColor(.white, for: .normal)
        signUpButton.backgroundColor = .lightGray
        signUpButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
    }
    
    func setupConstraints() {
        emailTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(super.safeAreaLayoutGuide).offset(15)
            $0.width.equalTo(super.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
        
        nicknameTextFiled.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(super.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(nicknameTextFiled.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(self.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
        
        checkPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(self.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
        
        signUpButton.snp.makeConstraints {
            $0.top.equalTo(checkPasswordTextField.snp.bottom).offset(15)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(self.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
    }
    
    func customizeTextFiled(_ textField:UITextField, _ placeholderText: String) {
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 0.5
        textField.attributedPlaceholder = NSAttributedString(string: placeholderText, attributes: [.foregroundColor: UIColor.systemGray])
        textField.clearButtonMode = .whileEditing
    }
}
