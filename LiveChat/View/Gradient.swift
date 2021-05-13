//
//  File.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/5/13.
//

import UIKit

extension UIView {
    
    func setGradientLayer() {
        let color1 = UIColor.systemTeal.cgColor
        let color2 = UIColor.systemYellow.cgColor
        let fullSize = UIScreen.main.bounds
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = frame(forAlignmentRect: CGRect(x: 0, y: 0, width: fullSize.width, height: fullSize.height))
        gradientLayer.colors = [color1, color2]
        layer.insertSublayer(gradientLayer, at: 0)
    }
    
}
