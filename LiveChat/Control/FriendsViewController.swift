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
    func presentChatView(account: MarkUser)
    func sendUserId(userId: FriendAccountUserId)
}

class FriendsViewController: UIViewController
{
    var presentChatViewDelegate: presentChatViewDelegate?
    let friendView = FriendsView()
    var markUser = MarkUser(userAccount: "", userID: "", userImage: UIImage(), friendsList: []) {
        didSet{
            print("Mike Test = \(markUser)")
            friendView.friendsTableView.reloadData()
        }
    }
    var markFriends: [MarkUser] = [] {
        didSet{
            friendView.friendsTableView.reloadData()
        }
    }
    var friendsProfileImg: [UIImage] = [] {
        didSet{
            friendView.friendsTableView.reloadData()
            print("bbbbb\(self.friendsProfileImg)")
        }
    }
    var friends: [String] = []
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        friendView.friendsTableView.delegate = self
        friendView.friendsTableView.dataSource = self
        setNavigation()
        getFriendList()
        
        //        let friends = markFriends.map({$0.friendsList.map({$0.})})
        
        markUser.userID = currentUserId
    }
    
    override func loadView()
    {
        self.view = friendView
    }
    
    func getFriendList()
    {
        let downloadFriendList = Storage.storage().reference(withPath: "users/\(currentUserAccount)/friendList")
        
        downloadFriendList.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else if let data = data{
                guard let friendArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return }
                self.markUser.friendsList = friendArray
                self.friends = friendArray
                self.getFriendInfo(friendMember: self.friends) { (data) in
                    self.markFriends = data
                }
                //                var friendUser = MarkUser(userAccount: "", userID: "", userImage: UIImage(named: "defaultImg")!, friendsList: [])
                
                //                for i in friendArray
                //                {
                //                    self.getFriendsImg(name: i)
                //                    friendUser.userAccount = i
                //                    friendUser.userImage = self.getFriendsImg(name: i)
                //                    self.markFriends.append(friendUser)
                //                }
            }
        }
    }
    
    //    func getFriendsImg(name: String) -> UIImage{
    ////        for name in array{
    //            print("name: ")
    //            let downloadProfileImage = Storage.storage().reference(withPath: "users/\(name)/profileImage.jpg")
    //        var friendImage: UIImage?
    //            downloadProfileImage.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
    //                if let error = error {
    //                    self.friendsProfileImg.append(UIImage())
    //                    print("Error: \(error.localizedDescription)")
    //                }else if let data = data {
    //                    if let image = UIImage(data: data) {
    ////                        self.friendsProfileImg.append(image)
    //                        friendImage = image
    //                    }
    //                }
    //            }
    //        return friendImage //?? UIImage(named: "defaultImg")!
    ////        }
    //    }
    
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
        vc.markUser.friendsList = markUser.friendsList
        vc.friendsListDelegate = self
        let nvVC = UINavigationController(rootViewController: vc)
        present(nvVC, animated: true, completion: nil)
    }
}

extension FriendsViewController: UITableViewDelegate,UITableViewDataSource
{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        //        return markUser.friendsList.count
        return markFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        guard let cell = tableView.dequeueReusableCell(withIdentifier:FriendsTableViewCell.identifier, for: indexPath) as? FriendsTableViewCell else { return UITableViewCell() }
        //        cell.friendslabel.text = markUser.friendsList[indexPath.row]
        cell.friendslabel.text = markFriends[indexPath.row].userAccount
        cell.friendsImageView.image = markFriends[indexPath.row].userImage
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        let vc = ProfileViewController()
        vc.changeViewDelegate = self
        vc.friendAccount = markUser.friendsList[indexPath.row]
        present(vc, animated: true, completion: nil)
    }
}

extension FriendsViewController: changeViewDelegate
{
    func changeTabBarAndShowChatRoom(account: MarkUser)
    {
        self.tabBarController?.selectedIndex = 0
        presentChatViewDelegate?.presentChatView(account: account)
        self.tabBarController?.tabBar.isHidden = true
    }
}

extension FriendsViewController: SendFriendsList {
    func friendsListDelegate(account: MarkUser) {
        markFriends.append(account)
        self.markUser = account
    }
    
    
}

