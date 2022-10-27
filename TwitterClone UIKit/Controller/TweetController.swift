//
//  TweetController.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/23/22.
//

import Foundation
import UIKit

private let headerIdentifier = "TweetHeader"
private let reuseIdentifier = "TweetCell"

class TweetController: UICollectionViewController {
    //MARK: - Properties
    
    private let tweet: TweetModel
    
    private var replies = [TweetModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    private var actionSheet : ActionSheetLauncher!
    
    //MARK: - LifeCycle
    
    init(tweet: TweetModel) {
        self.tweet = tweet
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        configureNavBar()
        fetchRelies()
        
      //  print("DEBUG: Tweet \(tweet)")
        
    }
    
    //MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(TweetHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
    }
    
    func configureNavBar() {
        navigationItem.title = "Tweet"
    }
    
    fileprivate func showActionSheet(forUser user: UserModel) {
        actionSheet = ActionSheetLauncher(user: user)
        self.actionSheet.delegate = self
        actionSheet.showActionSheet()
    }
    
    
    //MARK: - API
    func fetchRelies() {
        TweetService.shared.fetchReplies(forTweet: tweet) { tweetReplies in
            self.replies = tweetReplies
        }
    }
}

//MARK: - UICollectionViewData
extension TweetController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return replies.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        cell.tweet = replies[indexPath.row]
        return cell
    }
}

//MARK: - UICollectionViewDelegate

extension TweetController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweet)
        let captionHeight = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: captionHeight + 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: view.frame.width, height: 120)
    }
}

// MARK: - UICollectionViewDelegate

extension TweetController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! TweetHeader
        
        header.tweet = tweet
        header.delegate = self
        
        return header
    }
}

extension TweetController : TweetHeaderDelegate {
    
    func showActionSheet() {
        if tweet.user.isCurrentUser {
            showActionSheet(forUser: tweet.user)
        }
        else {
            UserService.shared.checkFollowing(uid: tweet.user.uid) { isFollowed in
                var user = self.tweet.user
                user.isFollowed = isFollowed
                self.showActionSheet(forUser: user)
            }
        }
    }
}

//MARK: - ActionSheetLauncherDelegate


extension TweetController: ActionSheetLauncherDelegate {
    func didSelectOption(option: ActionSheetOptions) {
        switch option {
        case .follow(let userModel):
            UserService.shared.followUser(uid: userModel.uid) { (ref, err) in
                print("DEBUG: User with @\(userModel.username) is followed")
            }
        case .unfollow(let userModel):
            UserService.shared.unfollow(uid: userModel.uid) { (ref, error) in
                print("DEBUG: User with @\(userModel.username) is unfollowed")
            }
        case .report:
            print("DEBUG: Tweet reported")
        case .delete:
            print("DEBUG: Tweet deleted")
        }
    }
}
