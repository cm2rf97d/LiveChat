//
//  TestViewController.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit
import Firebase
import FirebaseAuth

class ChatroomVC: UIViewController, presentChatViewDelegate
{
    // MARK: - Properties
    var chatroomView = ChatroomView()
    var chatRoomUserId: [String] = []  //Mike Add
    let chatroomSections: [ChatroomSections] = [.banner, .chatroom]
    let fullSizeWidth = UIScreen.main.bounds.width
    var timer = Timer()
    var currentPage = 0 {
        didSet{
            chatroomView.chatTableView.reloadData()
        }
    }
    var xOffset: CGFloat = 0 {
        didSet{
            chatroomView.chatTableView.reloadData()
        }
    }
    var friends: [String] = [] {
        didSet{
            chatroomView.chatTableView.reloadData()
        }
    }
    
    var friendInformations: [MarkUser] = []
    {
        didSet
        {
            chatroomView.chatTableView.reloadData()
        }
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view = chatroomView
        chatroomView.chatTableView.delegate = self
        chatroomView.chatTableView.dataSource = self
        setNavigation()
        setTimer()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getFriendList()
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Methods
    func setNavigation() {
        self.navigationItem.title = "聊天室"
        self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "plus.bubble")
//        let addFriendBTN = UIBarButtonItem(image: UIImage(systemName: "plus.message"), style: .plain, target: self, action: #selector(addNewFriend))
//        self.navigationItem.rightBarButtonItem = addFriendBTN
    }
    
    // Mike Add
    func presentChatView(account: MarkUser)
    {
//        chatRoomUserId.append(account)
        let vc = ChatLogVC()
        vc.chatName = account
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func getFriendList()
    {
        let downloadFriendList = Storage.storage().reference(withPath: "users/\(currentUserAccount)/friendList")
        
        downloadFriendList.getData(maxSize: 1 * 1024 * 1024)
        { (data, error) in
            if let error = error
            {
                print("Error: \(error.localizedDescription)")
            }
            else if let data = data
            {
                guard let friendArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return }
                if self.friends != friendArray {
                    self.friends = friendArray
                    self.getFriendInfo(friendMember: self.friends)
                        {(data) in self.friendInformations = data
                        print("out")
                        print("bbbbbb\(data)")
                    }
                }
                
            }
        }
        
    }
    
    func getFriendInfo(friendMember: [String], myData: @escaping ([MarkUser])->())
    {
        var downloadFriendAccount: StorageReference
        var downloadFriendUserId: StorageReference
        var downloadFriendUserImage: StorageReference
        var friendAccount: String = ""
        var friendUserId: String = ""
        var friendImage: UIImage?
        var friendMembers: [MarkUser] = []
        
        print("friendMember.count = \(friendMember.count)")
        for i in 0 ..< friendMember.count
        {
            print("123123123---------")
            downloadFriendAccount = Storage.storage().reference(withPath: "users/\(friendMember[i])/userAccount")
            downloadFriendUserId = Storage.storage().reference(withPath: "users/\(friendMember[i])/userID")
            downloadFriendUserImage = Storage.storage().reference(withPath: "users/\(friendMember[i])/profileImage.jpg")
            friendAccount = ""
            friendUserId = ""
            friendImage = UIImage()
            
            var markUser = MarkUser(userAccount: "", userID: "", userImage: UIImage(), friendsList: [])
            
            downloadFriendAccount.getData(maxSize: 1 * 1024 * 1024)
            { (data, error) in
                if let error = error
                {
                    print("Error: \(error.localizedDescription)")
                }
                else if let data = data
                {
                    friendAccount = String(decoding: data, as: UTF8.self)
                    print("ccccccccc\(data)")
                    markUser.userAccount = friendAccount
//                    friendMembers.append(MarkUser(userAccount: friendAccount, userID: "", userImage: UIImage(), friendsList: []))
//                    return myData([markUser])
                }
            }
            
                downloadFriendUserId.getData(maxSize: 1 * 1024 * 1024)
                { (data, error) in
                    if let error = error
                    {
                        print("Error: \(error.localizedDescription)")
                    }
                    else if let data = data
                    {
                        friendUserId = String(decoding: data, as: UTF8.self)
                        print("ccccccccc\(data)")
    //                    friendMembers.append(MarkUser(userAccount: friendAccount, userID: friendUserId, userImage: UIImage(), friendsList: []))
                        markUser.userID = friendUserId
                        
                        
                    }
                }
            
            
            downloadFriendUserImage.getData(maxSize: 1 * 1024 * 1024)
            { (data, error) in
                if let error = error
                {
                    print("Error: \(error.localizedDescription)")
                }
                else if let data = data
                {
                    if let friendImage = UIImage(data: data) {
                        print("ccccccccc\(data)")
                        markUser.userImage = friendImage
                        if markUser.userID == "" || markUser.userAccount == "" {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                friendMembers.append(markUser)
                                return myData(friendMembers)
                            }
                            
                        }else{
                            friendMembers.append(markUser)
                            return myData(friendMembers)
                        }

    //                    return myData([markUser])
                    }
                }
            }
            
            print("friendAccount = \(friendInformations)")
            print("friendUserId = \(friendUserId)")
//            friendMembers.append(MarkUser(userAccount: friendAccount, userID: friendUserId, userImage: UIImage(), friendsList: []))
            
        }
//        return myData(friendMembers)
    }
        
    func sendUserId(userId: FriendAccountUserId) {
        
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
    }
    
    @objc func changeBanner() {
        self.currentPage += 1
        if self.currentPage > 6 {
            self.currentPage = 0
        }
        xOffset = fullSizeWidth * CGFloat(self.currentPage)
    }
}

//MARK: - TableViewDataSource
extension ChatroomVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return chatroomSections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch chatroomSections[section] {
        case .banner:
            return 1
        case .chatroom:
            return friendInformations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch chatroomSections[indexPath.section] {
        case .banner:
            guard let cell = chatroomView.chatTableView.dequeueReusableCell(withIdentifier: ChatroomBannerCell.identifier, for: indexPath) as? ChatroomBannerCell else { return UITableViewCell()}
            cell.myScrollView.delegate = self
            UIView.animate(withDuration: 1, animations: {
                cell.myScrollView.contentOffset.x = self.xOffset
            }, completion: nil)
            cell.pageControl.currentPage = self.currentPage
            cell.tapPageControlAction = {
                self.changeBanner()
                self.timer.invalidate()
                self.setTimer()
            }
            
            return cell
        case .chatroom:
            let cell = chatroomView.chatTableView.dequeueReusableCell(withIdentifier: ChatroomTVCell.chatCellID, for: indexPath) as! ChatroomTVCell
            cell.chatPartnerNameLable.text = friendInformations[indexPath.row].userAccount
            cell.chatPartnerImage.image = friendInformations[indexPath.row].userImage
            cell.timeLabel.text = "時間time"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatLogVC()
        
        switch chatroomSections[indexPath.section] {
        case .banner:
            break
        case .chatroom:
            vc.chatName = friendInformations[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        tabBarController?.tabBar.isHidden = true
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch chatroomSections[indexPath.section]{
        case .banner:
            return 180
        case .chatroom:
            return 60
        }
    }
}

extension ChatroomVC: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        timer.invalidate()
    }

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        setTimer()
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if scrollView != chatroomView.chatTableView {
            let translatedPoint = scrollView.panGestureRecognizer.translation(in:scrollView)
            print(translatedPoint.x)
            if translatedPoint.x < 0 {
                changeBanner()
            }else{
                currentPage -= 1
                if currentPage < 0 {
                    currentPage = 6
                }
            }
            print(currentPage)
            xOffset = fullSizeWidth * CGFloat(self.currentPage)
        }
        

    }
    
}



//MARK: - Enum

//Sections

extension ChatroomVC {
    enum ChatroomSections {
        case banner, chatroom
    }
}

