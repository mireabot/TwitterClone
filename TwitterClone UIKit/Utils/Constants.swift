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
let REF_TWEETS = DB_REF.child("Tweets")
let REF_USER_TWEETS = DB_REF.child("User-Tweets")
let REF_USER_FOLLOWING = DB_REF.child("User-Following")
let REF_USER_FOLLOWERS = DB_REF.child("User-Followers")
let REF_TWEETS_REPLIES = DB_REF.child("Tweet-Replies")
let REF_USER_LIKES = DB_REF.child("User-Likes")
let REF_TWEET_LIKES = DB_REF.child("Twee-Likes")
