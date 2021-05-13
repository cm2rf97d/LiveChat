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
//        setTimer()
        
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
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
//        self.navigationController?.navigationBar.isTranslucent = true
//        self.navigationController?.navigationBar.barTintColor = .clear
//        self.navigationController?.navigationBar
        
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
        
    func sendUserId(userId: FriendAccountUserId) {
        
    }
    
//    func setTimer() {
//        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
//    }
    
//    @objc func changeBanner() {
//        self.currentPage += 1
//        if self.currentPage > 6 {
//            self.currentPage = 0
//        }
//        xOffset = fullSizeWidth * CGFloat(self.currentPage)
//    }
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
            cell.friendsImages = self.friendInformations
            
            return cell
        case .chatroom:
            let cell = chatroomView.chatTableView.dequeueReusableCell(withIdentifier: ChatroomTVCell.chatCellID, for: indexPath) as! ChatroomTVCell
            cell.chatPartnerNameLable.text = friendInformations[indexPath.row].userAccount
            cell.chatPartnerImage.image = friendInformations[indexPath.row].userImage
            cell.timeLabel.text = "時間time"
            cell.backgroundColor = .clear
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
            tabBarController?.tabBar.isHidden = true
            navigationController?.pushViewController(vc, animated: true)   
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch chatroomSections[indexPath.section]{
        case .banner:
            return 100
        case .chatroom:
            return 60
        }
    }
}

//extension ChatroomVC: UIScrollViewDelegate {
//    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
//
//        timer.invalidate()
//    }
//
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        setTimer()
//
//    }
//
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//
//        if scrollView != chatroomView.chatTableView {
//            let translatedPoint = scrollView.panGestureRecognizer.translation(in:scrollView)
//            print(translatedPoint.x)
//            if translatedPoint.x < 0 {
//                changeBanner()
//            }else{
//                currentPage -= 1
//                if currentPage < 0 {
//                    currentPage = 6
//                }
//            }
//            print(currentPage)
//            xOffset = fullSizeWidth * CGFloat(self.currentPage)
//        }
//
//
//    }
//
//}



//MARK: - Enum

//Sections

extension ChatroomVC {
    enum ChatroomSections {
        case banner, chatroom
    }
}



