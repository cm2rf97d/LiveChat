//
//  TabberController.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/5/12.
//

import UIKit

class MyTabberController: UITabBarController {

    let customButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTabber()
        self.tabBar.backgroundImage = UIImage()
        self.tabBar.shadowImage = UIImage()
//        self.tabBar.isTranslucent = false
        // Do any additional setup after loading the view.
    }
    
    func setTabber() {
        self.settingButton()
        let profileVC = ProfileViewController()
        let nvProfileVC = UINavigationController(rootViewController: profileVC)
        let friendsVC = FriendsViewController()
        let nvFriendsVC = UINavigationController(rootViewController: friendsVC)
        let vc = ChatroomVC()
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
            self.customButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi)
        }
        UIView.animate(withDuration: 0.5, delay: 0.2, options: UIView.AnimationOptions.curveEaseIn, animations: { () -> Void in
          self.customButton.transform = CGAffineTransform(rotationAngle: CGFloat.pi * 2.0)
        }, completion: nil)
    }
    
    func settingButton() {
        let config = UIImage.SymbolConfiguration(
            pointSize: 32, weight: .medium, scale: .default)
        let image = UIImage(systemName: "person.fill", withConfiguration: config)

        customButton.setImage(image, for: .normal)
        customButton.tintColor = .gray
        customButton.backgroundColor = .systemTeal
        customButton.frame.size = CGSize(width: 70, height: 70)
        // 這邊希望他超出 tabBar 範圍，因此在這邊提高其 y 軸位置。
        customButton.center = CGPoint(x: (self.tabBar.bounds.midX), y: (self.tabBar.bounds.midY) - customButton.frame.height / 3)
//        customButton.backgroundColor = .white
        customButton.layer.cornerRadius = 35
        customButton.layer.borderColor = UIColor.black.cgColor
        customButton.layer.borderWidth = 3
        customButton.clipsToBounds = true
        // 取消按鈕點選 highLight 效果
        customButton.adjustsImageWhenHighlighted = false
        // 為客製化按鈕新增一個點擊事件
        customButton.addTarget(self, action: #selector(showViewController), for: .touchDown)
        
        self.tabBar.addSubview(customButton)
    }
    
    @objc func showViewController() {
        // 設置按鈕背景色，讓他看起來有 highlighted 的效果
        customButton.tintColor = .systemBlue
        rotateProfileIcon()
        // 跳轉至 tabBarController 相對應的索引值的
        self.selectedIndex = 1
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

        if item.image == UIImage(systemName: "person.fill") {
            rotateProfileIcon()
        }else{
            customButton.tintColor = .gray
        }
        
       }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
            touches.forEach { (touch) in
                let position = touch.location(in: customButton)
                let offset = customButton.frame.height / 3
                print("llllllllll\(offset)")
                if customButton.frame.minX <= position.x && position.x <= customButton.frame.maxX {
                    if customButton.frame.minY - offset <= position.y && position.y <= customButton.frame.maxY - offset{
                        print("min:\(customButton.frame.minY), max:\(customButton.frame.maxY)")
                
                        showViewController()
                    }
                }
            }
        }


}

