//
//  LoginViewController.swift
//  PhoneList
//
//  Created by Valery Silin on 16/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    var buttonDisabler : ButtonValidationHelper!

    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDisabler = ButtonValidationHelper(textFields: [loginTextField, passwordTextField], buttons: [loginButton])
        passwordTextField.isSecureTextEntry = true
    
    }

    @IBAction func loginButtonPressed(_ sender: UIButton) {
        Auth.auth().signIn(withEmail: loginTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Login Successful!")
                self.performSegue(withIdentifier: "goToLists", sender: self)
            }
            
        }
    }
    
    
}
