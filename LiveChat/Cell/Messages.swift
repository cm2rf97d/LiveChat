//
//  Messages.swift
//  LiveChat
//
//  Created by Wang Sheng Ping on 2021/4/8.
//

import UIKit

struct Messages {
    
    var id: [String]
    var text: [String]
    var time: [Double]
    var type: [String]
    
    var timeChange: [String] {
        time.map { (data) -> String in
            
            let timeInterval = TimeInterval(data)
            let date = Date(timeIntervalSince1970: timeInterval)
            let formatter = DateFormatter()
            formatter.dateFormat = "HH:mm"
            let alarmTime = formatter.string(from: date)
            
            return alarmTime
        }
    }

}
