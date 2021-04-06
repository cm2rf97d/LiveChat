//
//  HomepageViewController.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit

class HomepageViewController: UIViewController,UITextFieldDelegate
{
    let homepageview = HomePageView()
    // Keep Keyboard Height
    var keyboardHeight: CGFloat = 0
    
    // MARK: - Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .black
        homepageview.accountTextField.delegate = self
        homepageview.passwordTextField.delegate = self
    }

    override func loadView()
    {
        self.view = homepageview
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool)
    {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    @objc func signInSuccess()
    {
        print("SignIn Success")
    }
    
    @objc func gotoRegister()
    {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}
