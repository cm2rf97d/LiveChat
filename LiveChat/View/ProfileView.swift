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
        let tv = UITableView(frame: CGRect(), style: .grouped)
        tv.register(ProfileImageTableViewCell.self, forCellReuseIdentifier: ProfileImageTableViewCell.identifier)
        tv.register(ProfileInfoTableViewCell.self, forCellReuseIdentifier: ProfileInfoTableViewCell.identifier)
        tv.separatorStyle = .none
        tv.backgroundColor = .clear
        return tv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(myTableView)
        layouts()
        setGradientLayer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Set Layouts
    
    func layouts() {
        
        myTableView.snp.makeConstraints { (make) in
            make.top.equalTo(self.snp_topMargin)
            make.bottom.equalTo(self.snp_bottomMargin)
            make.centerX.width.equalTo(self)
        }
        

    }

}
