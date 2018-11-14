//
//  NewContactViewController.swift
//  RefugeeApp2
//
//  Created by  on 11/13/18.
//  Copyright © 2018 Glome. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewContactViewController: UIViewController {

    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var langField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = 5

        // Do any additional setup after loading the view.
    }
    

    @IBAction func onAddContactPressed(_ sender: Any) {
        if (nameField.text == nil || numberField.text == nil || langField.text == nil) {
            // Ask user to fill all fields in
        } else {
            ref = Database.database().reference(withPath: "contacts")
            self.ref.child(nameField.text!).setValue(["name":nameField.text!,
                                                      "number":numberField.text!,
                                                      "lang":langField.text!])
        }
        navigationController?.popViewController(animated: true)
        
        dismiss(animated: true, completion: nil)

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
