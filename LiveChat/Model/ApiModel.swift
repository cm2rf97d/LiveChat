//
//  ApiModel.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/5/12.
//

import UIKit
import Firebase
import FirebaseAuth

extension UIViewController {
    
    func getFriendInfo(friendMember: [String], myData: @escaping ([MarkUser])->())
    {
        var downloadFriendAccount: StorageReference
        var downloadFriendUserId: StorageReference
        var downloadFriendUserImage: StorageReference
        var friendAccount: String = ""
        var friendUserId: String = ""
        var friendImage: UIImage?
        var friendMembers: [MarkUser] = []
        
        print("friendMember.count = \(friendMember.count)")
        for i in 0 ..< friendMember.count
        {
            print("123123123---------")
            downloadFriendAccount = Storage.storage().reference(withPath: "users/\(friendMember[i])/userAccount")
            downloadFriendUserId = Storage.storage().reference(withPath: "users/\(friendMember[i])/userID")
            downloadFriendUserImage = Storage.storage().reference(withPath: "users/\(friendMember[i])/profileImage.jpg")
            friendAccount = ""
            friendUserId = ""
            friendImage = UIImage()
            
            var markUser = MarkUser(userAccount: "", userID: "", userImage: UIImage(), friendsList: [])
            
            downloadFriendAccount.getData(maxSize: 1 * 1024 * 1024)
            { (data, error) in
                if let error = error
                {
                    print("Error: \(error.localizedDescription)")
                }
                else if let data = data
                {
                    friendAccount = String(decoding: data, as: UTF8.self)
                    print("ccccccccc\(data)")
                    markUser.userAccount = friendAccount
                }
            }
            
                downloadFriendUserId.getData(maxSize: 1 * 1024 * 1024)
                { (data, error) in
                    if let error = error
                    {
                        print("Error: \(error.localizedDescription)")
                    }
                    else if let data = data
                    {
                        friendUserId = String(decoding: data, as: UTF8.self)
                        print("ccccccccc\(data)")
                        markUser.userID = friendUserId
                    }
                }
            
            
            downloadFriendUserImage.getData(maxSize: 1 * 1024 * 1024)
            { (data, error) in
                if let error = error
                {
                    print("Error: \(error.localizedDescription)")
                }
                else if let data = data
                {
                    if let friendImage = UIImage(data: data) {
                        print("ccccccccc\(data)")
                        markUser.userImage = friendImage
                        if markUser.userID == "" || markUser.userAccount == "" {
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                friendMembers.append(markUser)
                                return myData(friendMembers)
                            }
                            
                        }else{
                            friendMembers.append(markUser)
                            return myData(friendMembers)
                        }

                    }
                }
            }
            
        }
    }

}
