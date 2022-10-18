//
//  Constants.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/18/22.
//

import Foundation
import Firebase

let DB_REF = Database.database().reference()
let REF_USERS = DB_REF.child("Users")
let STORAGE_REF = Storage.storage().reference()
let STORAGE_PROFILE_IMAGES = STORAGE_REF.child("profileImages")
