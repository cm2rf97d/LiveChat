//
//  ProfileInfoTableViewCell.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/9.
//

import UIKit

class ProfileInfoTableViewCell: UITableViewCell {

    static let identifier = "profileInfoCell"
    
    //MARK: - IBOutlets

    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.textColor = .black
//        label.backgroundColor = .blue
//        label.textAlignment = NSTextAlignment.center
        return label
    }()
    
    let detailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
//        label.backgroundColor = .blue
        label.textAlignment = NSTextAlignment.right
        return label
    }()
    
    let textbubleView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 15
        return view
    }()
    
    
    //MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(textbubleView)
        addSubview(detailLabel)
        addSubview(titleLabel)
        constraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func constraints() {
        titleLabel.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(30)
            make.top.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-20)
        }
        
        detailLabel.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-30)
            make.top.equalTo(self).offset(20)
            make.bottom.equalTo(self).offset(-20)
        }
        
        textbubleView.snp.makeConstraints { (make) in
            make.right.equalTo(detailLabel).offset(10)
            make.top.equalTo(titleLabel).offset(-10)
            make.bottom.equalTo(titleLabel).offset(10)
            make.left.equalTo(titleLabel).offset(-10)
        }
    }
    
}

