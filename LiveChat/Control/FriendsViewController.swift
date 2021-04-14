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

class FriendsViewController: UIViewController
{
    let friendView = FriendsView()
    var friends: [String] = []
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
        print("ASD")
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID
        {
            let friend = Database.database().reference().child("Friend")
            let myFriend = friend.child(userID)
            
            myFriend.observe(.childAdded)
            { (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]
                {
                    if let account = dictionary["account"] as? String
                    {
                        self.friends.append(account)
                        print("ZZ")
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
        let nvVC = UINavigationController(rootViewController: vc)
        present(nvVC, animated: true, completion: nil)
    }
}

extension FriendsViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        print("friends.count = \(friends.count)")
        return friends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:FriendsTableViewCell.identifier, for: indexPath) as? FriendsTableViewCell else { return UITableViewCell() }
        cell.friendslabel.text = friends[indexPath.row]
        print(friends[indexPath.row])
        
        return cell
    }
}
