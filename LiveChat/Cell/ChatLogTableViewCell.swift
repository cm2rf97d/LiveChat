//
//  ChatLogTableViewCell.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/8.
//

import UIKit

class ChatLogTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "ChatLogCell"
    let chatLogView = ChatLogView()
    
    //MARK: - IBOutlets
    
    let myTextlabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .white
//        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    let yourTextlabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        label.textColor = .black
//        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    let mybubleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 15
        return view
    }()
    
    let yourbubleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    var yourID: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    var yourProfileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        return image
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(mybubleView)
        addSubview(yourbubleView)
        backgroundColor = .clear
        addSubview(myTextlabel)
        addSubview(yourTextlabel)
        addSubview(yourID)
        addSubview(yourProfileImage)
        layouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set Layouts
    
    func layouts() {
        myTextlabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-32)
            make.top.equalTo(self).offset(32)
            make.bottom.equalTo(self).offset(-32)
            make.width.lessThanOrEqualTo(250)
        }
        
        yourTextlabel.snp.makeConstraints { (make) in
//            make.left.equalTo(self).offset(32)
//            make.top.equalTo(self).offset(32)
            make.left.equalTo(yourID).offset(10)
            make.top.equalTo(yourID.snp.bottom).offset(17)
            make.bottom.equalTo(self).offset(-32)
            make.width.lessThanOrEqualTo(250)
        }
        
        yourID.snp.makeConstraints { (make) in
            make.left.equalTo(yourProfileImage.snp.right).offset(5)
            make.top.equalTo(self.snp.top)
            make.height.equalTo(30)
            make.width.equalTo(250)
        }
        
        yourProfileImage.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(+8)
            make.top.equalTo(self).offset(+2)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
            
        mybubleView.snp.makeConstraints { (make) in
            make.right.equalTo(myTextlabel).offset(10)
            make.top.equalTo(myTextlabel).offset(-10)
            make.bottom.equalTo(myTextlabel).offset(10)
            make.left.equalTo(myTextlabel).offset(-10)
        }
        
        yourbubleView.snp.makeConstraints { (make) in
            make.right.equalTo(yourTextlabel).offset(10)
            make.top.equalTo(yourTextlabel).offset(-10)
            make.bottom.equalTo(yourTextlabel).offset(10)
            make.left.equalTo(yourTextlabel).offset(-10)
        }
    }
    
}

