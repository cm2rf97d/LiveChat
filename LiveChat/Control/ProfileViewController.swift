//
//  ProfileViewController.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/9.
//

import UIKit
import FirebaseStorage
import FirebaseAuth

protocol changeViewDelegate                         //Mike Add
{                                                   //Mike Add
    func changeTabBarAndShowChatRoom(account: FriendAccountUserId) //Mike Add
}                                                   //Mike Add

class ProfileViewController: UIViewController {

    //MARK: - Properties
    var changeViewDelegate: changeViewDelegate? //Mike Add
    let profileView = ProfileView()
    let mySections: [MySections] = [.profileImage, .profile]
    var profileOrBackgroundImg: ProfileOrBackgroundImg = .profile
    var profileImage: UIImage? {
        didSet{
            profileView.myTableView.reloadData()
        }
    }
    var backgroundImage: UIImage?  {
        didSet{
            profileView.myTableView.reloadData()
        }
    }
    let userID = Auth.auth().currentUser?.uid
    var profileDetail = ProfileDetail()
    var friendInfomation: FriendAccountUserId?  //Mike Add
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        profileView.myTableView.delegate = self
        profileView.myTableView.dataSource = self
        downloadImgs()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        profileView.myTableView.reloadData()
        uploadProfileInfo()
    }
    
    //MARK: - Functions
    
    @objc func changeImg() {
        let ImagePicker = UIImagePickerController()
        ImagePicker.sourceType = .photoLibrary
        ImagePicker.delegate = self
        ImagePicker.allowsEditing = true
        self.present(ImagePicker, animated: true, completion: nil)
    }
    
    func uploadImgs(image: UIImage) {
        
        let storageProfileImg =
//            Storage.storage().reference(withPath: "users/\(userID!)/profileImage.jpg")
            Storage.storage().reference(withPath: "users/\(friendInfomation?.userID)/profileImage.jpg") //Mike Modify

        let storageBackgroundImg =
//            Storage.storage().reference(withPath: "users/\(userID!)/backgroundImage.jpg")
            Storage.storage().reference(withPath: "users/\(friendInfomation?.userID)/backgroundImage.jpg")
        
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        
        
        if profileOrBackgroundImg == .profile {
            //upload profile image
            guard let dataImg = image.jpegData(compressionQuality: 0.75) else { return }
            storageProfileImg.putData(dataImg, metadata: uploadMetaData) { (data, error) in
                if let error = error {
                    print("Error: \(error)")
                }else if let data = data {
                }
            }
        }else if profileOrBackgroundImg == .background{
            //upload background image
            guard let backgroundDataImg = image.jpegData(compressionQuality: 0.75) else { return }
            storageBackgroundImg.putData(backgroundDataImg, metadata: uploadMetaData) { (data, error) in
                if let error = error {
                    print("Error: \(error)")
                }else if let data = data {
                }
            }
        }
        
        
    }
    
    func uploadProfileInfo() {
        let storageProfileInfo =
//            Storage.storage().reference(withPath: "users/\(userID!)/profileInfo")
            Storage.storage().reference(withPath: "users/\(friendInfomation?.userID)/profileInfo")   //Mike Modify
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "profileInfo"
        
        guard let profileDetailData = try? JSONSerialization.data(withJSONObject: profileDetail.profileDetail, options: []) else { return }
            storageProfileInfo.putData(profileDetailData, metadata: uploadMetaData) { (data, error) in
                if let error = error {
                    print("Error: \(error)")
                }else if let data = data {
                }
            }
        
    }
    
    func downloadImgs() {
        let downloadProfileImg = Storage.storage().reference(withPath: "users/\(userID!)/profileImage.jpg")
        let downloadBackgroundImg = Storage.storage().reference(withPath: "users/\(userID!)/backgroundImage.jpg")
        let downloadProfileInfo = Storage.storage().reference(withPath: "users/\(userID!)/profileInfo")
        
        downloadProfileImg.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else if let data = data{
                self.profileImage = UIImage(data: data)
            }
        }
        downloadBackgroundImg.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else if let data = data{
                self.backgroundImage = UIImage(data: data)
            }
        }
        downloadProfileInfo.getData(maxSize: 1 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error: \(error.localizedDescription)")
            }else if let data = data{
                guard let teststrr = try? JSONSerialization.jsonObject(with: data, options: []) as? [String] else { return }
                self.profileDetail.profileDetail = teststrr
                self.profileView.myTableView.reloadData()
            }
        }
    }
    
}

//MARK: - Enums

//TableView Sections

enum MySections {
    case profileImage, profile
}

//ProfileOrBackgroundImg

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
            return profileDetail.profileInfo.count
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
            
            cell.chatButtonAction = {
                guard let userAccount = self.friendInfomation else {return}
                self.dismiss(animated: true) {
                    self.changeViewDelegate?.changeTabBarAndShowChatRoom(account: userAccount)
                }
            }
            
            cell.profileImg.image = self.profileImage
            cell.topBackgroundView.image = self.backgroundImage
            return cell
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as? ProfileInfoTableViewCell else { return UITableViewCell()}
            
            cell.textLabel?.text = profileDetail.profileInfo[indexPath.row]
            cell.detailTextLabel?.text = profileDetail.profileDetail[indexPath.row]
            
            
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch mySections[indexPath.section] {
        case .profileImage:
            break
        case .profile:
            let personalDetail = ProfileDetailViewController()
            personalDetail.sendProfileDataDelegate = self
            personalDetail.receiveText = profileDetail.profileDetail[indexPath.row]
            personalDetail.index = indexPath.row
            navigationController?.pushViewController(personalDetail, animated: true)
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
    
    //MARK: Header
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch mySections[section] {
        case .profileImage:
            return " "
        case .profile:
            return "個人資訊"
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch mySections[section] {
        case .profileImage:
            return 0
        case .profile:
            return 20
        }
    }
    
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let image = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            uploadImgs(image: image)
            if profileOrBackgroundImg == .profile {
                self.profileImage = image
            }else{
                self.backgroundImage = image
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
}

extension ProfileViewController: PassProfileDetailDelegate {
    func sendProfileDetail(detail: String, index: Int) {
        profileDetail.profileDetail[index] = detail
    }
    
    
}
