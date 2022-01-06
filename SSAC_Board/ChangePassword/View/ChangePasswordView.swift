//
//  ChangePasswordView.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/06.
//

import UIKit

class ChangePasswordView: UIView, ViewRepresentable {
    let currentPasswordTextFiled = InsetTextField()
    let newPasswordTextField = InsetTextField()
    let checkPasswordTextField = InsetTextField()
    let changeButton = UIButton()
    
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
        addSubview(currentPasswordTextFiled)
        addSubview(newPasswordTextField)
        addSubview(checkPasswordTextField)
        addSubview(changeButton)
        changeButton.backgroundColor = UIColor(red: 59/255, green: 195/255, blue: 113/255, alpha: 1)
        customizeTextFiled(currentPasswordTextFiled, "현재 비밀번호")
        customizeTextFiled(newPasswordTextField, "새 비밀번호")
        customizeTextFiled(checkPasswordTextField, "새 비밀번호 확인")
        
        currentPasswordTextFiled.isSecureTextEntry = true
        newPasswordTextField.isSecureTextEntry = true
        checkPasswordTextField.isSecureTextEntry = true
        
        changeButton.setTitle("변경하기", for: .normal)
        changeButton.setTitleColor(.white, for: .normal)
        changeButton.backgroundColor = .lightGray
        changeButton.titleLabel?.font = .boldSystemFont(ofSize: 17)
    }
    
    func setupConstraints() {
        currentPasswordTextFiled.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(super.safeAreaLayoutGuide).offset(15)
            $0.width.equalTo(super.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
        
        newPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(currentPasswordTextFiled.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(super.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
        
        checkPasswordTextField.snp.makeConstraints {
            $0.top.equalTo(newPasswordTextField.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(self.snp.width).multipliedBy(0.9)
            $0.height.equalTo(45)
        }
        
        changeButton.snp.makeConstraints {
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
