//
//  ProfileTableViewCell.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/9.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {

    
    //MARK: - Properties
    var tapProfileImgAction: (() -> Void)?
    var tapbackgroundImgAction: (() -> Void)?
    var chatButtonAction: (() -> Void)? // Mike Add
    static let identifier = "profileImageCell"
    
    //MARK: - IBOutlets
    
    let profileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .black
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    let chatBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("聊天", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.setTitleColor(.darkText, for: .highlighted)
        btn.backgroundColor = .systemPink
        btn.layer.cornerRadius = 5
        btn.layer.borderWidth = 1
        btn.layer.borderColor = UIColor.gray.cgColor
        return btn
    }()
    
    lazy var topBackgroundView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .black
        view.isUserInteractionEnabled = true
        view.addSubview(profileImg)
        view.addSubview(chatBtn)
        return view
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(topBackgroundView)
        layouts()
        
        let tapProfile = UITapGestureRecognizer(target: self, action: #selector(profileDidTap))
        profileImg.addGestureRecognizer(tapProfile)
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        topBackgroundView.addGestureRecognizer(tapBackground)
        chatBtn.addTarget(self, action: #selector(chatWithFriend), for: .touchUpInside) //Mike Add
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func profileDidTap() {
        tapProfileImgAction?()
    }
    
    @objc private func backgroundDidTap() {
        tapbackgroundImgAction?()
    }
    
    @objc private func chatWithFriend(){    //Mike Add
        chatButtonAction?()                 //Mike Add
    }                                       //Mike Add
    
    //MARK: - Set Layouts
    
    func layouts() {
        topBackgroundView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(self)
            make.height.equalTo(self)
        }

        profileImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(topBackgroundView)
            make.centerX.equalTo(self)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        chatBtn.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(profileImg.snp.bottom).offset(+8)
            make.width.equalTo(50)
            make.height.equalTo(30)
        }
        
    }
    
}
