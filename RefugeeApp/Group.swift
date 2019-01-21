//
//  Group.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 1/21/19.
//  Copyright © 2019 Glome. All rights reserved.
//

import UIKit

class Group: NSObject {
    
    private var name: String;
    private var members: [Contact]
    
    init(mName: String) {
        name = mName
        members = []
    }
    
    func addMember(contact: Contact) {
        members.append(contact)
    }
    
    func getName() -> String {
        return name
    }
    
    func getMembers() -> [Contact] {
        return members
    }
}
