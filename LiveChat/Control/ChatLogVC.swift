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
        chatLogView.myTableView.delegate = self
        chatLogView.myTableView.dataSource = self
        chatLogView.myTextField.delegate = self
        setNavigation()
        observeMsg()
        userID = Auth.auth().currentUser?.uid
        setupKeyboardObservers()
        chatLogView.myTableView.keyboardDismissMode = .interactive
        touchAnywhereToCloseKeyboard()
       
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
    }
    
    
    // MARK: - Methods
    
    //MARK: navigation
    func setNavigation() {
        self.navigationItem.title = chatName
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    override var canResignFirstResponder: Bool {
        true
    }
    
//    lazy var inputContainerView: UIView = {
//        let bview = UIView()
//        bview.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 100)
//        bview.backgroundColor = .gray
//        bview.translatesAutoresizingMaskIntoConstraints = false
//
//        let textField: UITextField =  {
//            let tf = UITextField()
//            tf.placeholder = "234234"
//            return tf
//        }()
//
//
//        return bview
//    }()
//
//    override var inputAccessoryView: UIView? {
//        get {
//            inputContainerView
//        }
//    }
    
    //MARK: texField隨keyboard調整
    func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func handleKeyboardWillShow(notification: NSNotification) {
        let keyboardFrame = notification.userInfo? [UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        let height = (keyboardFrame?.cgRectValue.height)
        chatLogView.bottomView.snp.remakeConstraints { (make) in
            make.left.width.equalTo(self.chatLogView)
            make.bottom.equalTo(-height!+50)
            make.height.equalTo(100)
        }
        
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func handleKeyboardWillHide(notification: NSNotification) {
        chatLogView.bottomView.snp.remakeConstraints { (make) in
            make.left.width.equalTo(self.chatLogView)
            make.bottom.equalTo(self.chatLogView)
            make.height.equalTo(100)
        }
        
        let keyboardDuration = notification.userInfo? [UIResponder.keyboardAnimationDurationUserInfoKey] as? TimeInterval
        UIView.animate(withDuration: keyboardDuration!) {
            self.view.layoutIfNeeded()
        }
    }
    
    
    //MARK: 接Msg
    @objc func sendMsg() {
        let timeStamp = NSDate().timeIntervalSince1970
        let ref = Database.database().reference().child("\(chatName)")
        let childRef = ref.childByAutoId()
        if let text = chatLogView.myTextField.text {
            let values = ["id": userID!, "text": text, "time": timeStamp] as [String : Any]
            childRef.updateChildValues(values)
            
        }
        //        chatLogView.myTextField.text = ""
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
    
    //MARK: 關閉keyboard
    func touchAnywhereToCloseKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}
//MARK: - UITableViewDelegate, UITableViewDataSource

extension ChatLogVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection numberOfRowsInSectionsection: Int) -> Int {
        messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier:ChatLogTableViewCell.identifier, for: indexPath) as? ChatLogTableViewCell else { return UITableViewCell() }
        //cell 無法被點選
        cell.selectionStyle = .none
        //防止cell重用
        cell.yourID.text = nil
        cell.yourProfileImage.backgroundColor = nil
        
        if userID == userIDs[indexPath.row] {
            cell.isIncoming = false
        }else{
            cell.isIncoming = true
            cell.yourID.text = userIDs[indexPath.row]
            cell.yourProfileImage.backgroundColor = .systemBlue
        }
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
    
    //    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //        self.view.endEditing(true)
    //        return true
    //    }
    
    
}

