//
//  WelcomeViewController.swift.
//  SSAC_Board
//
//  Created by Sang hun Lee on 2021/12/30.
//

import UIKit

class WelcomeViewController: UIViewController {
    let welcomeView = WelcomeView()
    
    override func loadView() {
        self.view = welcomeView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        welcomeView.signUpViewButton.addTarget(self, action: #selector(signUpViewButtonClicked), for: .touchUpInside)
        
        welcomeView.signInViewButton.addTarget(self, action: #selector(signInViewButtonClicked), for: .touchUpInside)
    }

    @objc func signUpViewButtonClicked() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func signInViewButtonClicked() {
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
}

