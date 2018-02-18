//
//  Phone.swift
//  PhoneList
//
//  Created by Valery Silin on 14/02/2018.
//  Copyright © 2018 Valery Silin. All rights reserved.
//

class Phone {
    var model = ""
    var color = ""
    var memory = ""
    var imei = ""
    var comment = ""
    
    init(model: String, memory: String, color: String, imei: String, comment: String) {
        self.model = model
        self.imei = imei
        self.color = color
        self.comment = comment
        self.memory = memory
        
    }
}
