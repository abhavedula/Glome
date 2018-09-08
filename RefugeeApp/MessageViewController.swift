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
    var arabic: [String] = []

//    let messages = ["Hello! We will not have the after-school program tomorrow due to the early dismissal from school.", "Hello! We will not have the after-school program tomorrow because there is no school.", "Custom"]
//    let arabic = ["اهلاً. لن يقام برنامج ما بعد المدرسة غداً بسبب الخروج المبكر من المدرسة", "اهلاً. لن يقام برنامج ما بعد المدرسة غداً بسبب العطلة من المدرسة غداً"]
    let urdu = ["Salam! Kal school jaldi band horaha hai, isliye school ke bad koi program nai hai.", "Salam! Kal school band hai, isliye school ke bad koi program nai hai."]
    
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
        
        
        if (selectedMessageIndex == 2) {
           (viewController as? ViewController)?.messageField.text = customMessageField.text
        } else {
//            let language = (viewController as? ViewController)?.language
//            if (language == "Urdu") {
//                selectedMessage = urdu[selectedMessageIndex]
//            } else if (language == "Arabic") {
//                selectedMessage = arabic[selectedMessageIndex]
//            }
//
//            (viewController as? ViewController)?.messageField.text = selectedMessage
//            print("yo " + selectedMessage)
//            (viewController as? ViewController)?.originalMessageField.text = messages[selectedMessageIndex]
            (viewController as? ViewController)?.message = messages[selectedMessageIndex]
        }
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


