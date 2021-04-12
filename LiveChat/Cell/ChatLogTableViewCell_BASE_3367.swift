//
//  ChatLogTableViewCell.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/8.
//

import UIKit

class ChatLogTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "ChatLogCel"
    
    //MARK: - IBOutlets
    
    let myTextlabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let yourTextlabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(myTextlabel)
        addSubview(yourTextlabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set Layouts
    
    override func layoutSubviews() {
        myTextlabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-8)
            make.centerY.height.equalTo(self)
            make.width.equalTo(300)
        }
        
        yourTextlabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(+8)
            make.centerY.height.equalTo(self)
            make.width.equalTo(300)
        }
        
    }
    

}
