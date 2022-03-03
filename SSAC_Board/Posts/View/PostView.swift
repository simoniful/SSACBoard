//
//  PostView.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/31.
//

import UIKit
import SnapKit

class PostView: UIView, ViewRepresentable {
    
    let tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: PostTableViewCell.identifier)
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    let createPostViewButton : UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemIndigo
        button.tintColor = .white
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.layer.cornerRadius = 22
        return button
    }()
    
    let changePasswordButton: UIButton = {
        let button = UIButton()
        button.tintColor = .label
        button.setImage(UIImage(systemName: "person"), for: .normal)
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
