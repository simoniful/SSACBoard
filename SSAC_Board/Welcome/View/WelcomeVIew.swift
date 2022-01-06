//
//  WelcomeVIew.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import UIKit
import SnapKit

protocol ViewRepresentable {
    func setupView()
    func setupConstraints()
}

class WelcomeView: UIView, ViewRepresentable {
    let verticalStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 8
        view.backgroundColor = .white
        view.distribution = .equalSpacing
        return view
    }()
    
    let logoImageView = UIImageView()
    let titleLabel = UILabel()
    let subtitleLabel = UILabel()
    
    let signUpViewButton = UIButton()
    
    let horizontalStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.backgroundColor = .white
        view.distribution = .equalSpacing
        return view
    }()
    let guideLabel = UILabel()
    let signInViewButton = UIButton()
    
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
        addSubview(verticalStack)
        verticalStack.backgroundColor = .white
        logoImageView.image = UIImage(named: "SSACLogo")
        titleLabel.text = "당신 근처의 새싹농장"
        titleLabel.textAlignment = .center
        titleLabel.font = .boldSystemFont(ofSize: 17)
        subtitleLabel.text = "iOS 지식부터 바람의 나라까지\n지금 SeSac에서 함께해보세요!"
        subtitleLabel.font = .systemFont(ofSize: 13)
        subtitleLabel.textColor = .gray
        subtitleLabel.numberOfLines = 2
        subtitleLabel.textAlignment = .center
        verticalStack.addArrangedSubview(logoImageView)
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(subtitleLabel)
        
        addSubview(signUpViewButton)
        signUpViewButton.backgroundColor = UIColor(red: 59/255, green: 195/255, blue: 113/255, alpha: 1)
        signUpViewButton.setTitleColor(.white, for: .normal)
        signUpViewButton.setTitle("시작하기", for: .normal)
        signUpViewButton.titleLabel?.font = .boldSystemFont(ofSize: 18)
        
        addSubview(horizontalStack)
        guideLabel.text = "이미 계정이 있나요?"
        guideLabel.font = .systemFont(ofSize: 14)
        guideLabel.textColor = .lightGray
        signInViewButton.setTitle("로그인", for: .normal)
        signInViewButton.setTitleColor(UIColor(red: 59/255, green: 195/255, blue: 113/255, alpha: 1), for: .normal)
        signInViewButton.titleLabel?.font = .boldSystemFont(ofSize: 14)
        horizontalStack.addArrangedSubview(guideLabel)
        horizontalStack.addArrangedSubview(signInViewButton)
    }
    
    func setupConstraints() {
        logoImageView.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(logoImageView.snp.width).multipliedBy(1.0 / 1.0)

        }
        
        verticalStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview().offset(-50)
            $0.width.equalTo(self.snp.width).multipliedBy(0.5)
            $0.height.lessThanOrEqualTo(self.snp.height).multipliedBy(0.5)
        }
        
        signUpViewButton.snp.makeConstraints {
            $0.width.equalTo(self.safeAreaLayoutGuide).multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(50)
            $0.bottom.equalTo(horizontalStack.snp.top).offset(-10)
        }
        
        horizontalStack.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(self.safeAreaLayoutGuide)
            $0.height.equalTo(44)
        }
    }
}
