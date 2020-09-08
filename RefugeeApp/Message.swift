//
//  Message.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 9/7/20.
//  Copyright © 2020 Glome. All rights reserved.
//

import UIKit

class Message: NSObject {
    private var body: String;
    private var date: String
    private var isSender: Bool
    
    init(mBody: String, mDate: String, mIsSender: Bool) {
        body = mBody
        date = mDate
        isSender = mIsSender
    }
    
    func getBody() -> String {
        return body
    }
    
    func getDate() -> String {
        return date
    }
    
    func getIsSender() -> Bool {
        return isSender
    }
    
}
