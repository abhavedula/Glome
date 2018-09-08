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
    
    var contacts: [String] = []
    var languages: [String] = []
    var number: [String] = []
    
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        contactsTableView.delegate = self
        contactsTableView.dataSource = self
        
        navigationController?.delegate = self
        
        ref = Database.database().reference(withPath: "contacts")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.contacts.append((rest.value! as! Dictionary)["name"]!)
                self.languages.append((rest.value! as! Dictionary)["lang"]!)
                self.number.append((rest.value! as! Dictionary)["number"]!)
            }
            self.contactsTableView.reloadData()
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
         (viewController as? ViewController)?.recipientNames.append(contacts[selectedIndex])
        (viewController as? ViewController)?.recipientNums.append(number[selectedIndex])
        (viewController as? ViewController)?.languages.append(languages[selectedIndex])
        // Here you pass the to your original view controller
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = contactsTableView.dequeueReusableCell(withIdentifier: "contactCell")
        cell?.textLabel?.text = contacts[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndex = indexPath.row
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
