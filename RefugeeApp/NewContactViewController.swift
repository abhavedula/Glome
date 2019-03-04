//
//  NewContactViewController.swift
//  RefugeeApp2
//
//  Created by  on 11/13/18.
//  Copyright © 2018 Glome. All rights reserved.
//

import UIKit
import FirebaseDatabase

class NewContactViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var numberField: UITextField!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var langPicker: UIPickerView!
    
    var selectedLang: String = ""
    
    var myNumber: String!
    
    let langs: [Language] = Language.allCases
    
    var ref: DatabaseReference!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addButton.layer.cornerRadius = 5
        
        langPicker.delegate = self
        langPicker.dataSource = self

        // Do any additional setup after loading the view.
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return langs.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return langs[row].rawValue
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedLang = langs[row].rawValue
    }

    @IBAction func onAddContactPressed(_ sender: Any) {
        if (nameField.text == "" || numberField.text == "") {
            // Ask user to fill all fields in
            let alert = UIAlertController(title: "Please fill out all fields", message: "", preferredStyle: .alert)
            
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [weak alert] (_) in
                
            }))
            
            self.present(alert, animated: true, completion: nil)
            
        } else {
            ref = Database.database().reference(withPath: "users/" + self.myNumber + "/contacts")
            self.ref.child(nameField.text!).setValue(["name":nameField.text!,
                                                      "number":numberField.text!,
                                                      "lang":selectedLang,
                                                      "groups":nil])
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
