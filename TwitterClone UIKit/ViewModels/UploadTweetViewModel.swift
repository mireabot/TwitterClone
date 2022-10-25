//
//  UploadTweetViewModel.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/25/22.
//

import Foundation
import UIKit

enum UploadTweetConfig {
    case tweet
    // Linked to tweet when reply
    case reply(TweetModel)
}


struct UploadTweetViewModel {
    
    let buttonTitle: String
    let placeholderTitle: String
    let shouldShowReply: Bool
    var replyText: String?
    
    init(config: UploadTweetConfig) {
        switch config {
        case .tweet:
            buttonTitle = "Tweet"
            placeholderTitle = "What's going on?"
            shouldShowReply = false
        case .reply(let tweetModel):
            buttonTitle = "Reply"
            placeholderTitle = "Tweet your reply"
            shouldShowReply = true
            replyText = "Replying to @\(tweetModel.user.username)"
        }
    }
}
