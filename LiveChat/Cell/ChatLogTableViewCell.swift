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
    
    var isIncoming: Bool! {
        didSet {
            bubleView.backgroundColor = isIncoming ? .white : .systemBlue
            myTextlabel.textColor = isIncoming ? .black : .white
            myTextlabel.snp.remakeConstraints { (make) in
                isIncoming ? make.left.equalTo(self).offset(32) :make.right.equalTo(self).offset(-32)
                make.top.equalTo(self).offset(32)
                make.bottom.equalTo(self).offset(-32)
                make.width.lessThanOrEqualTo(250)
            }
        }
    }
    //MARK: - IBOutlets
    
    let myTextlabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 30)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        label.font = UIFont.systemFont(ofSize: 20)
        return label
    }()
    
    let yourTextlabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 30)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    let yourID: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    let yourProfileImage: UIImageView = {
        let image = UIImageView()
        image.layer.cornerRadius = 15
        image.backgroundColor = .systemBlue
        return image
    }()
    
    let bubleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 20
        return view
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(bubleView)
        addSubview(myTextlabel)
        addSubview(yourTextlabel)
        addSubview(yourID)
        addSubview(yourProfileImage)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set Layouts

    func setLayout() {
        myTextlabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-32)
            make.top.equalTo(self).offset(32)
            make.bottom.equalTo(self).offset(-32)
            make.width.lessThanOrEqualTo(250)
        }
        
        yourID.snp.makeConstraints { (make) in
            make.left.equalTo(yourProfileImage.snp.right).offset(+2)
            make.top.equalTo(self.snp.top)
            make.height.equalTo(30)
            make.width.equalTo(300)
        }
        
        yourProfileImage.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(+8)
            make.top.equalTo(self).offset(+2)
            make.bottom.equalTo(yourTextlabel.snp.top).offset(+2)
            make.height.equalTo(30)
            make.width.equalTo(30)
        }
        
        bubleView.snp.makeConstraints { (make) in
            make.right.equalTo(myTextlabel).offset(16)
            make.top.equalTo(myTextlabel).offset(-16)
            make.bottom.equalTo(myTextlabel).offset(16)
            make.left.equalTo(myTextlabel).offset(-16)
        }
        
        yourTextlabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(+8)
            make.top.equalTo(yourID.snp.bottom)
            make.bottom.equalTo(self)
            make.width.equalTo(300)
        }
        
    }
}
