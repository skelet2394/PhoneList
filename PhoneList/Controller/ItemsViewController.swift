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
    var phoneKey = [String]()
    var currentList = ""
    var selectedPhone = ""
    
    @IBOutlet var phonesTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireRef = Database.database().reference()
        
        phonesTableView.register(UINib(nibName: "PhoneCell", bundle: nil) , forCellReuseIdentifier: "phoneCell")
        phonesTableView.rowHeight = 100
        
    }
    override func viewWillAppear(_ animated: Bool) {
        retrieveLists()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return phones.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "phoneCell", for: indexPath) as! CustomPhoneCell
        cell.titleLabel?.text = String(phones[indexPath.row].model + " " + phones[indexPath.row].memory + " GB " + phones[indexPath.row].color)
        cell.imeiLabel?.text = formatIMEI(imei: phones[indexPath.row].imei)
        cell.commentLabel?.text = String("Comment:   " + phones[indexPath.row].comment)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "itemDetails", sender: self)
    }
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        selectedPhone = phoneKey[indexPath.row]
        return indexPath
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        let phone = fireRef.child("Lists").child(userID!).child(currentList).child(phoneKey[indexPath.row])
        phone.removeValue { (error, reference) in
            self.retrieveLists()
        }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewPhone", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is AddItemViewController {
            let addItemVC = segue.destination as! AddItemViewController
            addItemVC.currentList = currentList
        } else if segue.destination is DetailItemViewController {
            let editItemVC = segue.destination as! DetailItemViewController
            editItemVC.configure(phone: selectedPhone, list: currentList)
        }
        
    }
    
    func formatIMEI (imei sourceIMEI: String) -> String? {
        let length = sourceIMEI.count
        var formattedIMEI = ""
        if length == 15 {
            let mask = "XX XXXXXX XXXXXX X"
            var index = sourceIMEI.startIndex
            for char in Array(mask) {
                if char == "X" {
                    formattedIMEI.append(sourceIMEI[index])
                    index = sourceIMEI.index(after: index)
                } else {
                    formattedIMEI.append(char)
                }
            }
        } else {
            formattedIMEI = sourceIMEI
            
        }
        return formattedIMEI
    }
    
    func retrieveLists () {
        
        let list = fireRef.child("Lists").child(userID!).child(currentList)
        
        list.observeSingleEvent(of: .value, with: { (snapshot) in
            
            if snapshot.childrenCount > 0 {
                
                self.phones.removeAll()
                self.phoneKey.removeAll()
                for phones in snapshot.children.allObjects as! [DataSnapshot] {
                    if phones.key != "title"{
                        let phone = Phone()
                        let phoneObject = phones.value as! [String:String]
                        phone.model = phoneObject["model"]!
                        phone.color = phoneObject["color"]!
                        phone.imei = phoneObject["imei"]!
                        phone.comment = phoneObject["comment"]!
                        phone.memory = phoneObject["memory"]!
                        self.phoneKey.append(phones.key)
                        self.phones.append(phone)
                    }
                }
                self.tableView.reloadData()
            }
            
        })
        
    }
    
}
