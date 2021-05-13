//
//  FriendsImageBannerCell.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/5/12.
//

import UIKit

class FriendsImageBannerCell: UICollectionViewCell {
    
    //MARK: - Properties
    
    static let identifier = "FriendsImageBannerCell"
    
    //MARK: - IBOutlets
    
    let imageView1: UIImageView = {
        let imgView = UIImageView()
        imgView.layer.cornerRadius = 30
        imgView.layer.borderWidth = 1
        imgView.layer.borderColor = UIColor.green.cgColor
        imgView.clipsToBounds = true
        return imgView
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
//        let chatRoomVC = ChatroomVC()
//        let friendsImages = chatRoomVC.friendInformations.map({$0.userImage})
        setSubViews()
        setLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set Subviews
    
    func setSubViews() {
        contentView.addSubview(imageView1)
    }
    
    //MARK: - Set Layouts
    
    func setLayouts() {
        imageView1.snp.makeConstraints { (make) in
            make.width.height.equalTo(60)
//            make.left.equalTo(self).offset(+8)
            make.centerY.equalTo(self.snp.centerY)
        }
    }
}
