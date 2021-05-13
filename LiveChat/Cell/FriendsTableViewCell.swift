//
//  FriendsTableViewCell.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/12.
//

import UIKit

class FriendsTableViewCell: UITableViewCell {

    static let identifier = "friendsTableViewCell"
    
    let friendsImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.backgroundColor = .clear
        imageView.layer.cornerRadius = 25
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let friendslabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(friendslabel)
        addSubview(friendsImageView)
        layouts()
//        self.backgroundColor = .clear
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layouts()
    {
        friendsImageView.snp.makeConstraints
        { (make) in
            make.width.height.equalTo(50)
            make.left.equalTo(20)
            make.centerY.equalTo(self)
        }
        
        friendslabel.snp.makeConstraints
        { (make) in
            make.left.equalTo(friendsImageView.snp.right).offset(10)
            make.width.equalTo(250)
            make.top.equalTo(self.snp.top).offset(+20)
            make.bottom.equalTo(self.snp.bottom).offset(-20)
        }
    }
}

