//
//  HomepageViewController.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit
import Firebase
import FirebaseAuth

class HomepageViewController: UIViewController,UITextFieldDelegate
{
    let homepageview = HomePageView()
    
    // MARK: - Life Cycle
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = .black
    }

    //MARK: - override Function
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
    
    //MARK: - Custom Function
    func setUpKeyboard()
    {
        homepageview.accountTextField.delegate = self
        homepageview.passwordTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func signInAction()
    {
        if let account = homepageview.accountTextField.text, let password = homepageview.passwordTextField.text
        {
            FirebaseAuth.Auth.auth().signIn(withEmail: account,password: password,completion:{(user, error) in
                
                if error == nil
                {
                    let vc = ChatroomVC()
                    let nvvc = UINavigationController(rootViewController: vc)
                    let profileVC = ProfileViewController()
                    let nvProfileVC = UINavigationController(rootViewController: profileVC)
                    let friendsVC = FriendsViewController()
                    let nvFriendsVC = UINavigationController(rootViewController: friendsVC)
                    nvvc.tabBarItem.image = UIImage(systemName: "message.fill")
                    nvProfileVC.tabBarItem.image = UIImage(systemName: "person.fill")
                    nvFriendsVC.tabBarItem.image = UIImage(systemName: "person.3.fill")
                    let tabbarControl = UITabBarController()
                    tabbarControl.viewControllers = [nvvc, nvProfileVC, nvFriendsVC]
                    
                    tabbarControl.modalPresentationStyle = .fullScreen
                    self.present(tabbarControl, animated: true, completion: nil)
                }
                else
                {
                    print("error")
                }
            })
        }
    }
    
    @objc func forgetPassword(sender: UIButton)
    {
        if sender.tag == 0
        {
            if let account = homepageview.accountTextField.text
            {
                forgetPasswordWithEmail(email: account)
            }
        }
    }
    
    func forgetPasswordWithEmail(email: String){
        FirebaseAuth.Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    // 寄送新密碼
                }
            }
        }
    
    @objc func gotoRegister()
    {
        self.navigationController?.pushViewController(RegisterViewController(), animated: true)
    }
}
