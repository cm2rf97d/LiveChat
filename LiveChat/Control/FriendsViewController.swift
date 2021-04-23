//
//  FriendsViewController.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/9.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

protocol presentChatViewDelegate
{
    func presentChatView(account: FriendAccountUserId)
    func sendUserId(userId: FriendAccountUserId)
}

class FriendsViewController: UIViewController
{
    var presentChatViewDelegate: presentChatViewDelegate?
    let friendView = FriendsView()
    var friends: [FriendAccountUserId] = []
    {
        didSet
        {
            friendView.friendsTableView.reloadData()
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        friendView.friendsTableView.delegate = self
        friendView.friendsTableView.dataSource = self
        setNavigation()
        getFriendList()
    }
    
    override func loadView()
    {
        self.view = friendView
    }
    
    func getFriendList()
    {
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID
        {
            let friend = Database.database().reference().child("Friend").child(userID)
            
            friend.observe(.childAdded)
            { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    if let account = dictionary["account"] as? String,
                       let userId  = dictionary["userID"]  as? String
                    {
                        self.friends.append(FriendAccountUserId(userAccount: account, userID: userId))
                    }
                }
            }
        }
    }
    
    func setNavigation()
    {
        self.navigationItem.title = "好友"
        let addFriendBTN = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addNewFriend))
        self.navigationItem.rightBarButtonItem = addFriendBTN
    }
    
    @objc func addNewFriend()
    {
        let vc = SearchFriendViewController()
        vc.changeViewDelegate = self
        let nvVC = UINavigationController(rootViewController: vc)
        present(nvVC, animated: true, completion: nil)
    }
}

extension FriendsViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:FriendsTableViewCell.identifier, for: indexPath) as? FriendsTableViewCell else { return UITableViewCell() }
        cell.friendslabel.text = friends[indexPath.row].userAccount
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = ProfileViewController()
        vc.changeViewDelegate = self
        vc.friendInfomation = friends[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}

extension FriendsViewController: changeViewDelegate
{
    func changeTabBar(account: FriendAccountUserId)
    {
        self.tabBarController?.selectedIndex = 0
        presentChatViewDelegate?.presentChatView(account: account)
    }
}
