//
//  TestViewController.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit

class ChatroomVC: UIViewController
{
    // MARK: - Properties
    var chatroomView = ChatroomView()
    var tests = ["1","2","3","4","5"]
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
        
        tabBarController?.tabBar.isHidden = false
    }
    
    
    // MARK: - Methods
    func setNavigation() {
        self.navigationItem.title = "聊天室"
        self.navigationItem.leftBarButtonItem?.image = UIImage(systemName: "plus.bubble")
        let addFriendBTN = UIBarButtonItem(image: UIImage(systemName: "plus.message"), style: .plain, target: self, action: #selector(addNewFriend))
        self.navigationItem.rightBarButtonItem = addFriendBTN
    }
    
    @objc func addNewFriend() {
        
    }
    
    func setTimer() {
        timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(changeBanner), userInfo: nil, repeats: true)
    }
    
    func addCurrentPage() {
        self.currentPage += 1
        if self.currentPage > 2 {
            self.currentPage = 0
        }
    }
    
    @objc func changeBanner() {
        addCurrentPage()
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
            return tests.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch chatroomSections[indexPath.section] {
        case .banner:
            guard let cell = chatroomView.chatTableView.dequeueReusableCell(withIdentifier: ChatroomBannerCell.identifier, for: indexPath) as? ChatroomBannerCell else { return UITableViewCell()}
            cell.myScrollView.delegate = self
            cell.myScrollView.contentOffset.x = xOffset
            cell.pageControl.currentPage = self.currentPage
            cell.tapPageControlAction = {

                self.addCurrentPage()
                self.xOffset = self.fullSizeWidth * CGFloat(self.currentPage)
                self.timer.invalidate()
                self.setTimer()
            }
            
            
            return cell
        case .chatroom:
            let cell = chatroomView.chatTableView.dequeueReusableCell(withIdentifier: ChatroomTVCell.chatCellID, for: indexPath) as! ChatroomTVCell
            cell.chatPartnerNameLable.text = tests[indexPath.row]
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
            vc.chatName = tests[indexPath.row]
            navigationController?.pushViewController(vc, animated: true)
        }
        
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
        
        if translatedPoint.x < 0 {
            addCurrentPage()
        }else{
            currentPage -= 1
            if currentPage < 0 {
                currentPage = 2
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
