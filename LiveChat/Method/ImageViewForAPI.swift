//
//  ImageViewForAPI.swift
//  LiveChat
//
//  Created by 董恩志 on 2021/4/26.
//

import UIKit

class ImageViewForAPI: UIImageView {

    static var cache = NSCache<AnyObject, UIImage>()
    //判斷圖片 url 是否相同
    var url: URL?
    
    func setImage(url: URL){
        self.url = url
        //如果 cache，不網路請求
        if let cachedImage = ImageViewForAPI.cache.object(forKey: self.url as AnyObject) {
            self.image = cachedImage
            print("You get image from cache")
        }else{
            //如果沒有 cache，網路請求
            URLSession.shared.dataTask(with: url){(data,response,error) in
                if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    DispatchQueue.main.async {
                        //判斷式
                        if url == self.url {
                            let cachedImage = UIImage(data: data)
                            self.image = cachedImage
                            ImageViewForAPI.cache.setObject(cachedImage!, forKey: url as AnyObject)
                            print("You get image from \(url)")
                        }else{
                            print("123")
                        }
                    }
                    
                }
            }.resume()
            
        }
    }

}
