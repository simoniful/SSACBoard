//
//  DetailPostTableViewHeader.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/04.
//

import UIKit

class DetailPostTableViewHeader: UITableViewHeaderFooterView, ViewRepresentable {
    static let identifier = "DetailPostTableViewHeader"
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupView()
        setupConstraints()
    }
        
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }
    
    let infoStack: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.spacing = 2
        view.backgroundColor = .white
        view.distribution = .fill
        return view
    }()
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: 13)
        return label
    }()
    
    let profileStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.backgroundColor = .white
        view.distribution = .fill
        return view
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.fill")
        imageView.backgroundColor = .systemGray5
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17)
        label.numberOfLines = 0
        return label
    }()
    
    let commentStack: UIStackView = {
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
    
    let commentCountLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .gray
        return label
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {
        addSubview(profileImageView)
        addSubview(infoStack)
        infoStack.addArrangedSubview(nickNameLabel)
        infoStack.addArrangedSubview(dateLabel)
        addSubview(contentLabel)
        addSubview(commentStack)
        commentStack.addArrangedSubview(iconImage)
        commentStack.addArrangedSubview(commentCountLabel)
    }
    
    func setupConstraints() {
        profileImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(0)
            $0.width.equalTo(44)
            $0.height.equalTo(44)
        }
        
        infoStack.snp.makeConstraints {
            $0.centerY.equalTo(profileImageView)
            $0.leading.equalTo(profileImageView.snp.trailing).offset(10)
            $0.trailing.equalTo(0)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.bottom).offset(15)
            $0.leading.equalTo(0)
            $0.trailing.equalTo(0)
           
        }

        contentLabel.setContentHuggingPriority(.defaultLow, for: .vertical)
    
        commentStack.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(15)
            $0.leading.equalTo(0)
            $0.trailing.equalTo(0)
            $0.height.equalTo(15)
            $0.bottom.equalToSuperview().offset(-15)
        }

        iconImage.snp.makeConstraints {
            $0.width.equalTo(commentStack.snp.height)
        }
    }


}
