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
    var userId: String = ""
    
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
                    self.userId = userId
                }
                
                if error == nil
                {
                    // Add User Information
                    let userAccount = Database.database().reference().child("userAccount")
                    let childUserAccount = userAccount.child(self.userId)
                    if let account = self.registerView.accountTextField.text
                    {
                        let values = ["account": account, "userID": self.userId] as [String : Any]
                        childUserAccount.updateChildValues(values)
                    }

                    self.navigationController?.popViewController(animated: true)
                }
                else
                {
                    print("error")
                }
            })
        }
    }
}
