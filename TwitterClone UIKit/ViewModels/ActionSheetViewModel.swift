//
//  ActionSheetViewModel.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/27/22.
//

import UIKit

struct ActionSheetViewModel {
    
    private let user: UserModel
    var sheetOption: [ActionSheetOptions] {
        var result = [ActionSheetOptions]()
        if user.isCurrentUser {
            result.append(.delete)
        }
        else {
            let followOption: ActionSheetOptions = user.isFollowed ? .unfollow(user) : .follow(user)
            result.append(followOption)
        }
        result.append(.report)
        
        return result
    }
    
    init(user: UserModel) {
        self.user = user
    }
}
enum ActionSheetOptions {
    
    case follow(UserModel)
    case unfollow(UserModel)
    case report
    case delete
    
    var description: String {
        
        switch self {
        case .follow(let userModel):
            return "Follow @\(userModel.username)"
        case .unfollow(let userModel):
            return "Unfollow @\(userModel.username)"
        case .report:
            return "Report tweet"
        case .delete:
            return "Delete tweet"
        }
    }
}
