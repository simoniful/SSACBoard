//
//  ChangePasswordViewController.swift
//  SSAC_Board
//
//  Created by Sang hun Lee on 2022/01/06.
//

import UIKit

class ChangePasswordViewController: UIViewController {
    let changePasswordView = ChangePasswordView()
    
    override func loadView() {
        self.view = changePasswordView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "비밀번호 변경"

    }
    
}
