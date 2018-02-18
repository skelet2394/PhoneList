//
//  WelcomeViewController.swift
//  PhoneList
//
//  Created by Valery Silin on 16/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import Firebase

class WelcomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
 
    
    }
    override func viewWillAppear(_ animated: Bool) {
        //MARK: - ENABLE/DISABLE AUTOLOGIN HERE:
        Auth.auth().currentUser != nil ? performSegue(withIdentifier: "goToLists", sender: self) : nil
        
    }
}
