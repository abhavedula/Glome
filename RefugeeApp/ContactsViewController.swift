//
//  ContactsViewController.swift
//  RefugeeApp
//
//  Created by Abha Vedula on 5/20/18.
//  Copyright © 2018 Glome. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class ContactsTableViewCell: UITableViewCell {

    @IBOutlet weak var contactNameLabel: UILabel!
    
    override func layoutSubviews() {
        super.layoutSubviews() // This is important, don't forget to call the super.layoutSubviews
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        self.accessoryType = selected ? .checkmark : .none
    }
   
}

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    var ref: DatabaseReference!
    
    var contacts: [Contact] = []
    
    var checked: [Bool] = []
    var canSelect: Bool = false

    var selectGroup: Bool = false
    var groupChecked: [Bool] = []
    
    @IBOutlet weak var addContactButton: UIButton!
    @IBOutlet weak var addGroupButton: UIButton!
    @IBOutlet weak var newGroupButton: UIButton!
    @IBOutlet weak var doneButton: UIButton!
    
    @IBAction func onAddNewContactPressed(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
        var i = 0
        ref = Database.database().reference(withPath: "contacts")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                if (i == 0) {
                    self.contacts = []
                }
                var name: String
                name = (rest.value! as! Dictionary)["name"]!
                var lang: String
                lang = (rest.value! as! Dictionary)["lang"]!
                var num: String
                num = (rest.value! as! Dictionary)["number"]!
                let c =  Contact(mName: name, mLanguage: lang, mNumber: num)
                self.contacts.append(c)
                i = i + 1
                if (self.checked.count < i && self.canSelect) {
                    self.checked.append(false)
                }
            }
            self.contactsTableView.reloadData()
        }
        
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if (canSelect) {
            addContactButton.isHidden = true
            addGroupButton.isHidden = true
        }
        doneButton.isHidden = true
        
        contacts = []
        addContactButton.layer.cornerRadius = 5
        addGroupButton.layer.cornerRadius = 5
        newGroupButton.layer.cornerRadius = 5
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        navigationController?.delegate = self
        
        contactsTableView.rowHeight = UITableViewAutomaticDimension
        contactsTableView.estimatedRowHeight = 100
        
        if (canSelect) {
            contactsTableView.allowsMultipleSelection = true
            contactsTableView.allowsMultipleSelectionDuringEditing = true
            contactsTableView.setEditing(true, animated: false)
        }
        
        if (!canSelect) {
        ref = Database.database().reference(withPath: "contacts")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                var name: String
                name = (rest.value! as! Dictionary)["name"]!
                var lang: String
                lang = (rest.value! as! Dictionary)["lang"]!
                var num: String
                num = (rest.value! as! Dictionary)["number"]!
                let c =  Contact(mName: name, mLanguage: lang, mNumber: num)
                self.contacts.append(c)
            }
            self.contactsTableView.reloadData()
            }
            
        }
     
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func onDonePressed(_ sender: Any) {
        // Do the actual adding of people to group
        
        // Show/hide buttons
        addContactButton.isHidden = false
        addGroupButton.isHidden = false
        newGroupButton.isHidden = false
        
        doneButton.isHidden = true
        
        // Disable selection
        contactsTableView.allowsMultipleSelection = false
        contactsTableView.allowsMultipleSelectionDuringEditing = false
        contactsTableView.setEditing(false, animated: false)
        selectGroup = false
    }
    
    @IBAction func onAddGroupPressed(_ sender: Any) {
        contactsTableView.allowsMultipleSelection = true
        contactsTableView.allowsMultipleSelectionDuringEditing = true
        contactsTableView.setEditing(true, animated: false)
        selectGroup = true
        
        for (_, _) in contacts.enumerated() {
            groupChecked.append(false)
        }
        
        addContactButton.isHidden = true
        addGroupButton.isHidden = true
        newGroupButton.isHidden = true
        doneButton.isHidden = false
        
    }
    

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
            // Create the group in database
        }))
        
        // 4. Present the alert.
        self.present(alert, animated: true, completion: nil)
    }
    
  
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        // reset contacts data in main view controller
      
        (viewController as? ViewController)?.recipients = []
        (viewController as? ViewController)?.recipientField.text? = ""
        
        for (i, element) in checked.enumerated() {
            if (element) {
                (viewController as? ViewController)?.recipients.append(contacts[i])
                (viewController as? ViewController)?.recipientField.text?.append(contacts[i].getName() + " ")
            }
        }
        
        
        if ((viewController as? ViewController)?.message != "") {
            (viewController as? ViewController)?.updateMessageTextField()
        }
        
        (viewController as? ViewController)?.checked = checked        // Here you pass the to your original view controller
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "contactCell") as! ContactsTableViewCell
        cell.contactNameLabel?.text = contacts[indexPath.row].getName()
        
        if (checked.count > 0) {
            if (checked[indexPath.row] && canSelect) {
                cell.setSelected(checked[indexPath.row], animated: false)
                contactsTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (canSelect) {
            if (checked.count > 0) {
                checked[indexPath.row] = !checked[indexPath.row]
            }
        } else if (selectGroup) {
            if (groupChecked.count > 0) {
                groupChecked[indexPath.row] = !groupChecked[indexPath.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (canSelect) {
            if (checked.count > 0) {
                checked[indexPath.row] = !checked[indexPath.row]
            }
        } else if (selectGroup) {
            if (groupChecked.count > 0) {
                groupChecked[indexPath.row] = !groupChecked[indexPath.row]
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
//
//        // Fetch Item
//        let item = contacts[indexPath.row]
//
//
//        // Perform Segue
//       let destVC = ContactDetailViewController()
//        destVC.nameLabel.text = item.getName()
//        destVC.numberLabel.text = item.getNumber()
//        destVC.langLabel.text = item.getLanguage()
//        destVC.performSegue(withIdentifier: "contactDetailSegue", sender: self)
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
        
        if let destinationViewController = segue.destination as? ContactDetailViewController {
            if let button = sender as? UIButton {
                let buttonPosition:CGPoint = button.convert(CGPoint.zero, to:self.contactsTableView)
                let indexPath = self.contactsTableView.indexPathForRow(at: buttonPosition)
                let r: Int = (indexPath?.row)!
                destinationViewController.language = contacts[r].getLanguage()
                destinationViewController.number = contacts[r].getNumber()
                destinationViewController.name = contacts[r].getName()
                
            }
            
        }
    }

    


}
