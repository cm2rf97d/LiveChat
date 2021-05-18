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
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        return label
    }()
    
    var chatPartnerImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 25
        image.backgroundColor = .clear
        image.clipsToBounds = true
        return image
    }()
    
    var timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    var messagelabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = #colorLiteral(red: 0.2549019754, green: 0.2745098174, blue: 0.3019607961, alpha: 1)
        return label
    }()
    
    lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [chatPartnerNameLable,messagelabel])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        return stackView
    }()
    
    // MARK: - Autolayout
    func setLayout() {
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(self).offset(5)
            make.bottom.equalTo(self).offset(-5)
            make.left.equalTo(chatPartnerImage.snp.right).offset(5)
            make.right.equalTo(timeLabel.snp.left).offset(-5)
        }
        
        chatPartnerImage.snp.makeConstraints { (make) in
            make.width.height.equalTo(50)
            //                make.top.equalTo(self)
            //                make.bottom.equalTo(self)
            make.centerY.equalTo(self)
            make.left.equalTo(self).offset(8)
        }
        
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
        addSubview(stackView)
        addSubview(chatPartnerImage)
        addSubview(timeLabel)
        setLayout()
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

