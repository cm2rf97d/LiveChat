//
//  ChatLogVC.swift
//  LiveChat
//
//  Created by 董恩志 on 2021/4/7.
//

import UIKit

class ChatLogVC: UIViewController {

    // MARK: - Properties
        var chatName = ""
        // MARK: - Lifecycle
        override func viewDidLoad() {
            super.viewDidLoad()
            view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            setNavigation()
        }

        // MARK: - Methods
        func setNavigation() {
            self.navigationItem.title = chatName
        }
}
