//
//  MessageViewController.swift
//  RefugeeApp
//
//  Created by Abha Vedula on 5/11/18.
//  Copyright © 2018 Glome. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {

    @IBOutlet weak var messageTableView: UITableView!
    
    var ref: DatabaseReference!
    
    var messages: [String] = []

    var selectedMessageIndex = 0
    
    @IBOutlet weak var customMessageField: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTableView.estimatedRowHeight = 200
        
        navigationController?.delegate = self
        
        ref = Database.database().reference(withPath: "messages")
        ref.observeSingleEvent(of: .value) { snapshot in
            let enumerator = snapshot.children
            while let rest = enumerator.nextObject() as? DataSnapshot {
                self.messages.append((rest.value! as! Dictionary)["English"]!)
            }
            self.messageTableView.reloadData()
        }
        
        // Do any additional setup after loading the view.
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        
        
        if (selectedMessageIndex == 5) {
           (viewController as? ViewController)?.messageField.text = customMessageField.text
        } else {
            (viewController as? ViewController)?.originalMessageField.text = messages[selectedMessageIndex]
            (viewController as? ViewController)?.message = messages[selectedMessageIndex]
            (viewController as? ViewController)?.messageID = selectedMessageIndex
        }
        
        (viewController as? ViewController)?.updateMessageTextField()
        
        // Here you pass the to your original view controller
    }


    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = messageTableView.dequeueReusableCell(withIdentifier: "cell")
        cell?.textLabel?.text = messages[indexPath.row]
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedMessageIndex = indexPath.row
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


