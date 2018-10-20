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
    
    init(mName: String, mLanguage: String, mNumber: String) {
        name = mName
        language = mLanguage
        number = mNumber
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

}
