//
//  ProfileView.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/9.
//

import UIKit

class ProfileView: UIView {

    //MARK: - IBOutlets
    
    let myTableView: UITableView = {
        let tv = UITableView()
        tv.register(ProfileImageTableViewCell.self, forCellReuseIdentifier: ProfileImageTableViewCell.identifier)
        tv.register(ProfileInfoTableViewCell.self, forCellReuseIdentifier: ProfileInfoTableViewCell.identifier)
        tv.separatorStyle = .none
        return tv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myTableView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set Layouts
    
    override func layoutSubviews() {
        
        myTableView.snp.makeConstraints { (make) in
            make.top.bottom.equalTo(self.safeAreaInsets)
            make.centerX.width.equalTo(self)
        }
        

    }

}
