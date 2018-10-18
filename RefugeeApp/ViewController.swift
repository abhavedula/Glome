//
//  ViewController.swift
//  RefugeeApp
//
//  Created by Abha Vedula on 5/10/18.
//  Copyright © 2018 Glome. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import FirebaseDatabase

class ViewController: UIViewController {
    
    var message = ""
    var messageID = 0
    
    var recipients: [Contact] = []
    
    var ref: DatabaseReference!

    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var originalMessageField: UILabel!
    @IBOutlet weak var recipientField: UILabel!
    
    @IBAction func onAddContact(_ sender: Any) {
    }
    
    func getTranslation(lang: String) -> String {
        // iterate and save in dictionary
        // index dictionary
        var messages: [String] = []
        
        ref = Database.database().reference(withPath: "messages")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                messages.append((rest.value! as! Dictionary)[lang]!)
            }
        }
        return messages[messageID]
    }
    
    @IBAction func onPressSend(_ sender: Any) {
        let accountSID = "ACfd625c80670237064ee9dae1fc445844"
        let authToken = "d558044c31f041db628941ac481d838c"

        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        
        
        for i in 0...recipients.count-1 {
            var m: String = message
            if (recipients[i].getLanguage() == "Arabic") {
                m = getTranslation(lang: "Arabic")
                
//                ref = Database.database().reference(withPath: "messages")
//                ref.observeSingleEvent(of: .value) { snapshot in
//                    let enumerator = snapshot.children
//                    while let rest = enumerator.nextObject() as? DataSnapshot {
//                        self.messages.append((rest.value! as! Dictionary)["English"]!)
//                    }
//                }
                
//                ref = Database.database().reference(withPath: "messages")
//                m = ref.child(String(messageID)).child("Arabic").observeSingleEvent(of: .value, with: { (snapshot) in
//
//                        let dict = snapshot.value as! [String: Any]
//
//                        m = dict["Arabic"] as! String
//                    })
                
            } else if (recipients[i].getLanguage() == "French") {
                m = getTranslation(lang: "French")
            }
            let parameters = ["From": "+17344283890", "To": recipients[i].getNumber(), "Body": m]

            Alamofire.request(url, method: .post, parameters: parameters)
                .authenticate(user: accountSID, password: authToken)
                .responseString { response in
                    debugPrint(response)
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        ref = Database.database().reference(withPath: "contacts")
//        self.ref.child("Abha Vedula").setValue(["name":"Abha Vedula",
//                                                "number":"+12153754459",
//                                                "lang":"Arabic"])
//        ref = Database.database().reference(withPath: "messages")
//        self.ref.child("0").setValue(["English":"Hello! We will not have the after-school program tomorrow due to the early dismissal from school.", "Arabic":"اهلاً. لن يقام برنامج ما بعد المدرسة غداً بسبب الخروج المبكر من المدرسة"])

        
//        ref = Database.database().reference(withPath: "messages")
//        ref.observeSingleEvent(of: .value) { snapshot in
//            let enumerator = snapshot.children
//            while let rest = enumerator.nextObject() as? DataSnapshot {
//                self.Arabic[(rest.value! as! Dictionary)["English"]!] = (rest.value! as! Dictionary)["Arabic"]!
//            }
//        }

    }
    
    func updateMessageTextField() {
        messageField.text! = ""
        if (recipients.count > 0) {
            for i in 0...recipients.count-1 {
                var m = message
                if (recipients[i].getLanguage() == "Arabic") {
                    m = getTranslation(lang: "Arabic")
                } else if (recipients[i].getLanguage() == "French") {
                    m = getTranslation(lang: "French")
                }
                messageField.text!.append(m + "\n")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

