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
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        view = chatroomView
        chatroomView.chatTableView.delegate = self
        chatroomView.chatTableView.dataSource = self
        setNavigation()
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
    
}
//MARK: - TableViewDataSource
extension ChatroomVC : UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = chatroomView.chatTableView.dequeueReusableCell(withIdentifier: ChatroomTVCell.chatCellID, for: indexPath) as! ChatroomTVCell
        cell.chatPartnerNameLable.text = tests[indexPath.row]
        cell.chatPartnerImage.image = UIImage(systemName: "pin")
        cell.timeLabel.text = "時間time"
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = ChatLogVC()
        vc.chatName = tests[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
    
}
