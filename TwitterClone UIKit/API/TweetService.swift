//
//  TweetService.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/20/22.
//

import Foundation
import Firebase

struct TweetService {
    static let shared = TweetService()
    
    func uploadTweet(type: UploadTweetConfig, caption: String, completion: @escaping(Error?, DatabaseReference)->Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        let values = ["uid": uid, "timeStamp": Int(NSDate().timeIntervalSince1970), "likes": 0, "retweets": 0, "caption": caption] as [String : Any]
        
        switch type {
        case .tweet:
            
            REF_TWEETS.childByAutoId().updateChildValues(values) { (err, ref) in
                // update user-tweet struct after tweet upload to main database
                guard let tweetID = ref.key else { return }
                REF_USER_TWEETS.child(uid).updateChildValues([tweetID: 1], withCompletionBlock: completion)
                
                print("DEBUG: Tweet was uploaded")
            }
            
        case .reply(let tweetModel):
            
            REF_TWEETS_REPLIES.child(tweetModel.tweetID).childByAutoId().updateChildValues(values, withCompletionBlock: completion)
            print("DEBUG: Reply was uploaded")
            
        }
    }
    
    func fetchTweets(completion: @escaping([TweetModel]) -> Void) {
        var tweets = [TweetModel]()
        
        REF_TWEETS.observe(.childAdded) { snapshot in
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            let tweetID = snapshot.key
            
            UserService.shared.fetchUser(uid: uid) { user in
                let tweet = TweetModel(user: user, tweetID: tweetID, dictionary: dictionary)
                tweets.append(tweet)
                completion(tweets)
            }
        }
    }
    
    func fetchTweets(forUser user: UserModel, completion: @escaping([TweetModel])->Void) {
        var tweets = [TweetModel]()
        
        REF_USER_TWEETS.child(user.uid).observe(.childAdded) { snapshot in
            let tweetID = snapshot.key
            
            REF_TWEETS.child(tweetID).observeSingleEvent(of: .value) { snapshot in
                guard let dictionary = snapshot.value as? [String: Any] else { return }
                guard let uid = dictionary["uid"] as? String else { return }
                
                
                UserService.shared.fetchUser(uid: uid) { user in
                    let tweet = TweetModel(user: user, tweetID: tweetID, dictionary: dictionary)
                    tweets.append(tweet)
                    completion(tweets)
                }
            }
        }
    }
    
    func fetchReplies(forTweet tweet: TweetModel, completion: @escaping([TweetModel])->Void) {
        var tweets = [TweetModel]()
        
        REF_TWEETS_REPLIES.child(tweet.tweetID).observe(.childAdded){ snapshot in
            let replyTweetID = snapshot.key
            
            guard let dictionary = snapshot.value as? [String: Any] else { return }
            guard let uid = dictionary["uid"] as? String else { return }
            
            UserService.shared.fetchUser(uid: uid) { user in
                let replyTweet = TweetModel(user: user, tweetID: replyTweetID, dictionary: dictionary)
                tweets.append(replyTweet)
                completion(tweets)
            }
        }
    }
}
