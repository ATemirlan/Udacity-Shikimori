//
//  LoginViewController.swift
//  Shikimori
//
//  Created by Temirlan on 16.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var placeholders = ["Логин", "Пароль"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupStatusBar()
    }
    
    func setupStatusBar() {
        let barView = UIView(frame: CGRect(x:0, y:0, width:view.frame.width, height:UIApplication.shared.statusBarFrame.height))
        barView.backgroundColor = Constants.SystemColor.navBarColor
        view.addSubview(barView)
    }
    
    @IBAction func login(_ sender: UIButton) {
        if loginField.text!.characters.count > 0,
            passwordField.text!.characters.count > 0,
            !placeholders.contains(loginField.text!),
            !placeholders.contains(passwordField.text!) {
            
            RequestEngine.shared.login(nickname: loginField.text!, password: passwordField.text!, completion: { (code) in
                if code == 200 {
                    RequestEngine.shared.whoami { (profile) in
                        if let _ = profile {
                            User.current.id = "\(profile!.id!)"
                            User.current.nickname = profile!.nickname!
                            User.current.avatarUrl = "\(profile!.avatarUrl!)"
                            self.dismiss(animated: true, completion: nil)
                        }
                    }
                }
            })
        }
    }
    
    @IBAction func hideKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if placeholders.contains(textField.text!) {
            textField.text = ""
        }
        
        if textField == passwordField {
            passwordField.isSecureTextEntry = true
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField.text! == "" {
            textField.text = placeholders[textField.tag]
            
            if textField == passwordField {
                passwordField.isSecureTextEntry = false
            }
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
}