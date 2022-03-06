//
//  DetailPostView.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/03.
//

import UIKit
import SnapKit

class DetailPostView: UIView, ViewRepresentable {
    let tableView:UITableView = {
        let tableView = UITableView(frame: CGRect.zero, style: .grouped)
        tableView.register(DetailPostTableViewHeader.self, forHeaderFooterViewReuseIdentifier: DetailPostTableViewHeader.identifier)
        tableView.register(DetailPostTableViewCell.self, forCellReuseIdentifier: DetailPostTableViewCell.identifier)
        return tableView
    }()
    
    let textView : UITextView = {
        let textview = UITextView()
        textview.clipsToBounds = true
        textview.backgroundColor = .systemGray5
        textview.layer.cornerRadius = 10
        textview.autocapitalizationType = .none
        textview.isScrollEnabled = false
        return textview
    }()
    let writeStack: UIStackView = {
        let view = UIStackView()
        view.axis = .horizontal
        view.spacing = 4
        view.backgroundColor = .white
        view.distribution = .fill
        return view
    }()
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGray3
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 10
        return button
    }()
    
    let updateButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .black
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
        self.sendSubviewToBack(tableView)
        self.backgroundColor = .white
        tableView.sectionFooterHeight = 0
        tableView.backgroundColor = .white
        tableView.estimatedSectionHeaderHeight = 100
        addSubview(tableView)
        addSubview(writeStack)
        writeStack.addArrangedSubview(textView)
        writeStack.addArrangedSubview(submitButton)
    }
    
    func setupConstraints() {
        tableView.snp.makeConstraints {
            $0.top.equalTo(super.safeAreaLayoutGuide)
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview()
        }
        
        writeStack.snp.makeConstraints {
            $0.top.equalTo(tableView.snp.bottom)
            $0.leading.equalToSuperview().offset(15)
            $0.trailing.equalToSuperview().offset(-15)
            $0.height.equalTo(textView.snp.height)
            $0.bottom.equalTo(super.safeAreaLayoutGuide).offset(-15)
        }
        
        textView.snp.makeConstraints {
            $0.height.greaterThanOrEqualTo(30)
            $0.width.equalTo(super.snp.width).multipliedBy(0.85)
        }
        
        
    }
}
