//
//  ProfileDetailView.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/14.
//

import UIKit

class ProfileDetailView: UIView {

    //MARK: - Properties
    
    var tapBtnAction: (() -> Void)?
    
    //MARK: - IBOutlets
    
    let myTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter..."
        tf.backgroundColor = .clear
        tf.layer.cornerRadius = 5
        tf.layer.borderWidth = 1
        tf.layer.borderColor = UIColor.lightGray.cgColor
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    let myBtn: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitle("確定", for: .normal)
        return btn
    }()
    
    lazy var myStackView: UIStackView = {
        let sv = UIStackView(arrangedSubviews: [myTextField, myBtn])
        sv.distribution = .equalSpacing
        sv.axis = .horizontal
        return sv
    }()
    
    //MARK: - Init
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(myStackView)
        layouts()
        myBtn.addTarget(self, action: #selector(didTapBtn), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func didTapBtn() {
        tapBtnAction?()
    }
    
    //MARK: - Set Layouts

    func layouts() {
        myStackView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(self.snp.topMargin).offset(+50)
            make.width.equalTo(self).offset(-20)
            make.height.equalTo(40)
        }
        
        myTextField.snp.makeConstraints { (make) in
            make.left.equalTo(myStackView)
            make.right.equalTo(myBtn.snp.left).offset(-8)
            make.centerY.equalTo(myStackView)
//            make.width.equalTo(300)
            make.height.equalTo(myStackView)
        }
        
        myBtn.snp.makeConstraints { (make) in
            make.left.equalTo(myTextField.snp.right).offset(+8)
            make.right.equalTo(myStackView.snp.right)
            make.width.equalTo(40)
            make.centerY.equalTo(myStackView)
            make.height.equalTo(myStackView)
        }
        
    }
}
