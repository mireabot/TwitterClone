//
//  TweetModel.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/21/22.
//

import Foundation


struct TweetModel {
    let caption: String
    let tweetID: String
    let uid: String
    let likes: Int
    var timeStamp: Date!
    let retweetCount: Int
    var user: UserModel
    
    init(user: UserModel, tweetID: String, dictionary: [String : Any]) {
        self.tweetID = tweetID
        self.user = user
        
        self.caption = dictionary["caption"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.likes = dictionary["likes"] as? Int ?? 0
        self.retweetCount = dictionary["retweets"] as? Int ?? 0
        
        if let timeStamp = dictionary["timeStamp"] as? Double {
            self.timeStamp = Date(timeIntervalSince1970: timeStamp)
        }
    }
}
