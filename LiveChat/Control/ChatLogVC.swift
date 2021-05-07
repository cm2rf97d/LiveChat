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
    let chatLogCell = ChatLogUserCell()
    var messages = [String]() {
        didSet{
            chatLogView.chatLogTableView.reloadData()
            //            scrollToBottom()
            //            chatLogView.myTableView.scrollTo(direction: .bottom)
        }
    }
    
    var userIDs = [String]()
    var userID: String?
    var message = Messages()
    var times = [String]()
    var types = [String]()
    
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
        let type = "text"
        if let chatName = chatName{
            let ref = Database.database().reference().child("ChatRoom").child(currentUserId).child(chatName.userID)
            let childRef = ref.childByAutoId()
            if let text = chatLogView.inputTextField.text {
                let values = ["id": userID!,
                              "text": text,
                              "time": timeStamp,
                              "type": type] as [String : Any]
                childRef.updateChildValues(values)
//                friendChatRecordUpload(chatName: chatName.userID,text: text, time: timeStamp,type: type)
                
            }
            chatLogView.inputTextField.text = ""
        }
    }
    
//    func friendChatRecordUpload(chatName: String, text: String, time: TimeInterval, type: String)
//    {
//        let ref = Database.database().reference().child("ChatRoom").child(chatName).child(currentUserId)
//        let childRef = ref.childByAutoId()
//        let type = type
//        let values = ["id": userID!,
//                      "text": text,
//                      "time": time,
//                      "type": type] as [String : Any]
//        childRef.updateChildValues(values)
//    }
    
    func observeMsg() {
        guard let chatName = chatName else {return}
        let ref = Database.database().reference().child("ChatRoom").child(currentUserId).child(chatName.userID)
        ref.observe(.childAdded) { (snapshot) in
            
            if let dictionary = snapshot.value as? [String: AnyObject] {
                
                if let id = dictionary["id"] as? String,
                   let text = dictionary["text"] as? String,
                   let time = dictionary["time"] as? TimeInterval,
                   let type = dictionary["type"] as? String
                {
                    
                    //                    self.message.text?.insert(text, at: 0)
                    self.messages.insert(text, at: 0)
                    //                    self.userIDs.append(id)
                    self.userIDs.insert(id, at: 0)
                    
                    let timeInterval = TimeInterval(time)
                    let date = Date(timeIntervalSince1970: timeInterval)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm"
                    let alarmTime = formatter.string(from: date)
                    
                    self.times.insert(alarmTime, at: 0)
                    
                    self.types.insert(type, at: 0)
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
        
        let defaultCell = UITableViewCell()
//        //cell 無法被點選
//        cell.selectionStyle = .none
        //防止cell重用
        //        cell.yourID.text = nil
        //        cell.yourProfileImage.backgroundColor = nil
//        //cell 顛倒
//        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        if userID == userIDs[indexPath.row] {
            
            guard let cell = tableView.dequeueReusableCell(withIdentifier:ChatLogUserCell.identifier, for: indexPath) as? ChatLogUserCell else {return defaultCell}
            //cell 無法被點選
            cell.selectionStyle = .none
            //cell 顛倒
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            cell.myImageView.image = nil
            
            if types[indexPath.row] == "image" {
//                cell?.mybubleView.isHidden = true
//                cell?.myTextlabel.isHidden = true
                cell.myImageView.setImage(url: URL(string: messages[indexPath.row])!)
                cell.myTextlabel.text = messages[indexPath.row]
                cell.mytimelabel.text = times[indexPath.row]
                cell.myTextlabel.textColor = .clear
                cell.mybubleView.backgroundColor = .clear
                return cell
            }

//            cell?.mybubleView.isHidden = false
//            cell?.myTextlabel.isHidden = false
            cell.mybubleView.backgroundColor = .systemBlue
            cell.myTextlabel.text = messages[indexPath.row]
            cell.mytimelabel.text = times[indexPath.row]
            
            return cell
        }else{
            guard let cell = tableView.dequeueReusableCell(withIdentifier:ChatLogOtherPersonCell.identifier, for: indexPath) as? ChatLogOtherPersonCell else {return defaultCell}
            
            //cell 無法被點選
            cell.selectionStyle = .none
            //cell 顛倒
            cell.transform = CGAffineTransform(scaleX: 1, y: -1)
            
            cell.yourImageView.image = nil

            if types[indexPath.row] == "image" {
//                cell?.yourbubleView.isHidden = true
//                cell?.yourTextlabel.isHidden = true
                cell.yourImageView.setImage(url: URL(string: messages[indexPath.row])!)
                cell.yourTextlabel.text = messages[indexPath.row]
                cell.yourtimelabel.text = times[indexPath.row]
                cell.yourID.text = userIDs[indexPath.row]
                cell.yourProfileImage.backgroundColor = .systemBlue
                cell.yourTextlabel.textColor = .clear
                cell.yourbubleView.backgroundColor = .clear
                return cell
            }
            
//            cell?.yourbubleView.isHidden = false
//            cell?.yourTextlabel.isHidden = false
            cell.yourID.text = userIDs[indexPath.row]
            cell.yourProfileImage.backgroundColor = .systemBlue
            cell.yourTextlabel.text = messages[indexPath.row]
            cell.yourtimelabel.text = times[indexPath.row]
            
            return cell
        }
        
        return defaultCell
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
        
        let imageName = UUID().uuidString
        let ref = Storage.storage().reference()
            .child("message_images")
            .child(imageName)
        
        if let uploadData = image.jpegData(compressionQuality: 0.2) {
            ref.putData(uploadData, metadata: nil) { (metadata, error) in
                guard metadata != nil else {
                    print("Failed to upload image")
                    return
                }
                
                ref.downloadURL(completion: { (url, error) in
                    guard let downloadURL = url else { return }
                    let downloadURLString = downloadURL.absoluteString
                    self.sendMessageWithImageUrl(imageUrl: downloadURLString)
                })
                
            }
        }
        
        print("Upload to firebase")
        dismiss(animated: true, completion: nil)
    }
    
    func sendMessageWithImageUrl(imageUrl: String) {
        let timeStamp = NSDate().timeIntervalSince1970
//        let ref = Database.database().reference().child("\(chatName)")
//        let childRef = ref.childByAutoId()
        
        if let chatName = chatName{

            let ref = Database.database().reference().child("ChatRoom").child(currentUserId).child(chatName.userID)
            let childRef = ref.childByAutoId()
            let type = "image"
            let values = ["id": userID!,
                          "text": imageUrl,
                          "time": timeStamp,
                          "type": type] as [String : Any]
            
            childRef.updateChildValues(values)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
}

