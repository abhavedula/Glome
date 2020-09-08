//
//  ConversationViewController.swift
//  RefugeeApp2
//
//  Created by Abha Vedula on 1/14/20.
//  Copyright © 2020 Glome. All rights reserved.
//

import UIKit
import Foundation
import FirebaseDatabase
import Alamofire

class ConversationCell: UITableViewCell {
    
    let cellView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let conversationLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    func setupView() {
        addSubview(cellView)
        cellView.addSubview(conversationLabel)
        self.selectionStyle = .none
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: self.topAnchor, constant: 20),
            cellView.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -20),
            cellView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20),
            cellView.bottomAnchor.constraint(equalTo: self.bottomAnchor)
            ])
        
        conversationLabel.heightAnchor.constraint(equalToConstant: 200).isActive = true
        conversationLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        conversationLabel.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        conversationLabel.leftAnchor.constraint(equalTo: cellView.leftAnchor, constant: 20).isActive = true
        
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

class ConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UINavigationControllerDelegate {
    
    @IBOutlet weak var conversationTableView: UITableView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    var myNumber = ""
    var recipientName = ""
    var recipientNumber: String = ""
    
    var messages: [Message] = []
    
    let tableview: UITableView = {
        let tv = UITableView()
        tv.backgroundColor = UIColor(red: 58.0/255, green: 96.0/255, blue: 126.0/255, alpha: 1.0)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.separatorColor = UIColor(red: 58.0/255, green: 96.0/255, blue: 126.0/255, alpha: 1.0)
        return tv
    }()
    
    let recipientLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = UIColor.white
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        recipientLabel.text = recipientName
        view.addSubview(recipientLabel)
        view.backgroundColor = UIColor(red: 58.0/255, green: 96.0/255, blue: 126.0/255, alpha: 1.0)

        // Do any additional setup after loading the view.
        
        let accountSID = "ACfd625c80670237064ee9dae1fc445844"
        let authToken = "1a9254dd1c1b2fc645eda19e37b7720b"
        
        let url = "https://api.twilio.com/2010-04-01/Accounts/\(accountSID)/Messages.json?to=" + recipientNumber + "&from=" + recipientNumber
        
        Alamofire.request(url, method: .get)
                    .authenticate(user: accountSID, password: authToken)
            .responseJSON { response in
                if let result = response.result.value {
                    let JSON = result as! NSDictionary
                    let messageArray = JSON["messages"] as! NSArray
                    for m in messageArray {
                        let message = m as! NSDictionary
                        let to = message["to"] as! String
                        let from = message["from"] as! String
                        let recipient = "+1" + self.recipientNumber
                        if (to == recipient || from == recipient) {
                            let body = message["body"] as! String
                            let date = message["date_sent"] as! String
                            var  isSender = false
                            if (to == recipient) {
                                isSender = true
                            }
                            let messageObj =  Message(mBody: body, mDate: date, mIsSender: isSender)
                            self.messages.append(messageObj)
                            print(messageObj.getBody())
                        }
                    }
                    
                    // Display messages on screen
                    self.setupTableView()
                    
                }
                
        }
        
        
    }
    
    func setupTableView() {
        tableview.delegate = self
        tableview.dataSource = self

        tableview.register(ConversationCell.self, forCellReuseIdentifier: "cellId")
        
        view.addSubview(tableview)
        
        NSLayoutConstraint.activate([
            tableview.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableview.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            tableview.leftAnchor.constraint(equalTo: self.view.leftAnchor)
            ])
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableview.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! ConversationCell
        cell.conversationLabel.text = messages[indexPath.row].getBody()
        if (messages[indexPath.row].getIsSender()) {
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: "You\n", attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]));
            text.append(NSAttributedString(string: cell.conversationLabel.text!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]))
            cell.conversationLabel.attributedText = text
            cell.cellView.backgroundColor = UIColor(red: 135.0/255, green: 181.0/255, blue: 203.0/255, alpha: 1.0)
            
        } else {
            let text = NSMutableAttributedString()
            text.append(NSAttributedString(string: recipientName + "\n", attributes: [NSAttributedString.Key.font: UIFont.italicSystemFont(ofSize: 15), NSAttributedString.Key.foregroundColor: UIColor.white]));
            text.append(NSAttributedString(string: cell.conversationLabel.text!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white]))
            cell.conversationLabel.attributedText = text
            cell.cellView.backgroundColor = UIColor(red: 58.0/255, green: 96.0/255, blue: 126.0/255, alpha: 1.0)
        }
        cell.conversationLabel.numberOfLines = 0;
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
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
