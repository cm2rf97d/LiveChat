//
//  TestView.swift
//  LiveChat
//
//  Created by 陳郁勳 on 2021/4/6.
//

import UIKit

class ChatroomView: UIView
{
    // MARK: - IBOutlets
        var chatTableView: UITableView = {
            let tableView = UITableView(frame: CGRect(), style: .insetGrouped)
            tableView.register(ChatroomTVCell.self, forCellReuseIdentifier: ChatroomTVCell.chatCellID)
            tableView.register(ChatroomBannerCell.self, forCellReuseIdentifier: ChatroomBannerCell.identifier)
            tableView.rowHeight = 60
            tableView.backgroundColor = .clear
            tableView.separatorStyle = .none
            
            return tableView
        }()
    
    lazy var headerView: UIView = {
        let view = UIView()
        let shapeLayer = CAShapeLayer()
        shapeLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 3
        shapeLayer.strokeColor = UIColor.systemIndigo.cgColor
        
        let path = UIBezierPath()
        let fullSizeWidth = chatTableView.frame.width
        
        path.move(to: .init(x: -22, y: 50))
        path.addQuadCurve(to: CGPoint(x: 0, y: 0), controlPoint: CGPoint(x: -18, y: 5))
        path.addLine(to: CGPoint(x: fullSizeWidth - 40, y: 0))
        path.addQuadCurve(to: CGPoint(x: fullSizeWidth - 18, y: 50), controlPoint: CGPoint(x: fullSizeWidth - 22, y: 5))
        shapeLayer.path = path.cgPath
        
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.fromValue = 0
        animation.toValue = 1
        animation.duration = 3
        shapeLayer.add(animation, forKey: nil)
        
        view.layer.addSublayer(shapeLayer)
        return view
    }()
        
        // MARK: - Autolayout
        func autoLayoutForChatTableView() {
            chatTableView.snp.makeConstraints { (make) in
                make.centerX.equalTo(self)
//                make.centerY.equalTo(self)
                make.width.equalTo(self)
//                make.height.equalTo(self)
                make.top.equalTo(self.snp.topMargin)
                make.bottom.equalTo(self.snp.bottomMargin)
            }
        }
    
    // MARK: - Init
    override init(frame: CGRect)
    {
        super.init(frame: frame)
//        self.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        addSubview(chatTableView)
        autoLayoutForChatTableView()
        setGradientLayer()
        
    }
    
    required init?(coder: NSCoder)
    {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

