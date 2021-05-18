//
//  SearchFriendView.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/12.
//

import UIKit

class SearchFriendView: UIView {

    var searchButtonAction: (() -> Void)?
    var addButtonAction: (() -> Void)?
    
    let searchView: UIView =
    {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.borderWidth = 0.3
        view.layer.borderColor = UIColor.gray.cgColor
        return view
    }()
    
    let searchTextField: UITextField =
    {
        let textField = UITextField()
        textField.backgroundColor = .white
        textField.placeholder = "請輸入好友的帳號進行搜尋"
        return textField
    }()
    
    let searchButton: UIButton =
    {
        let button = UIButton()
        button.leftBorder(width: 0.3, borderColor: .gray)
        button.layer.borderColor = UIColor.gray.cgColor
        button.setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        button.addTarget(self, action: #selector(searchFriend), for: .touchUpInside)
        return button
    }()
    
    let friendImageView: UIImageView =
    {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.backgroundColor = .systemBlue
        imageView.layer.cornerRadius = 80
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let friendLabel: UILabel =
    {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    
    let addFriendButton: UIButton =
    {
        let button = UIButton()
        button.isHidden = true
        button.backgroundColor = #colorLiteral(red: 0, green: 0.7809999427, blue: 0, alpha: 1)
        button.setTitle("Add", for: .normal)
        button.addTarget(self, action: #selector(addFriend), for: .touchUpInside)
        return button
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = #colorLiteral(red: 0.921431005, green: 0.9214526415, blue: 0.9214410186, alpha: 1)
        addSubview(searchView)
        addSubview(searchTextField)
        addSubview(searchButton)
        addSubview(friendImageView)
        addSubview(friendLabel)
        addSubview(addFriendButton)
        autoLayout()
        setGradientLayer()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func searchFriend()
    {
        searchButtonAction?()
    }
    
    @objc private func addFriend()
    {
        addButtonAction?()
    }
    
    func autoLayout()
    {
        searchTextField.snp.makeConstraints
        { (make) in
            make.width.equalTo(UIScreen.main.bounds.width * 0.9)
            make.height.equalTo(40)
            make.left.equalTo(20)
            make.centerY.equalTo(searchView)
        }
        
        searchView.snp.makeConstraints
        { (make) in
            make.width.equalTo(UIScreen.main.bounds.width * 0.92)
            make.height.equalTo(42)
            make.centerX.equalTo(searchTextField)
            make.top.equalTo(150)
        }
        
        searchButton.snp.makeConstraints
        { (make) in
            make.height.equalTo(42)
            make.width.equalTo(40)
            make.right.equalTo(searchView)
            make.centerY.equalTo(searchView)
        }
        
        friendImageView.snp.makeConstraints
        { (make) in
            make.height.equalTo(friendImageView.layer.cornerRadius * 2)
            make.width.equalTo(friendImageView.layer.cornerRadius * 2)
            make.centerX.equalTo(self)
            make.top.equalTo(250)
        }
        
        friendLabel.snp.makeConstraints
        { (make) in
            make.height.equalTo(50)
            make.width.equalTo(self)
            make.top.equalTo(friendImageView.snp.bottom).offset(10)
            make.centerX.equalTo(self)
        }
        
        addFriendButton.snp.makeConstraints
        { (make) in
            make.height.equalTo(40)
            make.width.equalTo(150)
            make.top.equalTo(friendLabel.snp.bottom).offset(20)
            make.centerX.equalTo(self)
        }
    }
}

