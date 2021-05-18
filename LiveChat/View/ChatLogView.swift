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
        tv.register(ChatLogUserCell.self,forCellReuseIdentifier: ChatLogUserCell.identifier)
        tv.register(ChatLogOtherPersonCell.self,forCellReuseIdentifier: ChatLogOtherPersonCell.identifier)
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.backgroundColor = .clear
        return tv
    }()
    
    let inputTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter..."
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    let sendBtn: UIButton = {
        let btn = UIButton(type: .system)
//        btn.setTitle("Send", for: .normal)
        btn.setImage(UIImage(systemName: "arrow.right.circle.fill"), for: .normal)
        return btn
    }()
    
    let separatorLine: UIView = {
        let sl = UIView()
        sl.backgroundColor = .gray
        return sl
    }()
    
//    let uploadImageBtn: UIImageView = {
//        let imageView = UIImageView()
//        imageView.image = UIImage(systemName: "photo.fill.on.rectangle.fill")
//        imageView.isUserInteractionEnabled = true
//        return imageView
//    }()
    
    let uploadImageBtn: UIButton = {
        let btn = UIButton(type: .system)
//        btn.setTitle("Send", for: .normal)
        btn.setImage(UIImage(systemName: "photo.fill.on.rectangle.fill"), for: .normal)
        return btn
    }()
        
    lazy var bottomView: UIView = {
        let bv = UIView()
        bv.backgroundColor = .clear
        bv.addSubview(inputTextField)
        bv.addSubview(sendBtn)
        bv.addSubview(separatorLine)
        bv.addSubview(uploadImageBtn)
        
        return bv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
        addSubview(chatLogTableView)
        addSubview(bottomView)
        layouts()
        setGradientLayer()
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
            make.bottom.equalTo(bottomView.snp.top)
            make.top.equalTo(self.snp.topMargin)
            
//            make.bottom.equalTo(self)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(100)
        }

        inputTextField.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView).offset(10)
            make.left.equalTo(uploadImageBtn.snp.right)
            make.right.equalTo(sendBtn.snp.left)
            make.centerX.equalTo(bottomView)
//            make.width.equalTo(bottomView).multipliedBy(0.7)
            make.height.equalTo(bottomView).multipliedBy(0.4)
        }

        sendBtn.snp.makeConstraints { (make) in
            make.right.equalTo(bottomView).offset(-5)
            make.height.equalTo(bottomView).multipliedBy(0.5)
            make.width.equalTo(bottomView).multipliedBy(0.2)
            make.centerY.equalTo(inputTextField)
        }

        separatorLine.snp.makeConstraints { (make) in
            make.top.width.equalTo(bottomView)
            make.height.equalTo(1)
        }
        
        uploadImageBtn.snp.makeConstraints { (make) in
//            make.top.equalTo(separatorLine.snp.bottom).offset(1)
            make.left.equalTo(bottomView).offset(5)
            make.height.equalTo(bottomView.snp.width).multipliedBy(0.5)
            make.width.equalTo(bottomView).multipliedBy(0.2)
            make.centerY.equalTo(inputTextField)
        }
    }
}

