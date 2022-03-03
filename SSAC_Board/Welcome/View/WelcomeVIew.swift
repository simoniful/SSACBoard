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
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "SSACLogo")
        return imageView
    }()
    
    
    let titleLabel : UILabel = {
        let label = UILabel()
        label.text = "주위의 게시판"
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 17)
        return label
    }()
    
    let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "좋은 사람들과 즐거운 커뮤니티를 구성해보세요!"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        label.numberOfLines = 2
        label.textAlignment = .center
        return label
    }()
    
    let signUpViewButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemIndigo
        button.setTitleColor(.white, for: .normal)
        button.setTitle("시작하기", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    
    let horizontalStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.backgroundColor = .white
        view.distribution = .equalSpacing
        return view
    }()
    
    let guideLabel: UILabel = {
        let label = UILabel()
        label.text = "이미 계정이 있나요?"
        label.font = .systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()
    
    let signInViewButton: UIButton = {
        let button = UIButton()
        button.setTitle("로그인", for: .normal)
        button.setTitleColor(.systemIndigo, for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 14)
        return button
    }()
    
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
        verticalStack.addArrangedSubview(logoImageView)
        verticalStack.addArrangedSubview(titleLabel)
        verticalStack.addArrangedSubview(subtitleLabel)
        addSubview(signUpViewButton)
        addSubview(horizontalStack)
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
