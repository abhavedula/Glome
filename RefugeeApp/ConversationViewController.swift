//
//  ConversationViewController.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 1/14/20.
//  Copyright © 2020 Glome. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class ConversationViewController: UIViewController {

    @IBOutlet weak var nameLabel: UILabel!
    
    var myNumber = ""
    var recipientName = ""
    var recipientNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nameLabel.text = recipientName

        // Do any additional setup after loading the view.
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
