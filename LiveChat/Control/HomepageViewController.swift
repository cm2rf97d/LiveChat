//
//  HomepageViewController.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit

class HomepageViewController: UIViewController
{
    let homepageview = HomePageView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func loadView()
    {
        self.view = homepageview
    }
}
