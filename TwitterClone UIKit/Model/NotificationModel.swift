//
//  NotificationModel.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/28/22.
//

import Foundation

enum NotificationType: Int {
    case follow
    case like
    case reply
    case retweet
    case mention
}

struct NotificationModel {
    let tweetID: String?
    var timeStamp: Date!
    let user: UserModel
    var tweet: TweetModel?
    var type: NotificationType!
    
    init(user: UserModel, dictionary: [String : AnyObject]) {
        self.user = user
        
        self.tweetID = dictionary["tweetID"] as? String? ?? ""
        
        if let timeStamp = dictionary["timeStamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
        
        if let type = dictionary["type"] as? Int {
            self.type = NotificationType(rawValue: type)
        }
    }
}
