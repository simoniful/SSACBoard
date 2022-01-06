//
//  SignInView.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import UIKit
import SnapKit

class SignInView: UIView, ViewRepresentable {
    let emailTextField = InsetTextField()
    let passwordTextField = InsetTextField()
    let signInButton = UIButton()
    
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
        addSubview(passwordTextField)
        addSubview(signInButton)
        signInButton.backgroundColor = UIColor(red: 59/255, green: 195/255, blue: 113/255, alpha: 1)
        customizeTextFiled(emailTextField, "이메일 주소")
        customizeTextFiled(passwordTextField, "비밀번호")
        
        signInButton.setTitle("로그인", for: .normal)
        signInButton.setTitleColor(.white, for: .normal)
        signInButton.backgroundColor = .lightGray
        signInButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
    }
    
    func setupConstraints() {
        emailTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(super.safeAreaLayoutGuide).offset(15)
            $0.width.equalTo(super.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
        
        passwordTextField.snp.makeConstraints {
            $0.top.equalTo(emailTextField.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(self.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
        
        signInButton.snp.makeConstraints {
            $0.top.equalTo(passwordTextField.snp.bottom).offset(15)
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
