//
//  LogInViewController.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 1/7/19.
//  Copyright © 2019 Glome. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import CryptoSwift

class LogInViewController: UIViewController {

    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    var ref: DatabaseReference!
    
    var pwdMatch: Bool = false
    var myNumber: String = ""
    
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBOutlet weak var errorField: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginButton.layer.cornerRadius = 5
        createAccountButton.layer.cornerRadius = 5

        
        // Do any additional setup after loading the view.
    }
        
    @IBAction func onLogInPressed(_ sender: Any) {
        verifyPassword()
    }
    
    func verifyPassword() {
        ref = Database.database().reference(withPath: "users")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let dict: [String:Any] = rest.value! as! Dictionary
                if (dict["email"] as! String == self.emailField.text) {
                    var pwd: String
                    pwd = dict["password"]! as! String
                    self.pwdMatch = pwd == self.pwdField.text!.sha256()
                    if (self.pwdMatch) {
                        self.myNumber = rest.key
                        self.performSegue(withIdentifier: "LogInSegue", sender: (Any).self)
                        break
                    } else {
                        self.errorField.text = "Incorrect email or password."
                    }
                }
              
            }
        }
    }
    
    @IBAction func onCreatePressed(_ sender: Any) {
        self.performSegue(withIdentifier: "CreateAccountSegue", sender: (Any).self)
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return pwdMatch
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LogInSegue") {
            let vc = ((segue.destination as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController
            vc.myNumber = myNumber
        }
    }
}
