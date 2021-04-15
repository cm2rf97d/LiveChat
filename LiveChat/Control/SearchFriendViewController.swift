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
    var userId: String = ""
    var friendLists: [String] = []
    var userInfomations: [String] = []
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
            if userInfomations.contains(userAccount)
            {
                if friendLists.contains(userAccount)
                {
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
            }
            else
            {
                searchFriendView.friendLabel.text = "Not Exist Account"
                searchFriendView.friendLabel.setView(hidden: false)
            }
            searchFriendView.friendLabel.setView(hidden: false)
            
        }
    }
    
    @objc func addFriend()
    {
        let userGroup = Database.database().reference().child("Friend")
        let userGroupp = userGroup.child(self.userId)
        let userFriendInfo = userGroupp.childByAutoId()
        if let account = searchFriendView.friendLabel.text
        {
            let value = ["account": account] as [String : Any]
            userFriendInfo.updateChildValues(value)
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
        print("yyyyyyyyyyyy")
        dismiss(animated: true, completion: nil)
    }
    
    
    func animateStart()
    {
        
    }
    
    func loadUserInfo()
    {
        if let userID = Auth.auth().currentUser?.uid
        {
            self.userId = userID
        }
        
        let ref = Database.database().reference().child("userAccount")
        ref.observe(.childAdded)
        { (snapshot) in
            if let dictionary = snapshot.value as? [String: AnyObject]
            {
                if let text = dictionary["account"] as? String
                {
                    self.userInfomations.append(text)
                }
            }
        }
        
        let friendRef = Database.database().reference().child("Friend").child(self.userId)
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
    
    public func setView(hidden: Bool){
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
