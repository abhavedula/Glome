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
    var translations: [String] = []
    var languages: [String] = []
    var recipientNames: [String] = []
    var recipientNums: [String] = []
    
    var Arabic: Dictionary<String, String> = [:]
    
    var ref: DatabaseReference!

    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var originalMessageField: UILabel!
    @IBOutlet weak var recipientField: UILabel!
    
    @IBAction func onAddContact(_ sender: Any) {
    }
    
    @IBAction func onPressSend(_ sender: Any) {
        let accountSID = "ACfd625c80670237064ee9dae1fc445844"
        let authToken = "d558044c31f041db628941ac481d838c"

        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        
        
        for i in 0...recipientNames.count-1 {
            var m: String = message
            if (languages[i] == "Arabic") {
                m = Arabic[message]!
            }
            let parameters = ["From": "+17344283890", "To": recipientNums[i], "Body": m]

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
        ref = Database.database().reference(withPath: "contacts")
//        self.ref.child("Abha Vedula").setValue(["name":"Abha Vedula",
//                                                "number":"+12153754459",
//                                                "lang":"Arabic"])
//        self.ref.child("Sonali Dane").setValue(["name":"Sonali Dane",
//                                                "number":"+12153754459",
//                                                "lang":"Urdu"])
//
//        ref = Database.database().reference(withPath: "messages")
//        self.ref.child("0").setValue(["English":"Hello! We will not have the after-school program tomorrow due to the early dismissal from school.", "Arabic":"اهلاً. لن يقام برنامج ما بعد المدرسة غداً بسبب الخروج المبكر من المدرسة"])
//        self.ref.child("1").setValue(["English":"Hello! We will not have the after-school program tomorrow because there is no school.", "Arabic":"اهلاً. لن يقام برنامج ما بعد المدرسة غداً بسبب العطلة من المدرسة غداً"])
        for recip in recipientNames {
            recipientField.text?.append(recip)
        }
        
        ref = Database.database().reference(withPath: "messages")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.Arabic[(rest.value! as! Dictionary)["English"]!] = (rest.value! as! Dictionary)["Arabic"]!
            }
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

