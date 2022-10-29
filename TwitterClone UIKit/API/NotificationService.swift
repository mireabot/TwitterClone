//
//  NotificationService.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/28/22.
//

import Foundation
import Firebase

struct NotificationService {
    static let shared = NotificationService()
    
    
    func uploadNotificationType(type: NotificationType, tweet: TweetModel? = nil, user: UserModel? = nil) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        var values: [String: Any] = ["timeStamp":Int(NSDate().timeIntervalSince1970),
                                     "uid": uid,
                                     "type": type.rawValue]
        
        if let tweet = tweet {
            values["tweetID"] = tweet.tweetID
            REF_NOTIFICATIONS.child(tweet.user.uid).childByAutoId().updateChildValues(values)
        }
        else if let user = user {
            REF_NOTIFICATIONS.child(user.uid).childByAutoId().updateChildValues(values )
        }
    }
    
    func fetchNotifications(completion: @escaping([NotificationModel]) -> Void) {
        var notifications = [NotificationModel]()
        
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        REF_NOTIFICATIONS.child(uid).observeSingleEvent(of: .value) { snapshot in
            if !snapshot.exists() {
                // User has no notifications
                completion(notifications)
            }
            else {
                // User has notifications
            }
        }
        
        REF_NOTIFICATIONS.child(uid).observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            UserService.shared.fetchUser(uid: uid) { user in
                let notification = NotificationModel(user: user, dictionary: dictionary)
                notifications.append(notification)
                completion(notifications)
            }
        }
    }
}
