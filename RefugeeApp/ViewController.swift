//
//  ViewController.swift
//  RefugeeApp
//
//  Created by Abha Vedula on 5/10/18.
//  Copyright © 2018 Glome. All rights reserved.
//

import UIKit
import Foundation
import Alamofire

class ViewController: UIViewController {
    
    var message = "default"
    
    @IBOutlet weak var messageField: UILabel!
    
    @IBAction func onPressSend(_ sender: Any) {
        let accountSID = "ACfd625c80670237064ee9dae1fc445844"
        let authToken = "d558044c31f041db628941ac481d838c"

            let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages"
            let parameters = ["From": "+13167124212", "To": "+12153754459", "Body": messageField.text]

            Alamofire.request(url, method: .post, parameters: parameters)
                .authenticate(user: accountSID, password: authToken)
                .responseJSON { response in
                    debugPrint(response)
            }

            RunLoop.main.run()
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

