//
//  UserService.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/20/22.
//

import Foundation
import Firebase

typealias DatabaseCompletion = ((Error?, DatabaseReference) -> Void)

struct UserService {
    
    static let shared = UserService()
    
    func fetchUser(uid: String, completion: @escaping(UserModel) -> Void) {
        
        REF_USERS.child(uid).observeSingleEvent(of: .value) { snapshot in
          //  print("DEBUG: Snapshot \(snapshot)")
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            
            let user = UserModel(uid: uid, dictionary: dictionary)
            
            completion(user)
        }
    }
    
    func fetchUsers(completion: @escaping([UserModel]) -> Void) {
        var users = [UserModel]()
        REF_USERS.observe(.childAdded) { snapshot in
            let uid = snapshot.key
            guard let dictionary = snapshot.value as? [String : AnyObject] else { return }
            
            let user = UserModel(uid: uid, dictionary: dictionary)
            users.append(user)
            
            completion(users)
        }
    }
    
    func followUser(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUID).updateChildValues([uid: 1]) { (error, ref) in
            REF_USER_FOLLOWERS.child(uid).updateChildValues([currentUID: 1], withCompletionBlock: completion)
        }
    }
    
    func unfollow(uid: String, completion: @escaping(DatabaseCompletion)) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUID).child(uid).removeValue { (err, ref) in
            REF_USER_FOLLOWERS.child(uid).child(currentUID).removeValue(completionBlock: completion)
        }
    }
    
    func checkFollowing(uid: String, completion: @escaping(Bool) -> Void) {
        guard let currentUID = Auth.auth().currentUser?.uid else { return }
        
        REF_USER_FOLLOWING.child(currentUID).child(uid).observeSingleEvent(of: .value) { snapshot in
            completion(snapshot.exists())
        }
    }
    
    func fetchUserStats(uid: String, completion: @escaping(UserStats) -> Void) {
        REF_USER_FOLLOWERS.child(uid).observeSingleEvent(of: .value) { snapshot in
            let followers = snapshot.children.allObjects.count
            print("DEBUG: Followers count \(followers)")
            
            REF_USER_FOLLOWING.child(uid).observeSingleEvent(of: .value) { snapshot in
                let following = snapshot.children.allObjects.count
                let stats = UserStats(followers: followers, following: following)
                completion(stats)
            }
        }
    }
}
