//
//  CreatePostView.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import UIKit

class CreatePostView: UIView, ViewRepresentable {
    let textView = UITextView()
    
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
        addSubview(textView)
        self.backgroundColor = .white
    }
    
    func setupConstraints() {
        textView.snp.makeConstraints {
            $0.edges.equalTo(super.safeAreaLayoutGuide).inset(15)
        }
    }
}
