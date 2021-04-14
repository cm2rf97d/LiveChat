//
//  ChatLogView2.swift
//  LiveChat
//
//  Created by 董恩志 on 2021/4/13.
//

import UIKit

class ChatLogView: UIView {

    //MARK: - IBOutlets
            
    let myTableView: UITableView = {
        let tv = UITableView()
        tv.register(ChatLogTableViewCell.self,forCellReuseIdentifier: ChatLogTableViewCell.identifier)
        tv.separatorStyle = .none
        tv.rowHeight = UITableView.automaticDimension
        tv.backgroundColor = .clear
        return tv
    }()
    
    let myTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter..."
        tf.backgroundColor = .clear
        return tf
    }()
    
    let sendBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("Send", for: .normal)
        btn.addTarget(self, action: #selector(ChatLogVC.sendMsg), for: .touchUpInside)
        return btn
    }()
    
    let separatorLine: UIView = {
        let sl = UIView()
        sl.backgroundColor = .gray
        return sl
    }()
        
    lazy var bottomView: UIView = {
        let bv = UIView()
        bv.backgroundColor = .white
        bv.addSubview(myTextField)
        bv.addSubview(sendBtn)
        bv.addSubview(separatorLine)
        
        return bv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        addSubview(myTableView)
        addSubview(bottomView)
        layouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
        
    //MARK: - Set Layouts
    func layouts(){
        myTableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(self)
            make.bottom.equalTo(bottomView.snp.top)
//            make.bottom.equalTo(self)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.bottom.equalTo(self)
            make.height.equalTo(100)
        }

        myTextField.snp.makeConstraints { (make) in
            make.top.equalTo(bottomView).multipliedBy(0.1)
            make.left.equalTo(bottomView).offset(+8)
            make.right.lessThanOrEqualTo(sendBtn.snp.left)
            make.width.equalTo(bottomView).multipliedBy(0.8)
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
    }
}

