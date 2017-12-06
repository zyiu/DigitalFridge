//
//  FridgeItem.swift
//  DigitalFridge
//
//  Created by Zachary Yiu on 12/6/17.
//  Copyright © 2017 Debbie Pao. All rights reserved.
//

import Foundation

@objc class FridgeItem: NSObject {
    let name: String!
    let expiration: String!
    let dateBought: String!
    let imagePath: String!
    
    init(name: String, expiration: String, dateBought: String, imagePath: String) {
        self.name = name
        self.expiration = expiration
        self.dateBought = dateBought
        self.imagePath = imagePath
    }
}
