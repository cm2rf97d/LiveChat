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
        imageView.backgroundColor = .systemBlue
        return imageView
    }()
    
    let friendslabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?)
    {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(friendslabel)
        addSubview(friendsImageView)
        layouts()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layouts()
    {
        friendsImageView.snp.makeConstraints
        { (make) in
            make.width.equalTo(50)
            make.height.equalTo(40)
            make.left.equalTo(20)
            make.centerY.equalTo(self)
        }
        
        friendslabel.snp.makeConstraints
        { (make) in
            make.centerY.equalTo(self)
            make.left.equalTo(friendsImageView.snp.right).offset(10)
            make.width.equalTo(200)
            make.height.equalTo(40)
        }
    }
}
