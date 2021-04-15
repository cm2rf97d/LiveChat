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
    let bannerImageView1 = UIImageView(image: UIImage(systemName: "house"))
    let bannerImageView2 = UIImageView(image: UIImage(systemName: "person"))
    let bannerImageView3 = UIImageView(image: UIImage(systemName: "pencil"))
    lazy var images = [bannerImageView1, bannerImageView2, bannerImageView3]
    var tapPageControlAction: (() -> Void)?
    
    //MARK: - IBOutlets
    
    lazy var myScrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.contentSize = CGSize(width: fullSize.width * 3, height: 200)
        bannerImageView1.frame = CGRect(x: fullSize.width * 0, y: 0, width: fullSize.width, height: 150)
        bannerImageView2.frame = CGRect(x: fullSize.width * 1, y: 0, width: fullSize.width, height: 150)
        bannerImageView3.frame = CGRect(x: fullSize.width * 2, y: 0, width: fullSize.width, height: 150)
        sv.isPagingEnabled = true
        sv.showsHorizontalScrollIndicator = false
        sv.showsVerticalScrollIndicator = false
        sv.addSubview(bannerImageView1)
        sv.addSubview(bannerImageView2)
        sv.addSubview(bannerImageView3)
        return sv
    }()
    
    lazy var pageControl: UIPageControl = {
        let pc = UIPageControl()
        pc.backgroundColor = .clear
        pc.currentPageIndicatorTintColor = .systemRed
        pc.pageIndicatorTintColor = .gray
        pc.numberOfPages = images.count
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
