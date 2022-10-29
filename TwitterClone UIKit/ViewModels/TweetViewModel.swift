//
//  TweetViewModel.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/21/22.
//

import Foundation
import UIKit


struct TweetViewModel {
    
    let tweet : TweetModel
    let user: UserModel
    
    var profileImageURL : URL? {
        return URL(string: user.profileImageURL)
    }
    
    var userInfoText : NSAttributedString {
        let title = NSMutableAttributedString(string: user.fullName,
                                              attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        title.append(NSAttributedString(string: " @\(user.username)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        
        title.append(NSAttributedString(string: " ・ \(timeStamp)",
                                        attributes: [.font: UIFont.systemFont(ofSize: 14),
                                                     .foregroundColor: UIColor.lightGray]))
        
        return title
    }
    
    var username: String {
        return "@\(user.username)"
    }
    
    var timeStamp : String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        return formatter.string(from: tweet.timeStamp, to: now) ?? "2mins"
    }
    
    var headerTimeStamp: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a ・ MM/dd/yyyy"
        return formatter.string(from: tweet.timeStamp)
    }
    
    var retweetString: NSAttributedString? {
        return attributedText(withValue: tweet.retweetCount, text: "Retweets")
    }
    
    var likeString: NSAttributedString? {
        return attributedText(withValue: tweet.likes, text: "Likes")
    }
    
    var likeButtonTint: UIColor {
        return tweet.didLike ? .red : .lightGray
    }
    
    var likeButtonImage: UIImage {
        let image = tweet.didLike ? "hand.thumbsup.fill" : "hand.thumbsup"
        return UIImage(systemName: image) ?? UIImage(systemName: "hand.thumbsup")!
    }
    
    init(tweet: TweetModel) {
        self.tweet = tweet
        self.user = tweet.user
    }
    
    fileprivate func attributedText(withValue value: Int, text: String) -> NSAttributedString {
        let attributedTitle = NSMutableAttributedString(string: "\(value)",
                                                        attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        
        attributedTitle.append(NSAttributedString(string: " \(text)",
                                                  attributes: [.font: UIFont.boldSystemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedTitle
    }
    
    func size(forWidth width: CGFloat) -> CGSize {
        let mesarumentLabel = UILabel()
        mesarumentLabel.text = tweet.caption
        mesarumentLabel.numberOfLines = 0
        mesarumentLabel.lineBreakMode = .byWordWrapping
        mesarumentLabel.translatesAutoresizingMaskIntoConstraints = false
        mesarumentLabel.widthAnchor.constraint(equalToConstant: width).isActive = true
        
        return mesarumentLabel.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        
    }
}
 
