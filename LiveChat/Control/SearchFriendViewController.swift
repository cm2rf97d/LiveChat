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

class SearchFriendViewController: UIViewController
{
    let searchFriendView = SearchFriendView()
    var userInfomations: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        setNavigation()
        loadUserInfo()
        searchFriendView.searchButtonAction = searchFriend
        searchFriendView.addButtonAction = addFriend
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
            searchFriendView.searchTextField.text = ""
        }
    }
    
    @objc func addFriend()
    {
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID
        {
            print("userID = \(userID)")
            let userGroup = Database.database().reference().child("Friend")
            let userGroupp = userGroup.child(userID)
            let userFriendInfo = userGroupp.childByAutoId()
            if let account = searchFriendView.friendLabel.text
            {
                let value = ["account": account] as [String : Any]
                userFriendInfo.updateChildValues(value)
            }
        }
    }
    
    func loadUserInfo()
    {
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
