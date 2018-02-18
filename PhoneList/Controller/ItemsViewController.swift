//
//  ItemsViewController.swift
//  PhoneList
//
//  Created by Valery Silin on 14/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import Firebase

class ItemsViewController: UITableViewController {
    
    var fireRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
    var phones: [Phone] = [Phone]()
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fireRef = Database.database().reference()
    }
    override func viewWillAppear(_ animated: Bool) {
        retrieveLists()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhoneCell", for: indexPath)
        cell.textLabel?.text = phones[indexPath.row].model
        return cell
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewPhone", sender: self)
    }
    
    func retrieveLists () {
        
        let listsDB = Database.database().reference().child("Phones").child(userID!)
        
        listsDB.observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.childrenCount > 0 {
                self.phones.removeAll()
                for phones in snapshot.children.allObjects as! [DataSnapshot] {
                    let phoneObject = phones.value as? [String:AnyObject]
                    let phoneModel = phoneObject?["model"]
                    let phoneColor = phoneObject?["color"]
                    let phoneIMEI = phoneObject?["imei"]
                    let phoneComment = phoneObject?["comment"]
                    let phoneMemory = phoneObject?["memory"]
                    
                    
                    let phone = Phone(model: phoneModel as! String, memory: phoneMemory as! String, color: phoneColor as! String, imei: phoneIMEI as! String, comment: phoneComment as! String)
                    self.phones.append(phone)
                }
                self.tableView.reloadData()
            }
            
        })
        
    }
    
}
