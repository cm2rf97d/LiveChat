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
        let tableView = UITableView(frame: CGRect(), style: .insetGrouped)
        tableView.register(FriendsTableViewCell.self, forCellReuseIdentifier: FriendsTableViewCell.identifier)
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.rowHeight = UITableView.automaticDimension
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(friendsTableView)
        layouts()
        setGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layouts()
    {
        friendsTableView.snp.makeConstraints
        { (make) in
            make.width.equalTo(UIScreen.main.bounds.width)
//            make.height.equalTo(UIScreen.main.bounds.height)
            make.centerX.equalTo(self)
//            make.centerY.equalTo(self)
            make.top.equalTo(self.snp.topMargin)
            make.bottom.equalTo(self.snp.bottomMargin)
        }
    }
    
}

