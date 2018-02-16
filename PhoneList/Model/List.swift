//
//  List.swift
//  PhoneList
//
//  Created by Valery Silin on 14/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//
import UIKit
import Firebase

class List {
    
    var title: String?
    var dateCreated: Date?
    var dateModified: Date?
    var uid: String?
    
    
    
    init(title: String, dateCreated: Date, dateModified: Date, uid: String) {
        
        self.title = title
        self.dateModified = dateModified
        self.dateCreated = dateCreated
        self.uid = uid
        
        
    }
    
    
}
