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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }

    @objc func signUpViewButtonClicked() {
        self.navigationController?.pushViewController(SignUpViewController(), animated: true)
    }
    
    @objc func signInViewButtonClicked() {
        self.navigationController?.pushViewController(SignInViewController(), animated: true)
    }
}

