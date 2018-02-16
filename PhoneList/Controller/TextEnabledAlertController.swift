//
//  TextEnabledAlertController.swift
//  PhoneList
//
//  Created by Valery Silin on 15/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit

public class TextEnabledAlertController: UIAlertController {
    private var textFieldActions = [UITextField: ((UITextField)->Void)]()
    
    func addTextField(configurationHandler: ((UITextField) -> Void)? = nil, textChangeAction:((UITextField)->Void)?) {
        super.addTextField(configurationHandler: { (textField) in
            configurationHandler?(textField)
            
            if let textChangeAction = textChangeAction {
                self.textFieldActions[textField] = textChangeAction
                textField.addTarget(self, action: #selector(self.textFieldChanged), for: .editingChanged)
            }
        })
        
    }
    @objc private func textFieldChanged(sender: UITextField) {
        if let textChangeAction = textFieldActions[sender] {
            textChangeAction(sender)
        }
    }
}
