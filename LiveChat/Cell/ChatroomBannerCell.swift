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
    let chatRoomVC = ChatroomVC()
    var markUser: [MarkUser] = [] {
        didSet{
        chatRoomVC.chatroomView.chatTableView.reloadData()
        myCollectionView.reloadData()
        }
    }

    
    //MARK: - IBOutlets
    
    lazy var myCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
//        layout.minimumInteritemSpacing = 20
        layout.minimumLineSpacing = 20
        layout.itemSize = CGSize(width: 60, height: 60)
        
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.register(FriendsImageBannerCell.self, forCellWithReuseIdentifier: FriendsImageBannerCell.identifier)
        cv.backgroundColor = .clear
        cv.showsHorizontalScrollIndicator = false
        
        
        
        return cv
    }()
    
    //MARK: - Init
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.addSubview(myCollectionView)
        layouts()
        selectionStyle = .none
        myCollectionView.delegate = self
        myCollectionView.dataSource = self
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Set Layouts
    
    func layouts() {
        
        myCollectionView.snp.makeConstraints { (make) in
            make.edges.equalTo(contentView)
            
        }
    }

}


extension ChatroomBannerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
//            print("nnnnnnn\(self.friendsImages.count)")
//
//        }
        return markUser.count
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FriendsImageBannerCell.identifier, for: indexPath) as? FriendsImageBannerCell else { return UICollectionViewCell() }
        cell.imageView1.image = markUser[indexPath.row].userImage
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        let profileVC = ProfileViewController()
//        profileVC.friendUser = markUser[indexPath.row]
//        chatRoomVC.present(profileVC, animated: true, completion: nil)
        
    }
    
    
}
