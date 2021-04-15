//
//  LoadingViewController.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/15.
//

import UIKit
import Lottie

class LoadingViewController: UIViewController
{
    let loadingView = LoadingView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        loadingView.test1.loopMode = .autoReverse
        loadingView.test1.play()
    }
    
    override func loadView()
    {
        self.view = loadingView
    }
}
