//
//  DictionaryTransf.swift
//  LiveChat
//
//  Created by 董恩志 on 2021/5/12.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

extension UIViewController {
    
    func downLoadMessage(value:[String:AnyObject],completionHandler: @escaping (Messages)->Void) {
        if let id = value["id"] as? String,
           let text = value["text"] as? String,
           let time = value["time"] as? TimeInterval,
           let type = value["type"] as? String
        {
            
            let message = Messages(id: id, text: text, time: time, type: type)
            
            completionHandler(message)
            
        }
    }
    
    
    func upLoadMessage(userID:String,otherID:String,id:String,text:String,time:Double,type:String) {
        
        let ref = Database.database().reference().child("ChatRoom").child(userID).child(otherID)
        let  childRef = ref.childByAutoId()
        
        let value = ["id": id,
                      "text": text,
                      "time": time,
                      "type": type] as [String : Any]
        
        childRef.updateChildValues(value)
        
    }
        
    
    
}

