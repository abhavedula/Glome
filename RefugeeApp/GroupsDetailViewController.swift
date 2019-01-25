//
//  GroupsDetailViewController.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 1/25/19.
//  Copyright © 2019 Glome. All rights reserved.
//

import UIKit

class GroupsDetailViewController: UIViewController {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    @IBOutlet weak var membersLabel: UILabel!
    
    var groupName = ""
    var members = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupNameLabel.text = groupName
        membersLabel.text = members

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
