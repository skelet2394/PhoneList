//
//  ListsViewController.swift
//  PhoneList
//
//  Created by Valery Silin on 14/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import Firebase

class ListsViewController: UITableViewController {
    
    var lists = [List]()
    
    var fireRef: DatabaseReference!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fireRef = Database.database().reference()
        navigationItem.hidesBackButton = true
    }
    // MARK: - TableView Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        cell.textLabel?.text = lists[indexPath.row].title
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = TextEnabledAlertController(title: "Add new list", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in    }
        let addList = UIAlertAction(title: "Add List", style: .default) { (action) in
//            let userID = Auth.auth().currentUser?.uid
            let userID = "asshole"
            let listTitle = alertTextField.text
            let listCreated = Date()
            self.addNewList(withUserID: userID, title: listTitle!)
            
        }
        
        addList.isEnabled = false
        alert.addAction(addList)
        alert.addAction(cancelAction)
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "Name of list"
        }) { (textField) in
            addList.isEnabled = textField.text?.count != 0
            alertTextField = textField
        }
        present(alert, animated: true, completion: nil)
    }
    
    func addNewList(withUserID userID: String, title: String  ) {
        
        let key = self.fireRef.child("lists").childByAutoId().key
        let list = ["uid" : userID,
                    "title" : title]
        let childUpdates = ["/lists/\(key)" : list]
        fireRef.updateChildValues(childUpdates)

    }
}

