//
//  GroupsViewController.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 1/13/19.
//  Copyright © 2019 Glome. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class GroupsTableViewCell: UITableViewCell {

    
    @IBOutlet weak var groupNameLabel: UILabel!
   
    override func layoutSubviews() {
        super.layoutSubviews() // This is important, don't forget to call the super.layoutSubviews
    }
}

class GroupsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    
    var myNumber : String!
    
    var groups: [Group] = []
    
    var checked: [Bool] = []
    var canSelect: Bool = false
    
    @IBOutlet weak var groupsTableView: UITableView!
    
    @IBOutlet weak var newGroupButton: UIButton!
    @IBOutlet weak var addGroupButton: UIButton!
        
    
    @IBAction func onNewGroupPressed(_ sender: Any) {
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Group Name", message: "Enter group name", preferredStyle: .alert)
        
        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "Group name"
        }
        
        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [weak alert] (_) in
            let textField = alert?.textFields![0] // Force unwrapping because we know it exists.
            print("Text field: \(textField!.text)")
            self.ref = Database.database().reference(withPath: "users/" + self.myNumber + "/groups")
            self.ref.child(textField!.text!).setValue(["name":textField!.text])
            self.groups.append(Group(mName: textField!.text!))
            self.groupsTableView.reloadData()
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        var i = 0
        ref = Database.database().reference(withPath: "users/" + myNumber + "/groups")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if (i == 0) {
                    self.groups = []
                }
                let dict: [String:Any] = rest.value! as! Dictionary
                var name: String
                name = dict["name"]! as! String
                let g = Group(mName: name)
                self.groups.append(g)
                i = i + 1
                if (self.checked.count < i && self.canSelect) {
                    self.checked.append(false)
                }
            }
            self.groupsTableView.reloadData()
            self.getGroupMembers()
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addGroupButton.layer.cornerRadius = 5
        newGroupButton.layer.cornerRadius = 5
        
        groupsTableView.rowHeight = UITableViewAutomaticDimension
        groupsTableView.estimatedRowHeight = 100
        
        groupsTableView.delegate = self
        groupsTableView.dataSource = self
        
        navigationController?.delegate = self

        if (canSelect) {
            groupsTableView.allowsMultipleSelection = true
            groupsTableView.allowsMultipleSelectionDuringEditing = true
            groupsTableView.setEditing(true, animated: false)
        }

        if (!canSelect) {
            ref = Database.database().reference(withPath: "users/" + myNumber + "/groups")
            ref.observeSingleEvent(of: .value) { snapshot in
                let enumerator = snapshot.children
                while let rest = enumerator.nextObject() as? DataSnapshot {
                    let dict: [String:Any] = rest.value! as! Dictionary
                    var name: String
                    name = dict["name"]! as! String
                    let g = Group(mName: name)
                    self.groups.append(g)
                }
                self.groupsTableView.reloadData()
            }
        }
        // Do any additional setup after loading the view.
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groups.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = groupsTableView.dequeueReusableCell(withIdentifier: "groupCell") as! GroupsTableViewCell
        cell.groupNameLabel?.text = groups[indexPath.row].getName()
        
        if (checked.count > 0) {
            if (checked[indexPath.row] && canSelect) {
                cell.setSelected(checked[indexPath.row], animated: false)
                groupsTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (canSelect) {
            if (checked.count > 0) {
                checked[indexPath.row] = !checked[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (canSelect) {
            if (checked.count > 0) {
                checked[indexPath.row] = !checked[indexPath.row]
            }
        } 
    }
    
    func getGroupMembers() {
        ref = Database.database().reference(withPath: "users/" + myNumber + "/contacts")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                let dict: [String:Any] = rest.value! as! Dictionary
                var name: String
                name = dict["name"]! as! String
                var lang: String
                lang = dict["lang"]! as! String
                var num: String
                num = dict["number"]! as! String
                let c =  Contact(mName: name, mLanguage: lang, mNumber: num)
                if let g: [String:Any] = dict["groups"] as? Dictionary {
                    for (k,_) in g {
                        let idx = self.groups.index(where: { (item) -> Bool in
                            item.getName() == k // test if this is the item you're looking for
                        })
                        self.groups[idx!].addMember(contact: c)
                    }
                }
            }
            self.groupsTableView.reloadData()
        }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // reset contacts data in main view controller

        (viewController as? ViewController)?.recipientsGroups = []
        (viewController as? ViewController)?.recipientField.text? = ""
       
        var numChecked = checked.filter{$0 == true}.count
        
        if (groups.count > 0) {
            for (i, element) in checked.enumerated() {
                if (element) {
                    let members : [Contact] = groups[i].getMembers()
                    (viewController as? ViewController)?.recipientsGroups += members
                    let membersNames = members.map { $0.getName() }
                    (viewController as? ViewController)?.recipientField.text?.append(membersNames.joined(separator:", "))
//                    for contact in groups[i].getMembers() {
//                        (viewController as? ViewController)?.recipientsGroups.append(contact)
//                        (viewController as? ViewController)?.recipientField.text?.append(contact.getName() + " ")
//                    }
                }
            }
        }
        
//        for contact in ((viewController as? ViewController)?.recipientsContacts) ?? [] {
//            (viewController as? ViewController)?.recipientField.text?.append(contact.getName() + " ")
//        }
        
        let members : [Contact] = ((viewController as? ViewController)?.recipientsContacts) ?? []
        let membersNames = members.map { $0.getName() }
        if (members.count > 0 && numChecked > 0) {
            (viewController as? ViewController)?.recipientField.text?.append(", ")
        }
        (viewController as? ViewController)?.recipientField.text?.append(membersNames.joined(separator:", "))
        
        
        if ((viewController as? ViewController)?.message != "") {
            (viewController as? ViewController)?.updateMessageTextField()
        }
        
        (viewController as? ViewController)?.checkedGroups = checked        // Here you pass the to your original view controller
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? GroupsDetailViewController {
            if let button = sender as? UIButton {
                let buttonPosition:CGPoint = button.convert(CGPoint.zero, to:self.groupsTableView)
                let indexPath = self.groupsTableView.indexPathForRow(at: buttonPosition)
                let r: Int = (indexPath?.row)!
                destinationViewController.groupName = groups[r].getName()
//                var members : [Contact] = groups[r].getMembers()
//                let membersNames = members.map { $0.getName() }
//                destinationViewController.members = membersNames.joined(separator:", ")
                destinationViewController.members = groups[r].getMembers()
                destinationViewController.myNumber = myNumber

            }
            
        }
    }


}

