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
    
    
    var fireRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    var lists : [List] = [List]()
    var listKey = [String]()
    var selectedList = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fireRef = Database.database().reference()
        navigationItem.hidesBackButton = true
        //        Database.database().isPersistenceEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        retrieveLists()
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
        
        cell.textLabel?.text = self.lists.reversed()[indexPath.row].title
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let list = lists[indexPath.row]
        performSegue(withIdentifier: "goToList", sender: list)
    
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedList = listKey.reversed()[indexPath.row]
        return indexPath
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let path = fireRef.child("Lists").child(userID!).child(listKey.reversed()[indexPath.row])
        path.removeValue { (error, reference) in
            self.retrieveLists()
        }
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        var alertTextField = UITextField()
        let alert = TextEnabledAlertController(title: "Add new list", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in    }
        let addList = UIAlertAction(title: "Add List", style: .default) { (action) in
            let listTitle = alertTextField.text
            let listCreated = "\(Date())"
            self.addNewList(withTitle: listTitle!, userID: self.userID!, dateCreated: listCreated)
            
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
    
    func addNewList(withTitle title: String, userID: String, dateCreated: String) {
        
        let key = fireRef.child("Lists").child(userID).childByAutoId().key
        let list = ["title" : title]
        let childUpdates = ["/Lists/\(userID)/\(key)" : list]
        fireRef.updateChildValues(childUpdates)
        retrieveLists()
    }
    
    func retrieveLists () {
        let listsDB = fireRef.child("Lists").child(userID!)
        
        
        listsDB.observeSingleEvent(of: .value, with: { (snapshot) in
            self.lists.removeAll()
            if snapshot.hasChildren() {
                for lists in snapshot.children.allObjects as! [DataSnapshot] {
                    let listObject = lists.value as? [String:AnyObject]
                    let listTitle = listObject?["title"]
                    let listKey = lists.key
                    let list = List(title: listTitle as! String)
                    self.lists.append(list)
                    self.listKey.append(listKey)
                }
            }
            self.tableView.reloadData()
        })

    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is ItemsViewController {
            let itemsVC = segue.destination as? ItemsViewController
            
            itemsVC?.currentList = selectedList
            
        }
        
    }
}

