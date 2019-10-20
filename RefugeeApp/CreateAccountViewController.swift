//
//  CreateAccountViewController.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 1/30/19.
//  Copyright © 2019 Glome. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import CryptoSwift

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var agencyField: UITextField!
    @IBOutlet weak var confirmPwdField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    @IBOutlet weak var submitButton: UIButton!
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var errorField: UILabel!
    
    var myNumber: String = "+123456789"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        submitButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }

    func addUserToDB(number: String) {
        ref = Database.database().reference(withPath: "users")
        ref.child(number).setValue(["agency": agencyField.text,
                                    "contacts": nil,
                                    "email": emailField.text,
                                    "groups": nil,
                                    "password": pwdField.text?.sha256()])
    }
    
    func getNewNumber() {
        ref = Database.database().reference(withPath: "numbers")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            if let rest = enumerator.nextObject() as? DataSnapshot {
                let dict: [String:Any] = rest.value! as! Dictionary
                self.myNumber = dict["number"]! as! String
                self.ref.child(self.myNumber).removeValue()
                
                // add to database
                self.addUserToDB(number: self.myNumber)
                
                // segue
                self.performSegue(withIdentifier: "CreateLoginSegue", sender: (Any).self)
            }
        }
        
       
        
        
    }
    

    @IBAction func onPressSubmit(_ sender: Any) {
        // verify passwords match
        if (emailField.text!.isEmpty || agencyField.text!.isEmpty || confirmPwdField.text!.isEmpty || pwdField.text!.isEmpty) {
            errorField.text = "Please fill out all fields."
            return
        }
        if (pwdField.text != confirmPwdField.text) {
            errorField.text = "Passwords do not match."
            return
        }
        // get phone number from twilio
        getNewNumber()

        
        
    }
    

}
