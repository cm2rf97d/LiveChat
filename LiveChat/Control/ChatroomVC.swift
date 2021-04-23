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
    var chatRoomUserId: [FriendAccountUserId] = []  //Mike Add
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
    var friends: [FriendAccountUserId] = [] {
        didSet{
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
        getFriendList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tabBarController?.tabBar.isHidden = false
    }
    
    // MARK: - Methods
    func setNavigation() {
        self.navigationItem.title = "聊天室"
        self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "plus.bubble")
        let addFriendBTN = UIBarButtonItem(image: UIImage(systemName: "plus.message"), style: .plain, target: self, action: #selector(addNewFriend))
        self.navigationItem.rightBarButtonItem = addFriendBTN
    }
    
    // Mike Add
    func presentChatView(account: FriendAccountUserId)
    {
        chatRoomUserId.append(account)
        let vc = ChatLogVC()
        vc.chatName = account
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // Mike Add
    @objc func addNewFriend() {
        
    }
    
    func getFriendList(){
        
        let userID = Auth.auth().currentUser?.uid
        if let userID = userID{
            let friend = Database.database().reference().child("Friend").child(userID)
            
            friend.observe(.childAdded){ (snapshot) in
                if let dictionary = snapshot.value as? [String: AnyObject]{
                    if let account = dictionary["account"] as? String,
                       let userId  = dictionary["userID"]  as? String{
                        self.friends.append(FriendAccountUserId(userAccount: account, userID: userId))
                    }
                }
            }
        }
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
            return friends.count
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
            cell.chatPartnerNameLable.text = friends[indexPath.row].userAccount
            cell.chatPartnerImage.image = UIImage(systemName: "pin")
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
            vc.chatName = friends[indexPath.row]
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



//MARK: - Enum

//Sections

extension ChatroomVC {
    enum ChatroomSections {
        case banner, chatroom
    }
}
