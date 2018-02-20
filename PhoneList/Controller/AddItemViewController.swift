//
//  AddItemViewController.swift
//  PhoneList
//
//  Created by Valery Silin on 14/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

import UIKit
import Firebase

class AddItemViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    
    var fireRef: DatabaseReference!
    let userID = Auth.auth().currentUser?.uid
    
//    var modelsArray: NSArray = ["X", "8 Plus", "8", "7 Plus","7", "6S Plus", "6S", "6 Plus", "6", "SE", "5S"]
//    var memoryArray: NSArray = ["256", "128","64", "32", "16"]
//    var colorArray: NSArray = ["Space Gray", "Gold", "Rose Gold", "Silver", "Black", "Jet Black", "Red"]

    var phones: [Phone] = [Phone]()
    let phone = Phone()

    var currentList = ""
    
    //    @IBOutlet weak var devicePicker: UIPickerView!
    @IBOutlet weak var modelPicker: UIPickerView!
    @IBOutlet weak var imeiTextField: UITextField!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        fireRef = Database.database().reference()
        

        
        modelPicker.delegate = self
        modelPicker.dataSource = self
        
        for component in [0,1,2] {
        modelPicker.selectRow(1, inComponent: component , animated: true)
        }
    }
    //    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    //        return
    //    }
    func addNewPhone(withUserID userID: String, imei: String, model: String, color: String, memory: String, comment: String) {
        let key = self.fireRef.child("Lists").child(userID).child(currentList).childByAutoId().key
        let list = ["model" : model,
                    "memory" : memory,
                    "color" : color,
                    "imei" : imei,
                    "comment" : comment]
        let childUpdates = ["/Lists/\(userID)/\(currentList)/\(key)" : list]
        fireRef.updateChildValues(childUpdates)
        
    }
    
    @IBAction func scanButtonPressed(_ sender: UIButton) {
        performSegue(withIdentifier: "scanIMEI", sender: self)
        
        
    }
    @IBAction func addPhonePressed(_ sender: UIButton) {
        if imeiTextField.text?.count != 0 {
            let imei = imeiTextField.text
            let comment = commentTextField.text
            addNewPhone(withUserID: userID!, imei: imei!, model: phone.model, color: phone.color, memory: phone.memory, comment: comment!)
            navigationController?.popViewController(animated: true)
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "IMEI cannot be empty", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true)
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 3
    }
    
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        var pickerRows = 0
        if component == 0 {
            pickerRows = phone.modelsArray.count
        }
        if component == 1 {
            pickerRows = phone.memoryArray.count
        }
        if component == 2 {
            pickerRows = phone.colorArray.count
        }
        return pickerRows
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        var rowTitle = ""
        if component == 0 {
            rowTitle = phone.modelsArray[row]
        }
        if component == 1 {
            rowTitle = phone.memoryArray[row]
        }
        if component == 2{
            rowTitle = phone.colorArray[row]
        }
        return rowTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if component == 0 {
            phone.model = phone.modelsArray[row]
        }
        if component == 1 {
            phone.memory = phone.memoryArray[row]
        }
        if component == 2{
            phone.color = phone.colorArray[row]
        }
    }
    
    
}
