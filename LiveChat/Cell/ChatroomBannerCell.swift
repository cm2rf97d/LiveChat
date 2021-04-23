//
//  ChatroomBannerCell.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/13.
//

import UIKit

class ChatroomBannerCell: UITableViewCell {

    //MARK: - Properties
    
    let fullSize = UIScreen.main.bounds.size
    static let identifier = "chatroomBannerCell"
    var bannerViews: [UIImageView] {
        var bannerView = [UIImageView]()
        for i in 0...6 {
            let imageView = UIImageView(image: UIImage(named: "\(i)"))
            imageView.frame = CGRect(x: fullSize.width * CGFloat(i), y: 0, width: fullSize.width, height: 180)
            bannerView.append(imageView)
        }
        return bannerView
    }
    var tapPageControlAction: (() -> Void)?
    
    //MARK: - IBOutlets
    
    lazy var myScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = CGSize(width: Int(fullSize.width) * bannerViews.count, height: 200)
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        for banner in bannerViews {
            sv.addSubview(banner)
        }
        return sv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.backgroundColor = .clear
        pc.currentPageIndicatorTintColor = .systemRed
        pc.pageIndicatorTintColor = .gray
        pc.numberOfPages = bannerViews.count
        pc.currentPage = 0
        pc.isUserInteractionEnabled = true
        
        return pc
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(myScrollView)
        contentView.addSubview(pageControl)
        layouts()
        selectionStyle = .none
        pageControl.addTarget(self, action: #selector(tapPageControl), for: .touchUpInside)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func tapPageControl() {
        tapPageControlAction?()
    }
    
    //MARK: - Set Layouts
    
    func layouts() {
        myScrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(self)
        }
        
        pageControl.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.snp.bottom).offset(-10)
            make.height.equalTo(10)
            make.centerX.width.equalTo(self)
            
        }
    }

}
