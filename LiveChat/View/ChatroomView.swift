//
//  TestView.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit

class ChatroomView: UIView
{
    // MARK: - IBOutlets
        var chatTableView: UITableView = {
            let tableView = UITableView(frame: CGRect(), style: .plain)
            tableView.register(ChatroomTVCell.self, forCellReuseIdentifier: ChatroomTVCell.chatCellID)
            tableView.register(ChatroomBannerCell.self, forCellReuseIdentifier: ChatroomBannerCell.identifier)
            tableView.rowHeight = 60
            
            return tableView
        }()
        
        // MARK: - Autolayout
        func autoLayoutForChatTableView() {
            chatTableView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
                make.centerY.equalTo(self)
                make.width.equalTo(self)
                make.height.equalTo(self)
            }
        }
    
    // MARK: - Init
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(chatTableView)
        autoLayoutForChatTableView()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
}
