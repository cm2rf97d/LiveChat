//
//  RegisterView.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit

class RegisterView: UIView
{
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        label.text = "Register"
        label.font = UIFont.systemFont(ofSize: 50)
        label.textColor = .white
        return label
    }()
    
    let accountTextField: UITextField =
    {
        let field = UITextField()
        field.backgroundColor = .systemGray3
        field.borderStyle = .roundedRect
        field.clearButtonMode = .whileEditing
        field.keyboardType = .emailAddress
        field.placeholder = " account"
        return field
    }()
    
    let passwordTextField: UITextField =
    {
        let field = UITextField()
        field.backgroundColor = .systemGray3
        field.borderStyle = .roundedRect
        field.clearButtonMode = .whileEditing
        field.keyboardType = .emailAddress
        field.placeholder = " password"
        return field
    }()
    
    let registerButton: UIButton =
    {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(HomepageViewController.signInSuccess), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = .black
        addSubview(titleLabel)
        addSubview(accountTextField)
        addSubview(passwordTextField)
        addSubview(registerButton)
        autoLayout()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func autoLayout()
    {
        titleLabel.snp.makeConstraints
        { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(150)
            make.width.equalTo(UIScreen.main.bounds.width * 0.5)
            make.height.equalTo(70)
        }
        
        accountTextField.snp.makeConstraints
        { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(350)
            make.width.equalTo(UIScreen.main.bounds.width * 0.7)
            make.height.equalTo(30)
        }
        
        passwordTextField.snp.makeConstraints
        { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(400)
            make.width.equalTo(UIScreen.main.bounds.width * 0.7)
            make.height.equalTo(30)
        }
        
        registerButton.snp.makeConstraints
        { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(600)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
    }
}
