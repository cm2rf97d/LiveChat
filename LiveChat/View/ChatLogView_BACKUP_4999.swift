//
//  ChatLogView.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/8.
//

import UIKit

class ChatLogView: UIView {

    //MARK: - IBOutlets
        
    let myTableView: UITableView = {
        let tv = UITableView()
        tv.register(ChatLogTableViewCell.self,forCellReuseIdentifier: ChatLogTableViewCell.identifier)
        tv.separatorStyle = .none
//        tv.estimatedRowHeight = 90
        tv.rowHeight = UITableView.automaticDimension
//        tv.estimatedRowHeight = UITableView.automaticDimension
        
        
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
            make.width.centerX.equalTo(self)
            make.bottom.equalTo(bottomView.snp.top)
            make.top.equalTo(self)
        }
        
        bottomView.snp.makeConstraints { (make) in
            make.left.width.equalTo(self)
            make.bottom.equalTo(self.safeAreaInsets)
            make.height.equalTo(50)
        }
        
        myTextField.snp.makeConstraints { (make) in
            make.bottom.height.equalTo(bottomView)
            make.left.equalTo(bottomView).offset(+8)
            make.right.equalTo(sendBtn.snp.left)
        }
        
        sendBtn.snp.makeConstraints { (make) in
            make.right.centerY.height.equalTo(bottomView)
            make.width.equalTo(80)
        }
        
        separatorLine.snp.makeConstraints { (make) in
            make.top.width.centerX.equalTo(bottomView)
            make.height.equalTo(1)
        }
    }
        
    
}
