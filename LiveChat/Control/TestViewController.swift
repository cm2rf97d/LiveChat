//
//  TestViewController.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit

class TestViewController: UIViewController
{
    let testView = TestView()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    override func loadView()
    {
        self.view = testView
    }
}
