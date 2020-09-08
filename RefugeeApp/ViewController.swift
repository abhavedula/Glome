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
    
    var recipientsContacts: [Contact] = []
    var recipientsGroups: [Contact] = []
    
    var checkedContacts: [Bool] = []
    var checkedGroups: [Bool] = []
    
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
                var m : String? = (rest.value! as! Dictionary)[lang]
                if (m != nil) {
                    if (self.translations[lang] != nil) {
                        self.translations[lang]!.append(m!)
                    } else {
                        self.translations[lang] = []
                        self.translations[lang]!.append(m!)
                    }
                }
            }
        }
    }
    
    @IBAction func onPressSend(_ sender: Any) {
        let accountSID = "ACfd625c80670237064ee9dae1fc445844"
        let authToken = "1a9254dd1c1b2fc645eda19e37b7720b"

        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
        
        // TODO: change from phone number
        if (recipientsContacts.count > 0) {
            for i in 0...recipientsContacts.count-1 {
                var m: String = message
                
                m = translations[recipientsContacts[i].getLanguage()]![messageID]
                m = m + "\n" + translations["English"]![messageID]
                let parameters = ["From": "+12159996310", "To": recipientsContacts[i].getNumber(), "Body": m]

                Alamofire.request(url, method: .post, parameters: parameters)
                    .authenticate(user: accountSID, password: authToken)
                    .responseString { response in
                        debugPrint(response)
                }
            }
        }
        
        if (recipientsGroups.count > 0) {
            for i in 0...recipientsGroups.count-1 {
                var m: String = message
                
                m = translations[recipientsContacts[i].getLanguage()]![messageID]
                m = m + "\n" + translations["English"]![messageID]
                let parameters = ["From": "+12063509104", "To": recipientsGroups[i].getNumber(), "Body": m]
                
                Alamofire.request(url, method: .post, parameters: parameters)
                    .authenticate(user: accountSID, password: authToken)
                    .responseString { response in
                        debugPrint(response)
                }
            }
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        originalMessageField.layer.cornerRadius = 10
        originalMessageField.clipsToBounds = true
        messageField.layer.cornerRadius = 10
        messageField.clipsToBounds = true

        let langs = Language.allCases
        for lang in langs {
            getTranslation(lang: lang.rawValue)
        }
        sendButton.layer.cornerRadius = 5
        chooseMsgButton.layer.cornerRadius = 5
        addContactButton.layer.cornerRadius = 5
        
        ref = Database.database().reference(withPath: "users/" + myNumber + "/contacts")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.checkedContacts.append(false)
            }
        }
        
        ref = Database.database().reference(withPath: "users/" + myNumber + "/groups")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.checkedGroups.append(false)
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
        if (recipientsContacts.count > 0) {
            for i in 0...recipientsContacts.count-1 {
                var m = message
                m = translations[recipientsContacts[i].getLanguage()]![messageID]
                messageField.text!.append(m + "\n")
            }
        }
        
        if (recipientsGroups.count > 0) {
            for i in 0...recipientsGroups.count-1 {
                var m = message
                m = translations[recipientsGroups[i].getLanguage()]![messageID]
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
            vc.checked = checkedContacts
            vc.myNumber = myNumber
        } else if (segue.identifier == "ChooseGroupSegue") {
            let vc = segue.destination as! GroupsViewController
            vc.canSelect = true
            vc.checked = checkedGroups
            vc.myNumber = myNumber
        }
    }


}

