//
//  NotificationViewModel.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/28/22.
//

import UIKit


struct NotificationViewModel {
    
    private let notification: NotificationModel
    
    private let type: NotificationType
    
    private let user: UserModel
    
    var timeStampText: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        let now = Date()
        
        return formatter.string(from: notification.timeStamp, to: now) ?? "2mins"
    }
    
    var message: String {
        switch type {
        case .follow:
            return " followed you"
        case .like:
            return " liked your tweet"
        case .reply:
            return " replied to your tweet"
        case .retweet:
            return " retweeted your tweet"
        case .mention:
            return " mentonied you"
        }
    }
    
    var notificationText: NSAttributedString? {
        guard let timeStamp = timeStampText else { return nil }
        let attributedString = NSMutableAttributedString(string: user.username, attributes: [.font : UIFont.boldSystemFont(ofSize: 14)])
        
        attributedString.append(NSAttributedString(string: message, attributes: [.font : UIFont.systemFont(ofSize: 14)]))
        
        attributedString.append(NSAttributedString(string: " \(timeStamp)", attributes: [.font : UIFont.systemFont(ofSize: 14), .foregroundColor: UIColor.lightGray]))
        
        return attributedString
    }
    
    var profileImageURL: URL? {
        return URL(string: user.profileImageURL)
    }
    
    init(notification: NotificationModel) {
        self.notification = notification
        self.type = notification.type
        self.user = notification.user
    }
}
