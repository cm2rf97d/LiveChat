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
    
//    var chatName = ""
    var chatName: FriendAccountUserId?
    let chatLogView = ChatLogView()
    let chatLogCell = ChatLogTableViewCell()
    var messages = [String]() {
        didSet{
            chatLogView.chatLogTableView.reloadData()
//            scrollToBottom()
//            chatLogView.myTableView.scrollTo(direction: .bottom)
        }
    }
    
    var isIncoming: Bool! {
        didSet {
//            chatLogCell.yourID.isHidden = isIncoming ? false:true
//            chatLogCell.yourProfileImage.isHidden = isIncoming ? false:true
//            chatLogCell.yourTextlabel.isHidden = isIncoming ? false:true
//            chatLogCell.yourbubleView.isHidden = isIncoming ? false:true
//            chatLogCell.mybubleView.isHidden = isIncoming ? true:false
//            chatLogCell.myTextlabel.isHidden = isIncoming ? true:false
        }
    }
    
    var userIDs = [String]()
    var userID: String?
    var message = Messages()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = chatLogView
        chatLogView.chatLogTableView.delegate = self
        chatLogView.chatLogTableView.dataSource = self
        chatLogView.inputTextField.delegate = self
        setNavigation()
        observeMsg()
        userID = Auth.auth().currentUser?.uid
        setupKeyboardObservers()
        chatLogView.chatLogTableView.keyboardDismissMode = .interactive
        touchAnywhereToCloseKeyboard()
        //tableView 顛倒
        chatLogView.chatLogTableView.transform = CGAffineTransform(scaleX: 1, y: -1)
        touchToLoadImage()
        chatLogView.sendBtn.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        NotificationCenter.default.removeObserver(self)
//        navigationController?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
        tabBarController?.selectedIndex = 0
    }
    
    
    // MARK: - Methods
    
    //MARK: navigation
    func setNavigation() {
        self.navigationItem.title = chatName?.userAccount
    }
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
//    override var canResignFirstResponder: Bool {
//        true
//    }
    
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
        
//        chatLogView.chatLogTableView.scrollTo(direction: .bottom)
        
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
        guard chatLogView.inputTextField.text != "" else { return }
        let timeStamp = NSDate().timeIntervalSince1970
        if let chatName = chatName{
            let ref = Database.database().reference().child("ChatRoom").child(currentUserId).child(chatName.userID)
            let childRef = ref.childByAutoId()
            if let text = chatLogView.inputTextField.text {
                let values = ["id": userID!, "text": text, "time": timeStamp] as [String : Any]
                childRef.updateChildValues(values)
                friendChatRecordUpload(chatName: chatName.userID, text: text, time: timeStamp)
                
            }
            chatLogView.inputTextField.text = ""
        }
    }
    
    func friendChatRecordUpload(chatName: String, text: String, time: TimeInterval)
    {
        let ref = Database.database().reference().child("ChatRoom").child(chatName).child(currentUserId)
        let childRef = ref.childByAutoId()
        let values = ["id": userID!, "text": text, "time": time] as [String : Any]
        childRef.updateChildValues(values)
    }
    
    func observeMsg() {
        guard let chatName = chatName else {return}
        let ref = Database.database().reference().child("ChatRoom").child(currentUserId).child(chatName.userID)
        ref.observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if let id = dictionary["id"] as? String, let text = dictionary["text"] as? String {
                    //                        self.message.id = id
                    //                        self.message.text = text
//                    self.messages.append(text)
                    self.messages.insert(text, at: 0)
//                    self.userIDs.append(id)
                    self.userIDs.insert(id, at: 0)
//            ref.observe(.childAdded) { (snapshot) in
//                if let dictionary = snapshot.value as? [String: AnyObject] {
//
//                    if let id = dictionary["id"] as? String, let text = dictionary["text"] as? String {
//                        self.message.id = id
//                        self.message.text = text
//                        self.messages.append(text)
//                        self.userIDs.append(id)
//                    }
                    
                }
            }
        }
        
//                chatLogView.chatLogTableView.scrollTo(direction: .top)
    
//    func test1() {
//            let content = UNMutableNotificationContent()
//        content.title = "\(String(describing: message.id))"
//        content.body = "\(String(describing: message.text))"
//        content.badge = 1
//        content.sound = UNNotificationSound.default
//
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
//
//            let request = UNNotificationRequest(identifier: "notification", content: content, trigger: trigger)
//
//            UNUserNotificationCenter.current().add(request, withCompletionHandler: {error in
//                print("成功建立通知...")
//            })
//
//        }
    
    }
    
    //MARK: 關閉keyboard
    func touchAnywhereToCloseKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func scrollToNewMessage(){
        let indexPath = IndexPath(item: 0, section: 0)
        chatLogView.chatLogTableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
        
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
//        cell.yourID.text = nil
//        cell.yourProfileImage.backgroundColor = nil
        //cell 顛倒
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        if userID == userIDs[indexPath.row] {
//            isIncoming = false
            cell.yourID.isHidden = true
            cell.yourProfileImage.isHidden = true
            cell.yourTextlabel.isHidden = true
            cell.yourbubleView.isHidden = true
            cell.myTextlabel.isHidden = false
            cell.mybubleView.isHidden = false
            
            cell.myTextlabel.text = messages[indexPath.row]
        }else{
//            isIncoming = true
            cell.yourID.isHidden = false
            cell.yourProfileImage.isHidden = false
            cell.yourTextlabel.isHidden = false
            cell.yourbubleView.isHidden = false
            cell.mybubleView.isHidden = true
            cell.myTextlabel.isHidden = true
            
            cell.yourID.text = userIDs[indexPath.row]
            cell.yourProfileImage.backgroundColor = .systemBlue
            cell.yourTextlabel.text = messages[indexPath.row]
        }
//        cell.myTextlabel.numberOfLines = 0
        
//            test1()
//        }
//        cell.myTextlabel.text = messages[indexPath.row]
//        cell.myTextlabel.numberOfLines = 0
            
        return cell
    }
}


//MARK: - TextFieldDelegate
extension ChatLogVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if chatLogView.inputTextField.text != "" {
            sendMessage()
        }
        return true
    }
    
    @objc func sendMessage() {
        sendMsg()
//        scrollToNewMessage()  //Mike Modify
    }
    
    //    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //        self.view.endEditing(true)
    //        return true
    //    }
}

//MARK: - ImagePickerControllerDelegate,UINavigationControllerDelegate
    extension ChatLogVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func touchToLoadImage() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleUpLoadTap))
        chatLogView.uploadImageView.addGestureRecognizer(tap)
    }
    
    @objc func handleUpLoadTap() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            selectedImageFromPicker = editedImage
        }
        
        if let selectedImage = selectedImageFromPicker {
            uploadToFirebaseStorageUsingImage(image: selectedImage)
        }
    }
    
    private func uploadToFirebaseStorageUsingImage(image: UIImage) {
        print("Upload to firebase")
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

