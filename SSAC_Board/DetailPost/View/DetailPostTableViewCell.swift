//
//  DetailPostTableViewCell.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/04.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class DetailPostTableViewCell: UITableViewCell, ViewRepresentable {
    static let identifier = "DetailPostTableViewCell"
    var updateButtonAction: (() -> ()) = {}
    
    let nickNameLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 15)
        return label
    }()
    
    let contentLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 15)
        label.numberOfLines = 0
        return label
    }()
    
    let updateButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "ellipsis"), for: .normal)
        button.tintColor = .gray
        return button
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.isUserInteractionEnabled = true
        selectionStyle = .none
        setupView()
        setupConstraints()
        updateButton.addTarget(self, action: #selector(updateButtonClicked), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
        setupConstraints()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @objc func updateButtonClicked(){
        updateButtonAction()
    }
    
    func setupView() {
        addSubview(nickNameLabel)
        addSubview(contentLabel)
        addSubview(updateButton)
    }
    
    func setupConstraints() {
        nickNameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.leading.equalTo(15)
            $0.trailing.equalTo(-15)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(nickNameLabel.snp.bottom).offset(5)
            $0.leading.equalTo(15)
            $0.trailing.equalTo(updateButton.snp.leading).offset(-10)
            $0.bottom.equalToSuperview().offset(-15)
        }
        
        updateButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(-15)
            $0.width.equalTo(25)
            $0.height.equalTo(25)
        }
    }
}
