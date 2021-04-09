//
//  ProfileTableViewCell.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/9.
//

import UIKit

class ProfileImageTableViewCell: UITableViewCell {

    
    //MARK: - Properties
    
    static let identifier = "profileImageCell"
    
    //MARK: - IBOutlets
    
//    let profileImg: UIImageView = {
//        let iv = UIImageView()
//        iv.backgroundColor = .green
//        iv.layer.cornerRadius = 50
//        return iv
//    }()
    
    let profileBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .green
        btn.layer.cornerRadius = 50
        btn.addTarget(self, action: #selector(ProfileViewController().changeImg), for: .touchUpInside)
        return btn
    }()
    
    lazy var topBackgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .brown
//        view.addSubview(profileImg)
        view.addSubview(profileBtn)
        return view
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(topBackgroundView)
        contentView.isUserInteractionEnabled = false
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Set Layouts
    
    override func layoutSubviews() {
        topBackgroundView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(self)
            make.height.equalTo(self)
        }

//        profileImg.snp.makeConstraints { (make) in
//            make.centerY.equalTo(topBackgroundView)
//            make.left.equalTo(self).offset(+10)
//            make.height.equalTo(100)
//            make.width.equalTo(100)
//        }
        
        profileBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(topBackgroundView)
            make.left.equalTo(self).offset(10)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
    }
    
}
