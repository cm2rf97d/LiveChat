//
//  ChatLogView2.swift
//  LiveChat
//
//  Created by 董恩志 on 2021/4/13.
//

import UIKit

class ChatLogView: UIView {

    //MARK: - IBOutlets
            
    let chatLogTableView: UITableView = {
        let tv = UITableView()
        tv.register(ChatLogTableViewCell.self,forCellReuseIdentifier: ChatLogTableViewCell.identifier)
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.backgroundColor = .clear
        return tv
    }()
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter..."
        tf.backgroundColor = .clear
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let sendBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        return btn
    }()
    
    let separatorLine: UIView = {
        let sl = UIView()
        sl.backgroundColor = .gray
        return sl
    }()
    
    let uploadImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "imageIcon")
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
        
    lazy var bottomView: UIView = {
        let bv = UIView()
        bv.backgroundColor = .white
        bv.addSubview(inputTextField)
        bv.addSubview(sendBtn)
        bv.addSubview(separatorLine)
        bv.addSubview(uploadImageView)
        
        return bv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        addSubview(chatLogTableView)
        addSubview(bottomView)
        layouts()
//        uploadImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(ChatLogVC.handleUpLoadTap)))
//        sendBtn.addTarget(self, action: #selector(ChatLogVC.sendMsg), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    //MARK: - Set Layouts
    func layouts(){
        chatLogTableView.snp.makeConstraints { (make) in
//            make.left.right.top.equalTo(self)
//            make.bottom.equalTo(bottomView.snp.top)
            make.left.right.equalTo(self)
            make.bottom.equalTo(bottomView.snp.top).offset(10)
            make.top.equalTo(self).offset(100)
            
//            make.bottom.equalTo(self)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(100)
        }

        inputTextField.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView).multipliedBy(0.1)
            make.left.equalTo(uploadImageView.snp.right).offset(10)
            make.right.equalTo(sendBtn.snp.left)
//            make.width.equalTo(bottomView).multipliedBy(0.7)
            make.height.equalTo(bottomView).multipliedBy(0.5)
        }

        sendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView)
            make.height.equalTo(bottomView).multipliedBy(0.5)
            make.width.equalTo(bottomView).multipliedBy(0.2)
        }

        separatorLine.snp.makeConstraints { (make) in
            make.top.width.equalTo(bottomView)
            make.height.equalTo(1)
        }
        
        uploadImageView.snp.makeConstraints { (make) in
            make.top.equalTo(separatorLine.snp.bottom).offset(1)
            make.left.equalTo(bottomView).offset(5)
            make.height.equalTo(bottomView.snp.width).multipliedBy(0.08)
            make.width.equalTo(bottomView).multipliedBy(0.08)
        }
    }
}

