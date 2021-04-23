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

class SearchFriendViewController: UIViewController
{
    var changeViewDelegate: changeViewDelegate?
    var user: FriendAccountUserId?
    var friendLists: [String] = []
    var userInfomations: [FriendAccountUserId] = []
    let searchFriendView = SearchFriendView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setNavigation()
        loadUserInfo()
        searchFriendView.searchButtonAction = searchFriend
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
    
    @objc func searchFriend()
    {
        if let userAccount = searchFriendView.searchTextField.text
        {
//            if userInfomations.contains(where: { $0.userAccount == userAccount})
            for i in 0..<userInfomations.count
            {
                if userInfomations[i].userAccount == userAccount
                {
                    if friendLists.contains(userAccount)
                    {
                        self.user = userInfomations[i]
                        searchFriendView.addFriendButton.setTitle("聊天", for: .normal)
                        searchFriendView.addButtonAction = chatWithFriend
                    }
                    else
                    {
                        searchFriendView.addFriendButton.setTitle("加入", for: .normal)
                        searchFriendView.addButtonAction = addFriend
                    }
                    searchFriendView.friendLabel.text = userAccount
                    searchFriendView.friendImageView.setView(hidden: false)
                    searchFriendView.addFriendButton.setView(hidden: false)
                    break
                }
                else
                {
                    searchFriendView.friendLabel.text = "Not Exist Account"
                    searchFriendView.friendLabel.setView(hidden: false)
                    searchFriendView.friendImageView.setView(hidden: true)
                    searchFriendView.addFriendButton.setView(hidden: true)
                }
            }
            searchFriendView.friendLabel.setView(hidden: false)
        }
    }
    
    @objc func addFriend()
    {
        let userGroup = Database.database().reference().child("Friend").child(currentUserId)
        let userFriendInfo = userGroup.childByAutoId()
        if let account = searchFriendView.friendLabel.text
        {
            for i in 0..<userInfomations.count
            {
                if userInfomations[i].userAccount == account
                {
                    let values = ["account": userInfomations[i].userAccount,
                                  "userID": userInfomations[i].userID] as [String : Any]
                    userFriendInfo.updateChildValues(values)
                    let userName =
                    { () -> String in
                        for i in 0..<self.userInfomations.count
                        {
                            if self.userInfomations[i].userID == currentUserId
                            {
                                let test = self.userInfomations[i].userAccount
                                print("test = \(test)")
                                return test
                            }
                        }
                        return ""
                    }
                    friendConnection(friend: userInfomations[i], myInfo: currentUserId, userName: userName())
                    break
                }
            }
            
        }
        self.presentLoadingVC()
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2)
        {
            self.searchFriend()
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc func chatWithFriend()
    {
        self.dismiss(animated: true)
        {
            if let user = self.user
            {
                self.changeViewDelegate?.changeTabBarAndShowChatRoom(account: user)
            }
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
    
    func loadUserInfo()
    {
        
        let ref = Database.database().reference().child("userAccount")
        ref.observe(.childAdded)
        { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                if let account = dictionary["account"] as? String,
                   let userId  = dictionary["userID"]  as? String
                {
                    self.userInfomations.append(FriendAccountUserId(userAccount: account, userID: userId))
                }
            }
        }
        
        let friendRef = Database.database().reference().child("Friend").child(currentUserId)
        friendRef.observe(.childAdded)
        {
            (snapshot) in
            if let friend = snapshot.value as? [String: AnyObject]
            {
                if let text = friend["account"] as? String
                {
                    self.friendLists.append(text)
                }
            }
        }
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
