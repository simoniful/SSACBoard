//
//  PostView.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/31.
//

import UIKit
import SnapKit

class PostView: UIView, ViewRepresentable {
    let tableView = UITableView()
    let createPostViewButton : UIButton = {
        let button = UIButton()
        button.clipsToBounds = true
        button.layer.cornerRadius = 35
        button.tintColor = .white
        button.backgroundColor = UIColor(red: 59/255, green: 195/255, blue: 113/255, alpha: 1)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        let pointSize: CGFloat = 32
        let imageConfig = UIImage.SymbolConfiguration(pointSize: pointSize)
        if #available(iOS 15.0, *) {
            var config = UIButton.Configuration.plain()
            config.preferredSymbolConfigurationForImage = imageConfig
            button.configuration = config
        } else {
            button.setPreferredSymbolConfiguration(imageConfig, forImageIn: .normal)
        }
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
        tableView.backgroundColor = .systemGray5
        addSubview(tableView)
        addSubview(createPostViewButton)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalTo(super.safeAreaLayoutGuide)
        }
        
        createPostViewButton.snp.makeConstraints {
            $0.height.equalTo(70)
            $0.width.equalTo(createPostViewButton.snp.height).multipliedBy(1.0 / 1.0)
            $0.bottom.equalTo(super.safeAreaLayoutGuide).offset(-25)
            $0.trailing.equalTo(super.safeAreaLayoutGuide).offset(-25)
        }
    }
}
