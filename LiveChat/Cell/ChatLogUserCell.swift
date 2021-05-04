//
//  ChatLogTableViewCell.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/8.
//

import UIKit

class ChatLogUserCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "ChatLogCell"
    
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
    
    let mybubleView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBlue
        view.layer.cornerRadius = 15
        return view
    }()
    
    let mytimelabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.textColor = .black
//        label.lineBreakMode = .byCharWrapping
        return label
    }()
    
    var myImageView: ImageViewForAPI = {
        let view = ImageViewForAPI()
        return view
    }()
    
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        addSubview(mybubleView)
        addSubview(myTextlabel)
        addSubview(mytimelabel)
        addSubview(myImageView)
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
            
        mybubleView.snp.makeConstraints { (make) in
            make.right.equalTo(myTextlabel).offset(10)
            make.top.equalTo(myTextlabel).offset(-10)
            make.bottom.equalTo(myTextlabel).offset(10)
            make.left.equalTo(myTextlabel).offset(-10)
        }
        
        mytimelabel.snp.makeConstraints { (make) in
            make.bottom.equalTo(mybubleView).offset(-1)
            make.right.equalTo(mybubleView.snp.left).offset(-5)
        }
        
        myImageView.snp.makeConstraints { (make) in
            make.right.equalTo(self).offset(-32)
            make.top.equalTo(self).offset(32)
            make.bottom.equalTo(self).offset(-32)
            make.size.lessThanOrEqualTo(250)
        }
    }
    
}
