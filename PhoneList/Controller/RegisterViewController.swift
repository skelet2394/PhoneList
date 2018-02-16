//
//  RegisterViewController.swift
//  PhoneList
//
//  Created by Valery Silin on 16/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {
    
    var buttonDisabler : ButtonValidationHelper!

    @IBOutlet weak var loginTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var registerButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        buttonDisabler = ButtonValidationHelper(textFields: [loginTextField, passwordTextField], buttons: [registerButton])
        passwordTextField.isSecureTextEntry = true
    }
    @IBAction func registerButtonPressed(_ sender: UIButton) {
        
        Auth.auth().createUser(withEmail: loginTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil {
                print(error!)
            } else {
                print("Registration Successful!")
                self.performSegue(withIdentifier: "goToLists", sender: self)
            }
            
        }
    }
}
