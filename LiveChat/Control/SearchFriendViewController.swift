//
//  SearchFriendViewController.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/12.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
import Lottie
import FirebaseStorage

protocol SendFriendsList {
    func friendsListDelegate(account: MarkUser)
}

class SearchFriendViewController: UIViewController
{
    var changeViewDelegate: changeViewDelegate?
    var user: FriendAccountUserId?
    var friendLists: [MarkUser] = []
    var userInfomations: [String] = []
    {
        didSet
        {
            print(userInfomations)
        }
    }
    let searchFriendView = SearchFriendView()
    //Mark test:
    var markUser = MarkUser(userAccount: "", userID: "", userImage: UIImage(), friendsList: []) {
        didSet{
            print("yoooooo\(markUser)")
        }
    }
    var markFriends: [MarkUser] = []
    var userAccount: String = ""
    var friendsListDelegate: SendFriendsList?
    var userExist: UserExist = .yes
    var friendAccount: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setNavigation()
        searchFriendView.searchButtonAction = searchFriend
        print("My friends: \(userInfomations)")
        
    }
    
    override func loadView()
    {
        self.view = searchFriendView
    }
    
    func setNavigation()
    {
        self.navigationItem.title = "加入好友"
        let addFriendBTN = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .plain, target: self, action: #selector(dismissPage))
        self.navigationItem.rightBarButtonItem = addFriendBTN
    }
    
    @objc func dismissPage()
    {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Mark add:
    func downloadProfileImg(userAccount: String) {
        let downloadProfileImg = Storage.storage().reference(withPath: "users/\(userAccount)/profileImage.jpg")
        let downloadUserAccount = Storage.storage().reference(withPath: "users/\(userAccount)/userAccount")
        let downloadUserID = Storage.storage().reference(withPath: "users/\(userAccount)/userID")
        
        
        downloadProfileImg.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else if let data = data{
                if let image = UIImage(data: data){
                    self.markUser.userImage = image
                    self.searchFriendView.friendImageView.image = image
                }
            }
        }
        
        downloadUserAccount.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                self.userExist = .no
                print("Error: \(error.localizedDescription)")
            }else if let data = data{
                self.userExist = .yes
                self.markUser.userAccount = String(decoding: data, as: UTF8.self)
            }
        }
        
        downloadUserID.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                self.userExist = .no
                print("Error: \(error.localizedDescription)")
            }else if let data = data{
                self.userExist = .yes
                self.markUser.userID = String(decoding: data, as: UTF8.self)
            }
        }

        print("cmnelmnewklnk\(self.markUser)")
        
    }
    
    @objc func searchFriend()
    {
        if let userAccount = searchFriendView.searchTextField.text
        {
            downloadProfileImg(userAccount: userAccount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                if self.userExist == .yes {
                    self.getFriendList(friendAccount: currentUserAccount) { (data) in
                        self.markUser.friendsList = data
                        if self.markUser.friendsList.contains(userAccount){
                            self.searchFriendView.friendImageView.setView(hidden: false)
                            self.searchFriendView.addFriendButton.setView(hidden: false)
                            self.searchFriendView.addFriendButton.setTitle("Chat", for: .normal)
                            self.searchFriendView.friendLabel.text = userAccount
                            self.searchFriendView.addButtonAction = self.chatWithFriend
                            self.friendAccount = userAccount
                        }else{
                            self.userAccount = userAccount
                            self.downloadProfileImg(userAccount: userAccount)
                            self.searchFriendView.friendLabel.text = userAccount
                            self.searchFriendView.addFriendButton.setTitle("add", for: .normal)
                            self.searchFriendView.friendImageView.setView(hidden: false)
                            self.searchFriendView.addFriendButton.setView(hidden: false)
                            self.searchFriendView.addButtonAction = self.addFriend
                        }
                    }
                    
                }else{
                    self.searchFriendView.friendLabel.text = "Not Exist Account"
                    self.searchFriendView.friendLabel.setView(hidden: false)
                    self.searchFriendView.friendImageView.setView(hidden: true)
                    self.searchFriendView.addFriendButton.setView(hidden: true)
                }
            }
        }else{
            
        }
    }
    
    @objc func addFriend()
    {
        let storageProfileInfo =
            Storage.storage().reference(withPath: "users/\(currentUserAccount)/friendList")
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "friendList"
        
        if let account = self.searchFriendView.searchTextField.text
        {
            markUser.friendsList.append(account)
            guard let profileDetailData = try? JSONSerialization.data(withJSONObject: self.markUser.friendsList, options: []) else { return }
                storageProfileInfo.putData(profileDetailData, metadata: uploadMetaData)
                { (data, error) in
                    if let error = error
                    {
                        print("Error: \(error)")
                    }
                    else if let data = data
                    {
                        print(data)
                    }
                    self.friendsListDelegate?.friendsListDelegate(account: self.markUser)
                }
            
            let friendListInfo =
                Storage.storage().reference(withPath: "users/\(account)/friendList")
            var test: [String] = []
            getFriendList(friendAccount: account) { (data) in
                test = data
                print("eeeeeeeeee\(test)")
                test.append(currentUserAccount)
                guard let friendListData = try? JSONSerialization.data(withJSONObject: test, options: []) else { return }
                friendListInfo.putData(friendListData, metadata: uploadMetaData)
                { (data, error) in
                    if let error = error
                    {
                        print("Error: \(error)")
                    }
                    else if let data = data
                    {
                        print(data)
                    }
                }
            }
            print("test = \(test)")
        }
        
        self.presentLoadingVC()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2)
        {
            self.searchFriend()
            self.dismiss(animated: true, completion: nil)
            print("123123123")
        }
    }
    
    func getFriendList(friendAccount: String, completion: @escaping(([String])->()))
    {
        var returnFriendList: [String] = []
        let downloadFriendList = Storage.storage().reference(withPath: "users/\(friendAccount)/friendList")
        
        downloadFriendList.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                completion(returnFriendList)
            }else if let data = data{
                guard let friendArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return }
                returnFriendList = friendArray
                completion(returnFriendList)
            }
        }
        
    }
    
    @objc func chatWithFriend()
    {
        self.dismiss(animated: true)
        {
            print("ggggg\(self.markUser)")
            self.changeViewDelegate?.changeTabBarAndShowChatRoom(account: self.markUser)
        }
    }
    
    func friendConnection(friend: FriendAccountUserId, myInfo: String, userName: String)
    {
        let userGroup = Database.database().reference().child("Friend").child(friend.userID)
        let userFriendInfo = userGroup.childByAutoId()
        let values = ["account": userName,
                      "userID": myInfo] as [String : Any]
        userFriendInfo.updateChildValues(values)
    }
    
}

extension UIView {
    //畫線
    private func drawBorder(rect:CGRect,color:UIColor)
    {
        let line = UIBezierPath(rect: rect)
        let lineShape = CAShapeLayer()
        lineShape.path = line.cgPath
        lineShape.fillColor = color.cgColor
        self.layer.addSublayer(lineShape)
    }
    
    public func leftBorder(width:CGFloat,borderColor:UIColor)
    {
        let rect = CGRect(x: 0, y: 0, width: width, height: 42)
            drawBorder(rect: rect, color: borderColor)
    }
    
    public func setView(hidden: Bool)
    {
        UIView.transition(with: self, duration: 0.5, options: .transitionCrossDissolve, animations:{
            self.isHidden = hidden
        })
    }
}

extension UIViewController
{
    func presentLoadingVC()
    {
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        present(loadingVC, animated: true, completion: nil)
    }
}

extension SearchFriendViewController {
    enum UserExist {
        case yes, no
    }
}

