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

    @IBOutlet weak var addContactButton: UIButton!
    @IBAction func onAddNewContactPressed(_ sender: Any) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        contacts = []
        var i = 0
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
                i = i + 1
                if (self.checked.count < i) {
                    self.checked.append(false)
                }
            }
            self.contactsTableView.reloadData()
        }
   }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addContactButton.layer.cornerRadius = 5
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        navigationController?.delegate = self
        
        contactsTableView.rowHeight = UITableViewAutomaticDimension
        contactsTableView.estimatedRowHeight = 100
        
        if (checked.count > 0) {
            contactsTableView.allowsMultipleSelection = true
            contactsTableView.allowsMultipleSelectionDuringEditing = true
            contactsTableView.setEditing(true, animated: false)
        }
        
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
        
        
        // Do any additional setup after loading the view.
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
            if (checked[indexPath.row]) {
                cell.setSelected(checked[indexPath.row], animated: false)
                contactsTableView.selectRow(at: indexPath, animated: false, scrollPosition: .none)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (checked.count > 0) {
            checked[indexPath.row] = !checked[indexPath.row]
        }
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if (checked.count > 0) {
            checked[indexPath.row] = !checked[indexPath.row]
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
