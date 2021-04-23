//
//  LodingView.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/15.
//

import UIKit
import Lottie

class LoadingView: UIView
{
    var test1: AnimationView =
    {
        let animationView = AnimationView.init(name: "loading")
        return animationView
    }()
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        self.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addSubview(test1)
        layouts()
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    func layouts()
    {
        test1.snp.makeConstraints
        { (make) in
            make.width.equalTo(self)
            make.height.equalTo(self)
            make.centerX.equalTo(self)
            make.centerY.equalTo(self)
        }
    }
}
