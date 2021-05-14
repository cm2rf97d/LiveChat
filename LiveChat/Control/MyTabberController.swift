//
//  TabberController.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/5/12.
//

import UIKit

var customButton = UIButton()

class MyTabberController: UITabBarController {

    
//    var testBool = false
//    {
//        didSet
//        {
//            if testBool == true
//            {
//                self.customButton.isHidden = true
//            }
//            else
//            {
//                self.customButton.isHidden = false
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
        setTabbar()
//        self.tabBar.bringSubviewToFront(customButton)
//        self.tabBar.isTranslucent = false
        // Do any additional setup after loading the view.
        
    }
    
    func setTabbar() {
        let profileVC = ProfileViewController()
        let nvProfileVC = UINavigationController(rootViewController: profileVC)
        let friendsVC = FriendsViewController()
        let nvFriendsVC = UINavigationController(rootViewController: friendsVC)
        let vc = ChatroomVC()
//        if vc.isBtnHidden == true {
//            self.customButton.isHidden = true
//        }
        friendsVC.presentChatViewDelegate = vc
        let nvvc = UINavigationController(rootViewController: vc)
        nvvc.tabBarItem.image = UIImage(systemName: "message.fill")
        nvProfileVC.tabBarItem.image = UIImage(systemName: "person.fill")
        nvFriendsVC.tabBarItem.image = UIImage(systemName: "person.3.fill")
        self.viewControllers = [nvvc, nvProfileVC, nvFriendsVC]
        settingButton()
//        self.tabBarController?.modalPresentationStyle = .fullScreen
    }
    
//    MARK: - Functions
    
    func rotateProfileIcon() {
        customButton.tintColor = .systemBlue
        UIView.animate(withDuration: 0.5) {
            customButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
          customButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: nil)
    }
    
    func settingButton() {
        let config = UIImage.SymbolConfiguration(
            pointSize: 32, weight: .medium, scale: .default)
        let image = UIImage(systemName: "person.fill", withConfiguration: config)

        customButton.setImage(image, for: .normal)
        customButton.tintColor = .gray
        customButton.backgroundColor = .systemTeal
//        customButton.frame.size = CGSize(width: 70, height: 70)
//        customButton.center = CGPoint(x: (self.tabBar.bounds.midX), y: (self.tabBar.bounds.midY) - customButton.frame.height / 3)
        customButton.layer.cornerRadius = 35
        customButton.layer.borderColor = UIColor.black.cgColor
        customButton.layer.borderWidth = 3
//        customButton.layer.masksToBounds = true
        customButton.clipsToBounds = true
        customButton.adjustsImageWhenHighlighted = false
        customButton.addTarget(self, action: #selector(showViewController), for: .touchDown)
        self.view.addSubview(customButton)
        customButton.snp.makeConstraints { (make) in
            make.centerX.equalTo(tabBar)
            make.centerY.equalTo(tabBar.snp.top)
            make.width.height.equalTo(70)
        }
    }
    
    @objc func showViewController() {
        customButton.tintColor = .systemBlue
        rotateProfileIcon()
        print("oooooooo")
        self.selectedIndex = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.image == UIImage(systemName: "person.fill") {
            rotateProfileIcon()
        }else{
            customButton.tintColor = .gray
        }
        
       }
    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesBegan(touches, with: event)
//            touches.forEach { (touch) in
//                let position = touch.location(in: tabBar)
//                let offset = customButton.frame.height / 3
//                print("llllllllll\(position.y)")
//                if customButton.frame.minX <= position.x && position.x <= customButton.frame.maxX {
//                    if customButton.frame.minY - offset <= position.y && position.y <= customButton.frame.maxY - offset{
//                        print("min:\(customButton.frame.minY), max:\(customButton.frame.maxY)")
//
//                        showViewController()
//                    }
//                }
//            }
//        }
//
//    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        super.touchesMoved(touches, with: event)
//        guard let location = touches.first?.location(in: tabBar) else { return }
//        print(location)
//    }
    
}



