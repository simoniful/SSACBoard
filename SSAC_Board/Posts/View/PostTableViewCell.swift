//
//  PostTableViewCell.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/02.
//

import UIKit
import SnapKit

class PostTableViewCell: UITableViewCell, ViewRepresentable  {
    static let identifier = "PostTableViewCell"

    let verticalStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 4
        view.backgroundColor = .white
        view.distribution = .equalSpacing
        return view
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.backgroundColor = .systemGray5
        label.textColor = .gray
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    let createDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12)
        label.textColor = .gray
        return label
    }()
    
    let horizontalStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.backgroundColor = .white
        view.distribution = .fill
        return view
    }()
    
    let iconImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "bubble.right")
        imageView.tintColor = .gray
        return imageView
    }()
    
    let commentCountLabel : UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func setupView() {
        contentView.addSubview(nickNameLabel)
        contentView.addSubview(contentLabel)
        contentView.addSubview(createDateLabel)
        contentView.addSubview(horizontalStack)
        horizontalStack.addArrangedSubview(iconImage)
        horizontalStack.addArrangedSubview(commentCountLabel)
    }
    
    func setupConstraints() {
        nickNameLabel.snp.makeConstraints {
            $0.top.equalTo(contentView.snp.top).offset(15)
            $0.leading.equalTo(15)
            $0.height.equalTo(15)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(15)
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
        }
        
        contentLabel.setContentHuggingPriority(UILayoutPriority(rawValue: 249), for: .vertical)
        
        createDateLabel.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(15)
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
        }
        
        horizontalStack.snp.makeConstraints {
            $0.top.equalTo(createDateLabel.snp.bottom).offset(15)
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
            $0.height.equalTo(15)
            $0.bottom.equalTo(contentView.snp.bottom).offset(-15)
        }
        
        iconImage.snp.makeConstraints {
            $0.width.equalTo(horizontalStack.snp.height)
            $0.height.equalTo(iconImage.snp.width).multipliedBy(1.0 / 1.0)
        }
    }
}
