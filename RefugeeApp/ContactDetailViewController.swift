//
//  ContactDetailViewController.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 11/4/18.
//  Copyright © 2018 Glome. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class ContactDetailViewController: UIViewController {
    
    var ref: DatabaseReference!

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var langLabel: UILabel!
    @IBOutlet weak var groupsLabel: UILabel!
    
    
    var name = ""
    var number = ""
    var language = ""
    var groups : [String] = []
    
    var myNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        nameLabel.text = name
        numberLabel.text = number
        langLabel.text = language
        
        // Get groups
        getGroups()
        
        
    }
    
    func getGroups() {
        ref = Database.database().reference(withPath: "users/" + myNumber + "/contacts/" + name + "/groups")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let dict: [String:String] = rest.value! as! Dictionary
                self.groups.append(dict["name"]!)
            }
            self.groupsLabel.text = self.groups.joined(separator:", ")
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
