//
//  HomePageView.swift
//  LiveChat
//
//  Created by 董恩志 on 2021/4/6.
//

import UIKit
import SnapKit

class HomePageView: UIView {

    // MARK: - IBOutlets
    var chatTableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ChatTVCell.self, forCellReuseIdentifier: ChatTVCell.chatCellID)
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
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(chatTableView)
        autoLayoutForChatTableView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

