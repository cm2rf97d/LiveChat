//
//  ChatLogVC.swift
//  LiveChat
//
//  Created by 董恩志 on 2021/4/7.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ChatLogVC: UIViewController {

    // MARK: - Properties
    
    var chatName = ""
    let chatLogView = ChatLogView()
    var messages = [String]() {
        didSet{
            chatLogView.myTableView.reloadData()
        }
    }
    
    var userIDs = [String]()
    var userID: String?
    var message = Messages()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = chatLogView
        view.backgroundColor = .white
        chatLogView.myTableView.delegate = self
        chatLogView.myTableView.dataSource = self
        chatLogView.myTextField.delegate = self
        setNavigation()
        observeMsg()
        userID = Auth.auth().currentUser?.uid
    }
    // MARK: - Methods

    func setNavigation() {
        self.navigationItem.title = chatName
    }
    
    @objc func sendMsg() {
        let timeStamp = NSDate().timeIntervalSince1970
        let ref = Database.database().reference().child("\(chatName)")
        let childRef = ref.childByAutoId()
        if let text = chatLogView.myTextField.text {
            let values = ["id": userID!, "text": text, "time": timeStamp] as [String : Any]
            childRef.updateChildValues(values)
            
            }
            chatLogView.myTextField.text = ""
        }
    
    func observeMsg() {
        let ref = Database.database().reference().child("\(chatName)")
        
            ref.observe(.childAdded) { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject] {
                    if let id = dictionary["id"] as? String, let text = dictionary["text"] as? String {
//                        self.message.id = id
//                        self.message.text = text
                        self.messages.append(text)
                        self.userIDs.append(id)
                    }
                    
                }
                
            }
        
        }
    }

    //MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatLogVC: UITableViewDelegate, UITableViewDataSource {
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection numberOfRowsInSectionsection: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:ChatLogTableViewCell.identifier, for: indexPath) as? ChatLogTableViewCell else { return UITableViewCell() }
        if userID == userIDs[indexPath.row] {
            cell.isIncoming = false
        }else{
            cell.isIncoming = true
        }
        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier:ChatLogTableViewCell.identifier, for: indexPath) as?ChatLogTableViewCell else { return UITableViewCell() }
        
//        if userID == userIDs[indexPath.row] {
//            cell.myTextlabel.text = messages[indexPath.row]
//        }else{
//            cell.yourTextlabel.text = messages[indexPath.row]
//            cell.yourID.text = userIDs[indexPath.row]
//        }
        cell.myTextlabel.text = messages[indexPath.row]
        cell.myTextlabel.numberOfLines = 0
        
        
        return cell
    }
}

extension ChatLogVC: UITextFieldDelegate {
        
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        sendMsg()
        return true
    }
    
}

