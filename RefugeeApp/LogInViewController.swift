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

class LogInViewController: UIViewController {

    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var pwdField: UITextField!
    
    var ref: DatabaseReference!
    
    var pwdMatch: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
                if (rest.key == self.numberField.text) {
                    let dict: [String:Any] = rest.value! as! Dictionary
                    var pwd: String
                    pwd = dict["password"]! as! String
                    self.pwdMatch = pwd == self.pwdField.text
                    if (self.pwdMatch) {
                        self.performSegue(withIdentifier: "LogInSegue", sender: (Any).self)
                        break
                    }
                }
              
            }
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        return pwdMatch
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "LogInSegue") {
            let vc = ((segue.destination as! UITabBarController).viewControllers![0] as! UINavigationController).viewControllers.first as! ViewController
            vc.myNumber = numberField.text
        }
    }
}
