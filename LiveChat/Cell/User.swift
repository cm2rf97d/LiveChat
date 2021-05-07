//
//  User.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/8.
//

import Foundation
import UIKit

struct Users {
    var id: String
    var content: String
    var time: Date
}

struct FriendAccountUserId
{
    var userAccount: String
    var userID: String
//    var userImage: UIImage   //Mark modified
}

var currentUserId: String = ""
var currentUserAccount: String = ""


//Mark test:

struct MarkUser
{
    var userAccount: String
    var userID: String
    var userImage: UIImage
    var friendsList: [String]
}
