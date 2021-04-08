//
//  HomePageView.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit
import SnapKit

class HomePageView: UIView
{
    // MARK: - IBOutlet
    let titleLabel: UILabel =
    {
        let label = UILabel()
        label.text = "ICRC"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 50)
        label.textAlignment = .center
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
        field.text = "123456@qwer.com"
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
        field.text = "123456"
        field.isSecureTextEntry = true
        return field
    }()
    
    let signUpButton: UIButton =
    {
        let button = UIButton()
        button.setTitle("Sign In", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(HomepageViewController.signInAction), for: .touchUpInside)
        return button
    }()
    
    let forgetPasswordButton: UIButton =
    {
        let button = UIButton()
        button.setTitle("Forget Password?", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.tag = 0
        button.addTarget(self, action: #selector(HomepageViewController.forgetPassword(sender:)), for: .touchUpInside)
        return button
    }()
    
    let registerButton: UIButton =
    {
        let button = UIButton()
        button.setTitle("Register", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.setTitleColor(.black, for: .highlighted)
        button.addTarget(self, action: #selector(HomepageViewController.gotoRegister), for: .touchUpInside)
        return button
    }()


    // MARK: - Init
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = .black
        addSubview(titleLabel)
        addSubview(accountTextField)
        addSubview(passwordTextField)
        addSubview(signUpButton)
        addSubview(forgetPasswordButton)
        addSubview(registerButton)
        autoLayout()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Layout
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
        
        signUpButton.snp.makeConstraints
        { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(600)
            make.width.equalTo(100)
            make.height.equalTo(30)
        }
        
        forgetPasswordButton.snp.makeConstraints
        { (make) in
            make.centerX.equalTo(self)
            make.top.equalTo(450)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
        
        registerButton.snp.makeConstraints
        { (make) in
            make.right.equalTo(30)
            make.bottom.equalTo(-50)
            make.width.equalTo(200)
            make.height.equalTo(30)
        }
    }
}
