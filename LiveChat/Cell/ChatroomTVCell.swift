//
//  ChatroomTVCell.swift
//  LiveChat
//
//  Created by 董恩志 on 2021/4/7.
//

import UIKit

class ChatroomTVCell: UITableViewCell {
    
    static let chatCellID = "Cell"
        
        // MARK: - IBOutlets
        let chatPartnerNameLable: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 18)
//            label.backgroundColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            return label
        }()
        
        var chatPartnerImage: UIImageView = {
            let image = UIImageView()
//            image.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
            image.layer.cornerRadius = 15
            image.backgroundColor = .clear
            image.clipsToBounds = true
            return image
        }()
        
        var timeLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
//            label.backgroundColor = #colorLiteral(red: 0.3411764801, green: 0.6235294342, blue: 0.1686274558, alpha: 1)
            label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            label.textAlignment = NSTextAlignment.center
            return label
        }()
        
        // MARK: - Autolayout
        func setLayoutForChatPartnerName() {
            chatPartnerNameLable.snp.makeConstraints { (make) in
                make.top.equalTo(self)
                make.bottom.equalTo(self)
                make.left.equalTo(chatPartnerImage.snp.right).offset(5)
                make.right.equalTo(timeLabel.snp.left).offset(-5)
            }
        }
        
        func setLayoutForChatPartnerImage() {
            chatPartnerImage.snp.makeConstraints { (make) in
                make.width.equalTo(self).multipliedBy(0.15)
                make.top.equalTo(self)
                make.bottom.equalTo(self)
                make.left.equalTo(self)
            }
        }
        
        func setLayoutForTimeLabel() {
            timeLabel.snp.makeConstraints { (make) in
                make.width.equalTo(self).multipliedBy(0.15)
                make.top.equalTo(self)
                make.bottom.equalTo(self)
                make.right.equalTo(self)
            }
        }
        
        // MARK: - Init
        
        override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
            super.init(style: style, reuseIdentifier: reuseIdentifier)
            addSubview(chatPartnerNameLable)
            addSubview(chatPartnerImage)
            addSubview(timeLabel)
            setLayoutForChatPartnerImage()
            setLayoutForTimeLabel()
            setLayoutForChatPartnerName()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

}

