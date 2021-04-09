//
//  ProfileViewController.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/9.
//

import UIKit

class ProfileViewController: UIViewController, UIGestureRecognizerDelegate {

    
    //MARK: - Properties
    
    let profileView = ProfileView()
    let mySections: [MySections] = [.profileImage, .profile]
    var profileInfo = ["id", "name"]
    let imageTouch = UITapGestureRecognizer(target: self, action: #selector(changeImg))
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        profileView.myTableView.delegate = self
        profileView.myTableView.dataSource = self
//        imageTouch.delegate = self
    }
    
    //MARK: - Functions
    
    
    @objc func changeImg() {
        print("test")
    }
    
}

//MARK: - TableView Sections

enum MySections {
    case profileImage, profile
}

//MARK: - UITableViewDelegate, UITableViewDataSource

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        mySections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch mySections[section] {
        case .profileImage:
            return 1
        case .profile:
            return profileInfo.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch mySections[indexPath.section] {
        case .profileImage:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileImageTableViewCell.identifier, for: indexPath) as? ProfileImageTableViewCell else { return UITableViewCell()}
            
//            cell.profileBtn.addTarget(self, action: #selector(changeImg), for: .touchUpInside)
//            cell.profileImg.addGestureRecognizer(imageTouch)
            
            return cell
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as? ProfileInfoTableViewCell else { return UITableViewCell()}
            cell.selectionStyle = .none
            cell.textLabel?.text = profileInfo[indexPath.row]
            
            return cell
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let fullSizeHeight = UIScreen.main.bounds.height
        
        switch mySections[indexPath.section] {
        case .profileImage:
            return fullSizeHeight * 0.3
        case .profile:
            return 50
        }
    }
    
}
