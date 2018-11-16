//
//  Contact.swift
//  RefugeeApp
//
//  Created by Abha Vedula on 10/12/18.
//  Copyright © 2018 Glome. All rights reserved.
//

import UIKit

class Contact: NSObject {
    
    private var name: String;
    private var language: String
    private var number: String
    private var groupIDs: [Int]
    
    init(mName: String, mLanguage: String, mNumber: String) {
        name = mName
        language = mLanguage
        number = mNumber
        groupIDs = []
    }
    
    func addToGroup(groupID: Int) {
        groupIDs.append(groupID)
    }
    
    func getName() -> String {
        return name
    }
    
    func getLanguage() -> String {
        return language
    }
    
    func getNumber() -> String {
        return number
    }
    
    func getGroupIDs() -> [Int] {
        return groupIDs
    }
    
    
    

}
