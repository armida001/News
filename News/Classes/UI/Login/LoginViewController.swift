//
//  LoginViewController.swift
//  News
//
//  Created by 1 on 30.11.2020.
//

import UIKit

class LoginViewController: LoginBaseViewController {    
    
    @IBAction func loginClick(_ sender: Any) {
        self.coordinator?.completion?()
    }
        
    @IBAction func registrationClick(_ sender: Any) {
        coordinator?.showRegistration()
    }
    
    @IBAction func forgotPasswordClick(_ sender: Any) {
        coordinator?.showRestore()
    }
}
