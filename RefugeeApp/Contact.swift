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
    private var groups: [Group]
    
    init(mName: String, mLanguage: String, mNumber: String) {
        name = mName
        language = mLanguage
        number = mNumber
        groups = []
    }
    
    func addToGroup(group: Group) {
        groups.append(group)
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
    
    func getGroups() -> [Group] {
        return groups
    }
    
    
    

}
