//
//  ProfileViewController.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/9.
//

import UIKit

class ProfileViewController: UIViewController {

    
    //MARK: - Properties
    
    let profileView = ProfileView()
    let mySections: [MySections] = [.profileImage, .profile]
    var profileInfo = ["id", "name"]
    var profileOrBackgroundImg: ProfileOrBackgroundImg = .profile
    var profileImage: UIImage?
    var backgroundImage: UIImage?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        profileView.myTableView.delegate = self
        profileView.myTableView.dataSource = self
    }
    
    //MARK: - Functions
    
    
    @objc func changeImg() {
        let ImagePicker = UIImagePickerController()
        ImagePicker.sourceType = .photoLibrary
        ImagePicker.delegate = self
        ImagePicker.allowsEditing = true
        self.present(ImagePicker, animated: true, completion: nil)
    }
    
}

//MARK: - Enums

//MARK: TableView Sections

enum MySections {
    case profileImage, profile
}

//MARK: ProfileOrBackgroundImg

enum ProfileOrBackgroundImg {
    case profile, background
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
            cell.tapProfileImgAction = {
                self.profileOrBackgroundImg = .profile
                self.changeImg()
            }
            cell.tapbackgroundImgAction = {
                self.profileOrBackgroundImg = .background
                self.changeImg()
            }
            cell.profileImg.image = self.profileImage
            cell.topBackgroundView.image = self.backgroundImage
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

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            
            if profileOrBackgroundImg == .profile {
                self.profileImage = image
            }else{
                self.backgroundImage = image
            }
            
            dismiss(animated: true, completion: nil)
            profileView.myTableView.reloadData()
            
        }
    }
    
}

