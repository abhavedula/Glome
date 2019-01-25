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
    
    var myNumber : String!
    
    var message = ""
    var messageID = 0
    
    var translations = Dictionary<String, [String]>()
    
    var recipients: [Contact] = []
    
    var checked: [Bool] = []
    
    var ref: DatabaseReference!

    @IBOutlet weak var messageField: UILabel!
    @IBOutlet weak var originalMessageField: UILabel!
    @IBOutlet weak var recipientField: UILabel!
    @IBOutlet weak var chooseMsgButton: UIButton!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var addContactButton: UIButton!
    
    @IBAction func onAddContact(_ sender: Any) {

        let alert = UIAlertController(title: "Add Recipients", message: "Do you want to add contacts or groups", preferredStyle: .actionSheet)
       
        alert.addAction(UIAlertAction(title: "Contacts", style: .default, handler: { (action) in
            // Segue
            self.performSegue(withIdentifier: "ChooseContactSegue", sender: (Any).self)

        }))
        
        alert.addAction(UIAlertAction(title: "Groups", style: .default, handler: { (action) in
            self.performSegue(withIdentifier: "ChooseGroupSegue", sender: (Any).self)
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func getTranslation(lang: String) {
        // iterate and save in dictionary
        // index dictionary
        var msgs: [String] = []
        ref = Database.database().reference(withPath: "messages")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                var m : String = (rest.value! as! Dictionary)[lang]!
                if (self.translations[lang] != nil) {
                    self.translations[lang]!.append(m)
                } else {
                    self.translations[lang] = []
                    self.translations[lang]!.append(m)
                }
            }
        }
    }
    
    @IBAction func onPressSend(_ sender: Any) {
        let accountSID = "ACfd625c80670237064ee9dae1fc445844"
        let authToken = "d558044c31f041db628941ac481d838c"

        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        
        
        for i in 0...recipients.count-1 {
            var m: String = message
            
            m = translations[recipients[i].getLanguage()]![messageID]
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
        
        originalMessageField.layer.cornerRadius = 10
        originalMessageField.clipsToBounds = true
        messageField.layer.cornerRadius = 10
        messageField.clipsToBounds = true

        getTranslation(lang: "French")
        getTranslation(lang: "Arabic")
        sendButton.layer.cornerRadius = 5
        chooseMsgButton.layer.cornerRadius = 5
        addContactButton.layer.cornerRadius = 5
        
        ref = Database.database().reference(withPath: "users/" + myNumber + "/contacts")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.checked.append(false)
            }
        }
        
        var contactsTab = (self.tabBarController?.viewControllers![1] as! UINavigationController).viewControllers.first as! ContactsViewController
        contactsTab.myNumber = myNumber
        
        var groupsTab = (self.tabBarController?.viewControllers![2] as! UINavigationController).viewControllers.first as! GroupsViewController
        groupsTab.myNumber = myNumber
        
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func updateMessageTextField() {
        messageField.text! = ""
        if (recipients.count > 0) {
            for i in 0...recipients.count-1 {
                var m = message
                m = translations[recipients[i].getLanguage()]![messageID]
                messageField.text!.append(m + "\n")
            }
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "ChooseContactSegue") {
            let vc = segue.destination as! ContactsViewController
            vc.canSelect = true
            vc.checked = checked
            vc.myNumber = myNumber
        } else if (segue.identifier == "ChooseGroupSegue") {
            let vc = segue.destination as! GroupsViewController
            vc.canSelect = true
            vc.checked = checked
            vc.myNumber = myNumber
        }
    }


}

