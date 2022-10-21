//
//  UserService.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/20/22.
//

import Foundation
import Firebase

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
}
