//
//  UpdateView.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/05.
//

import UIKit

class UpdateView: UIView, ViewRepresentable {
    let textView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        textView.keyboardDismissMode = .interactive
        return textView
    }()
    
    let doneButton: UIButton = {
        let button = UIButton()
        button.setTitleColor(.black, for: .normal)
        button.setTitle("완료", for: .normal)
        return button
    }()
    
    let backButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        button.tintColor = .black
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
        addSubview(textView)
        self.backgroundColor = .white
    }
    
    func setupConstraints() {
        textView.snp.makeConstraints {
            $0.edges.equalTo(super.safeAreaLayoutGuide).inset(15)
        }
    }
}
