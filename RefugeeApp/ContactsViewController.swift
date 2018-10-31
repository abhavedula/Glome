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

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var contactsTableView: UITableView!
    
    var ref: DatabaseReference!
    
    var contacts: [Contact] = []
    
    var checked: [Bool] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        navigationController?.delegate = self
        
        contactsTableView.rowHeight = UITableViewAutomaticDimension
        contactsTableView.estimatedRowHeight = 100
        
        contactsTableView.allowsMultipleSelection = true
        contactsTableView.allowsMultipleSelectionDuringEditing = true
        contactsTableView.setEditing(true, animated: false)

        
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
                self.checked.append(false)
            }
            self.contactsTableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        for (i, element) in checked.enumerated() {
            if (element) {
                (viewController as? ViewController)?.recipients.append(contacts[i])
                (viewController as? ViewController)?.recipientField.text?.append(contacts[i].getName() + " ")
            }
        }
        
        
        if ((viewController as? ViewController)?.message != "") {
            (viewController as? ViewController)?.updateMessageTextField()
        }
        // Here you pass the to your original view controller
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "contactCell")
        cell?.textLabel?.text = contacts[indexPath.row].getName()
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        checked[indexPath.row] = !checked[indexPath.row]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
