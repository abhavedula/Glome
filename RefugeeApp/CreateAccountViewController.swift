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
    
    var myNumber: String = "+123456789"
    
    var ref: DatabaseReference!
    
    @IBOutlet weak var errorField: UILabel!
    
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
        
        // add to database
        addUserToDB(number: myNumber)
        
        // segue
        self.performSegue(withIdentifier: "CreateLoginSegue", sender: (Any).self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "CreateLoginSegue") {
            let vc = ((segue.destination as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController
            vc.myNumber = myNumber
        }
    }

}
