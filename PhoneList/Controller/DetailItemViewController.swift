//
//  DetailItemViewController.swift
//  PhoneList
//
//  Created by Valery Silin on 14/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import Firebase

class DetailItemViewController: UITableViewController {
    
    var fireRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    var currentList = ""
    var currentPhone = ""
    var comment = ""
    
    @IBOutlet weak var editTextField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireRef = Database.database().reference()
        getComment()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
    }
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        updateComment()
        navigationController?.popViewController(animated: true)
        dismiss(animated: true, completion: nil)

    }
    
    func configure(phone currentPhone: String, list currentList: String) {
        if self.currentList.isEmpty { self.currentList = currentList }
        if self.currentPhone.isEmpty { self.currentPhone = currentPhone }
        
    }
    
    func getComment() {
        let phone = fireRef.child("Lists").child(userID!).child(currentList).child(currentPhone)
        phone.observeSingleEvent(of: .value) { (snapshot) in
            for item in snapshot.children.allObjects as! [DataSnapshot] {
                if item.key == "comment" {
//                    var comm = ""
                    self.comment = item.value.unsafelyUnwrapped as! String
//                    self.comment = comm["comment"]!
                    
                    self.editTextField.text = self.comment
                }
            }
        }
    }
    func updateComment() {
        let phone = fireRef.child("Lists").child(userID!).child(currentList).child(currentPhone)
        let comment = ["comment" : editTextField.text!]
        phone.updateChildValues(comment)
    }
}

