//
//  RegisterViewController.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class RegisterViewController: UIViewController,UITextFieldDelegate
{
    let registerView = RegisterView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func loadView()
    {
        self.view = registerView
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func createAccountAction(_ sender: AnyObject)
    {
        if let account = registerView.accountTextField.text, let password = registerView.passwordTextField.text
        {
            FirebaseAuth.Auth.auth().createUser(withEmail: account, password: password, completion: {(user, error) in
                
                if let userId = Auth.auth().currentUser?.uid
                {
                    currentUserId = userId
                }
                
                if error == nil
                {
                    print("!!!!!!!!!!\(currentUserId)")
                    let storageAccount =
                        Storage.storage().reference(withPath: "users/\(account)/userAccount")
                    let storageID =
                        Storage.storage().reference(withPath: "users/\(account)/userID")
                    
                    let uploadMetaData = StorageMetadata.init()
                    uploadMetaData.contentType = "userAccount"
                                        
                    if let account = self.registerView.accountTextField.text {
                        let accountData = Data(account.utf8)
                            storageAccount.putData(accountData, metadata: uploadMetaData) { (data, error) in
                                if let error = error {
                                    print("Error: \(error)")
                                }else if let data = data {
                                    print(data)
                                    print("UserID: \(currentUserId)")
                                }
                            }
                        let accountID = Data(currentUserId.utf8)
                            storageID.putData(accountID, metadata: uploadMetaData) { (data, error) in
                                if let error = error {
                                    print("Error: \(error)")
                                }else if let data = data {
                                    print(data)
                                    print("UserID: \(currentUserId)")
                                }
                            }
                    }
                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    print("error: \(String(describing: error?.localizedDescription))")
                }
            })
        }
    }
}

