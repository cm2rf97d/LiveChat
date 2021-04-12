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
    static let identifier = "profileImageCell"
    
    //MARK: - IBOutlets
    
    let profileImg: UIImageView = {
        let iv = UIImageView()
        iv.backgroundColor = .green
        iv.layer.cornerRadius = 50
        iv.clipsToBounds = true
        iv.isUserInteractionEnabled = true
        return iv
    }()
    
    lazy var topBackgroundView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .brown
        view.isUserInteractionEnabled = true
        view.addSubview(profileImg)
        return view
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(topBackgroundView)
        contentView.isUserInteractionEnabled = false
        layouts()
        
        let tapProfile = UITapGestureRecognizer(target: self, action: #selector(profileDidTap))
        profileImg.addGestureRecognizer(tapProfile)
        let tapBackground = UITapGestureRecognizer(target: self, action: #selector(backgroundDidTap))
        topBackgroundView.addGestureRecognizer(tapBackground)
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
    
    //MARK: - Set Layouts
    
    func layouts() {
        topBackgroundView.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(self)
            make.height.equalTo(self)
        }

        profileImg.snp.makeConstraints { (make) in
            make.centerY.equalTo(topBackgroundView)
            make.left.equalTo(self).offset(+10)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
    }
    
}
