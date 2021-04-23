//
//  PersonalDetailViewController.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/14.
//

import UIKit

protocol PassProfileDetailDelegate {
    func sendProfileDetail(detail: String, index: Int)
}

class ProfileDetailViewController: UIViewController {

    //MARK: - Properties
    
    let profileDetailView = ProfileDetailView()
    var sendProfileDataDelegate: PassProfileDetailDelegate?
    var receiveText: String?
    var index: Int?
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view = profileDetailView
        profileDetailView.myTextField.delegate = self
        profileDetailView.myTextField.text = receiveText
        profileDetailView.tapBtnAction = {
            self.didTapBtn()
        }
    }
    
    //MARK: - Functions
    
    func didTapBtn() {
        if let text = self.profileDetailView.myTextField.text, let index = self.index {
            self.sendProfileDataDelegate?.sendProfileDetail(detail: text, index: index)
            print("111")
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
}


extension ProfileDetailViewController: UITextFieldDelegate {
        
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        profileDetailView.myTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        didTapBtn()
        return true
    }
    
}
