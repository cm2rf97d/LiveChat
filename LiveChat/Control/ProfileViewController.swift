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
    func changeTabBarAndShowChatRoom(account: MarkUser) //Mike Add
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
    var userID = Auth.auth().currentUser?.uid
    var profileDetail = ProfileDetail()
    var friendInfomation: FriendAccountUserId?  //Mike Add
    var isInteractive: Bool = true
    var markUser: MarkUser?
    var friendAccount: String?
    var friendUser: MarkUser?
    {
        didSet
        {
            print(self.friendUser)
        }
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileView
        profileView.myTableView.delegate = self
        profileView.myTableView.dataSource = self
        if let userAccount = self.friendAccount {
            downloadImgs(userAccount: userAccount)
            getUserId()
            isInteractive = false
        }else{
            downloadImgs(userAccount: currentUserAccount)
        }
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
    
    //Mike Add
    func getUserId()
    {
        print("runrunrun")
        if let friendAccount = friendAccount
        {
            print("Mike Chat Name ==  \(friendAccount)")
            let downloadFriendList = Storage.storage().reference(withPath: "users/\(friendAccount)/userID")
            print("downloadFriendList \(downloadFriendList)")
            downloadFriendList.getData(maxSize: 1 * 1024 * 1024)
            { (data, error) in
                if let error = error
                {
                    print("$$$$$$$$$$$$$$$")
                    print("Error: \(error.localizedDescription)")
                }
                else if let data = data
                {
                    print("::::::::::::::")
                    let userID = String(decoding: data, as: UTF8.self)
                    self.friendUser = MarkUser(userAccount: friendAccount, userID: userID, userImage: UIImage(), friendsList: [])
                }
            }
        }
    }
    
    func uploadImgs(image: UIImage) {
        
        let storageProfileImg =
            Storage.storage().reference(withPath: "users/\(currentUserAccount)/profileImage.jpg") //Mike Modify
        print("1111\(currentUserId)")

        let storageBackgroundImg =
            Storage.storage().reference(withPath: "users/\(currentUserAccount)/backgroundImage.jpg")
        
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        
        
        
        if profileOrBackgroundImg == .profile {
            //upload profile image
            guard let dataImg = image.jpegData(compressionQuality: 0.75) else { return }
            storageProfileImg.putData(dataImg, metadata: uploadMetaData) { (data, error) in
                if let error = error {
                    print("Error: \(error)")
                }else if let data = data {
                    print(data)
                }
            }
        }else if profileOrBackgroundImg == .background{
            //upload background image
            guard let backgroundDataImg = image.jpegData(compressionQuality: 0.75) else { return }
            storageBackgroundImg.putData(backgroundDataImg, metadata: uploadMetaData) { (data, error) in
                if let error = error {
                    print("Error: \(error)")
                }else if let data = data {
                    print(data)
                }
            }
        }
        
        
    }
    
    func uploadProfileInfo()
    {
        let storageProfileInfo =
            Storage.storage().reference(withPath: "users/\(currentUserAccount)/profileInfo")   //Mike Modify
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "profileInfo"
        guard let profileDetailData = try? JSONSerialization.data(withJSONObject: self.profileDetail.profileDetail, options: []) else { return }
        storageProfileInfo.putData(profileDetailData, metadata: uploadMetaData)
            { (data, error) in
                if let error = error
                {
                    print("Error: \(error)")
                }else if let data = data {
                    print(data)
                }
            }
        
    }
    
    func downloadImgs(userAccount: String) {
        let downloadProfileImg = Storage.storage().reference(withPath: "users/\(userAccount)/profileImage.jpg")
        let downloadBackgroundImg = Storage.storage().reference(withPath: "users/\(userAccount)/backgroundImage.jpg")
        let downloadProfileInfo = Storage.storage().reference(withPath: "users/\(userAccount)/profileInfo")
        
        
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
                self.uploadProfileInfo()
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
//            cell.profileImg.isUserInteractionEnabled = !aaa
            cell.topBackgroundView.isUserInteractionEnabled = isInteractive
            cell.chatBtn.isHidden = isInteractive
            cell.tapProfileImgAction = {
                self.profileOrBackgroundImg = .profile
                self.changeImg()
            }
            cell.tapbackgroundImgAction = {
                self.profileOrBackgroundImg = .background
                self.changeImg()
            }
            
            cell.chatButtonAction =
            {
                if let userAccount = self.friendUser
                {
                    self.dismiss(animated: true)
                    {
                        self.changeViewDelegate?.changeTabBarAndShowChatRoom(account: userAccount)
                    }
                }
            }
            
            cell.profileImg.image = self.profileImage
            cell.topBackgroundView.image = self.backgroundImage
//            cell.topBackgroundView.backgroundColor = .white
            
            return cell
        case .profile:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileInfoTableViewCell.identifier, for: indexPath) as? ProfileInfoTableViewCell else { return UITableViewCell()}
            
            let bubleView = UIView()
            bubleView.backgroundColor = .clear
            
            cell.selectedBackgroundView = bubleView
            cell.titleLabel.text = profileDetail.profileInfo[indexPath.row]
            cell.detailLabel.text = profileDetail.profileDetail[indexPath.row]
            

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
            return fullSizeHeight
        case .profile:
            return UITableView.automaticDimension
        }
//        if mySections[indexPath.section] == .profileImage {
//            return fullSizeHeight
//        }
//        return CGFloat(tableView.autoresizingMask.rawValue)
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

