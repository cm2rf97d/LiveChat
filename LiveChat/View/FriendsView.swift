//
//  FriendsView.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/9.
//

import UIKit

class FriendsView: UIView {

    let friendsTableView: UITableView =
    {
        let tableView = UITableView()
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .systemGray2
        tableView.rowHeight = 50
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(friendsTableView)
        layouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layouts()
    {
        friendsTableView.snp.makeConstraints
        { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
            make.height.equalTo(UIScreen.main.bounds.height)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
}
