//
//  LoginViewController.swift
//  Shikimori
//
//  Created by Temirlan on 16.04.17.
//  Copyright © 2017 Temirlan. All rights reserved.
//

import UIKit

protocol LoginDelegate {
    func loginCompleted(with profile: Profile?)
}

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    var placeholders = ["Логин", "Пароль"]
    var delegate: LoginDelegate?
    
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
        if loginField.text!.count > 0,
            passwordField.text!.count > 0,
            !placeholders.contains(loginField.text!),
            !placeholders.contains(passwordField.text!) {
            // TODO: Login method
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
