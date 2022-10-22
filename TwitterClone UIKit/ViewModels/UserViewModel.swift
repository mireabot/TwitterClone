//
//  UserViewModel.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/22/22.
//

import Foundation
import UIKit

struct UserViewModel {
    let user: UserModel
    
    var profileImageURL : URL? {
        return URL(string: user.profileImageURL)
    }
    
    
    var userUsername: String {
        return user.username
    }
    
    var userFullName: String {
        return user.fullName
    }
    
    init(user: UserModel) {
        self.user = user
    }
}
