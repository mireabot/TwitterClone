//
//  ProfileController.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/21/22.
//

import Foundation
import UIKit
import Firebase

private let reuseIdentifier = "TweetCell"
private let headerIdentifier = "ProfileHeader"

class ProfileController : UICollectionViewController {
    //MARK: - Properties
    private var user: UserModel
    
    private var tweets = [TweetModel]() {
        didSet {
            collectionView.reloadData()
        }
    }
    
    //MARK:  - LifeCycle
    
    init(user: UserModel) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        fetchTweets()
        checkFollowing()
        fetchUserStats()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isHidden = true
    }
    
    //MARK: - Selectors
    
    //MARK: - API
    
    func fetchTweets() {
        TweetService.shared.fetchTweets(forUser: user) { tweets in
            self.tweets = tweets
            self.collectionView.reloadData()
        }
    }
    
    func checkFollowing() {
        UserService.shared.checkFollowing(uid: user.uid) { isFollow in
            self.user.isFollowed = isFollow
            self.collectionView.reloadData()
        }
    }
    
    func fetchUserStats() {
        UserService.shared.fetchUserStats(uid: user.uid) { stats in
            print("DEBUG: User has stats followers \(stats.followers) and following \(stats.following)")
            self.user.stats = stats
            self.collectionView.reloadData()
        }
    }
    
    //MARK: - Helpers
    
    func configureCollectionView() {
        collectionView.backgroundColor = .white
        collectionView.contentInsetAdjustmentBehavior = .never
        collectionView.register(TweetCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.register(ProfileHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerIdentifier)
        
        guard let tableHeight = tabBarController?.tabBar.frame.height else { return }
        collectionView.contentInset.bottom = tableHeight
    }
}
    //MARK: - UICollectionViewData

extension ProfileController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweets.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! TweetCell
        
        cell.tweet = tweets[indexPath.row]
        return cell
    }
}
    // MARK: - UICollectionViewDelegate

extension ProfileController {
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerIdentifier, for: indexPath) as! ProfileHeader
        
        header.user = user
        header.delegate = self
        
        return header
    }
}

extension ProfileController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 300)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewModel = TweetViewModel(tweet: tweets[indexPath.row])
        let height = viewModel.size(forWidth: view.frame.width).height
        
        return CGSize(width: view.frame.width, height: height + 75)
    }
}
//MARK: - Header Delegate

extension ProfileController: ProfileHeaderDelegate {
    func handleEditServiceButton(_ header: ProfileHeader) {
        print("DEBUG: User is followed is \(user.isFollowed) before tap")
        
        if user.isCurrentUser {
            
            let alert = UIAlertController(title: "Are you sure?", message: "Do you want to log out?", preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Log Out", style: .destructive, handler: { _ in
                do {
                    try Auth.auth().signOut()
                    
                    let nav = UINavigationController(rootViewController: LoginViewController())
                    nav.modalPresentationStyle = .fullScreen
                    self.present(nav,animated: true, completion: nil)
                    
                }
                catch let error {
                    print("DEBUG: Failed with \(error.localizedDescription)")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            
            present(alert, animated: true)
            
            return
        }
        
        if user.isFollowed {
            UserService.shared.unfollow(uid: user.uid) { (err, ref) in
                self.user.isFollowed = false
                //header.serviceButton.setTitle("Follow", for: .normal)
                self.collectionView.reloadData()
            }
        }
        
        if !user.isFollowed {
            UserService.shared.followUser(uid: user.uid) { (ref, error) in
                self.user.isFollowed = true
                //header.serviceButton.setTitle("Following", for: .normal)
                self.collectionView.reloadData()
                
                NotificationService.shared.uploadNotificationType(type: .follow, user: self.user)
            }
        }
    }
    
    func handleDismissal() {
        navigationController?.popViewController(animated: true)
    }
}
