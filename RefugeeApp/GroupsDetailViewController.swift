//
//  GroupsDetailViewController.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 1/25/19.
//  Copyright © 2019 Glome. All rights reserved.
//

import UIKit


class GroupsDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var groupNameLabel: UILabel!
    
    @IBOutlet weak var groupDetailTableView: UITableView!
    
    var members: [Contact] = []
    
    var groupName = ""
    
    var myNumber = ""

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        groupNameLabel.text = groupName
        
        groupDetailTableView.delegate = self
        groupDetailTableView.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupDetailTableView.dequeueReusableCell(withIdentifier: "groupMemberCell") as! GroupsDetailTableViewCell
        cell.groupMemberLabel?.text = members[indexPath.row].getName()
        return cell
    }
    

    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? ContactDetailViewController {
            if let button = sender as? UIButton {
                let buttonPosition:CGPoint = button.convert(CGPoint.zero, to:self.groupDetailTableView)
                let indexPath = self.groupDetailTableView.indexPathForRow(at: buttonPosition)
                let r: Int = (indexPath?.row)!
                destinationViewController.language = members[r].getLanguage()
                destinationViewController.number = members[r].getNumber()
                destinationViewController.name = members[r].getName()
                destinationViewController.myNumber = myNumber
                
            }
            
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

class GroupsDetailTableViewCell: UITableViewCell {
    
    @IBOutlet weak var groupMemberLabel: UILabel!
    
}
