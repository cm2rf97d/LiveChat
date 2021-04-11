//
//  ChatLogTableViewCell.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/8.
//

import UIKit

class ChatLogTableViewCell: UITableViewCell {

    //MARK: - Properties
    
    static let identifier = "ChatLogCel"
    
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
        label.font = UIFont.systemFont(ofSize: 20)
        return label
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
        
        bubleView.snp.makeConstraints { (make) in
            make.right.equalTo(myTextlabel).offset(16)
            make.top.equalTo(myTextlabel).offset(-16)
            make.bottom.equalTo(myTextlabel).offset(16)
            make.left.equalTo(myTextlabel).offset(-16)
        }
        
    }
    

}
