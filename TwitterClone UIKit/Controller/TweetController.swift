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
        
        print("DEBUG: Tweet \(tweet)")
        
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
        
        return header
    }
}
