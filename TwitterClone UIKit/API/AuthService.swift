//
//  AuthService.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/19/22.
//

import Foundation
import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}
struct AuthService {
    static let shared = AuthService()
    
    func logUser(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        print("DEBUG: Email \(email) password \(password)")
    }
    
    func registerUser(credentials: AuthCredentials, completion: @escaping(Error?, DatabaseReference)->Void) {
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else { return }
        let fileName = NSUUID().uuidString
        let storageRef = STORAGE_PROFILE_IMAGES.child(fileName)
        
        
        
        storageRef.putData(imageData, metadata: nil) { (error, meta) in
            storageRef.downloadURL { (url, error) in
                guard let profileImageURL = url?.absoluteString else { return }
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        print("Sign Up error \(error.localizedDescription)")
                        return
                    }
                    
                    guard let uid = result?.user.uid else { return }
                    
                    // print("DEBUG: Registration User")
                    let values = ["email": credentials.email, "username": credentials.userName, "fullName": credentials.fullName, "profileImageURL": profileImageURL]
                    
                    REF_USERS.child(uid).updateChildValues(values, withCompletionBlock: completion)
//                    REF_USERS.child(uid).updateChildValues(values) { (error, ref) in
//                        print("Updated user information")
//                    }
                }
            }
        }
    }
}
