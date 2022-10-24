//
//  TweetHeader.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/23/22.
//

import Foundation
import UIKit
import SDWebImage

class TweetHeader: UICollectionReusableView {
    //MARK: - Properties
    
    var tweet: TweetModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        iv.backgroundColor = .twitterBlue
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleProfileImageTapped))
        iv.addGestureRecognizer(tap)
        iv.isUserInteractionEnabled = true
        
        return iv
    }()
    
    private let fullNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "Michael Kolkov"
        return label
    }()
    
    private let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "@mireabot"
        return label
    }()
    
    private let captionLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.text = "Text"
        label.numberOfLines = 0
        
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .left
        label.text = "Date"
        
        return label
    }()
    
    private let optionButton: UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .lightGray
        button.setImage(UIImage(named: "down_arrow_24pt"), for: .normal)
        button.addTarget(self, action: #selector(handleActionSheet), for: .touchUpInside)
        
        return button
    }()
    
    private lazy var statsView: UIView = {
        let view = UIView()
        
        let TopDivider = UIView()
        TopDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(TopDivider)
        TopDivider.anchor(top: view.topAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        let stack = UIStackView(arrangedSubviews: [likesLabel, retweetLabel])
        stack.axis = .horizontal
        stack.spacing = 12
        
        view.addSubview(stack)
        stack.centerY(inView: view)
        stack.anchor(left: view.leftAnchor, paddingLeft: 16)
        
        let bottomDivider = UIView()
        bottomDivider.backgroundColor = .systemGroupedBackground
        view.addSubview(bottomDivider)
        bottomDivider.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, height: 1.0)
        
        
        return view
    }()
    
    private let likesLabel = UILabel()
    
    private let retweetLabel = UILabel()
    
    private lazy var commentButton : UIButton = {
        let button = createButton(withImage: "comment")
        button.addTarget(self, action: #selector(handleCommentButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var retweetButton : UIButton = {
        let button = createButton(withImage: "retweet")
        button.addTarget(self, action: #selector(handleRetweetButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var likeButton : UIButton = {
        let button = createButton(withImage: "like")
        button.addTarget(self, action: #selector(handleLikeButton), for: .touchUpInside)
        return button
    }()
    
    private lazy var shareButton : UIButton = {
        let button = createButton(withImage: "share")
        button.addTarget(self, action: #selector(handleShareButton), for: .touchUpInside)
        return button
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        
        let profileStack = UIStackView(arrangedSubviews: [fullNameLabel, userNameLabel])
        profileStack.axis = .vertical
        profileStack.spacing = 2
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, profileStack])
        stack.axis = .horizontal
        stack.spacing = 12
        
        addSubview(stack)
        stack.anchor(top: topAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(optionButton)
        optionButton.anchor(top: topAnchor, right: rightAnchor, paddingTop: 16, paddingRight: 16)
        
        addSubview(captionLabel)
        captionLabel.anchor(top: stack.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, paddingLeft: 16, paddingRight: 16)
        
        addSubview(dateLabel)
        dateLabel.anchor(top: captionLabel.bottomAnchor, left: leftAnchor, paddingTop: 16, paddingLeft: 16)
        
        addSubview(statsView)
        statsView.anchor(top: dateLabel.bottomAnchor, left: leftAnchor, right: rightAnchor, paddingTop: 16, height: 40)
        
        let buttonStack = UIStackView(arrangedSubviews: [commentButton, retweetButton, likeButton, shareButton])
        buttonStack.axis = .horizontal
        buttonStack.spacing = 70
        
        addSubview(buttonStack)
        buttonStack.centerX(inView: self)
        buttonStack.anchor(top: statsView.bottomAnchor, paddingTop: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func createButton(withImage image: String) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: image), for: .normal)
        button.tintColor = .darkGray
        button.setDimensions(width: 20, height: 20)
        return button
    }
    
    func configure() {
        guard let tweet = tweet else { return }
        let viewModel = TweetViewModel(tweet: tweet)
        
        captionLabel.text = viewModel.tweet.caption
        fullNameLabel.text = viewModel.user.fullName
        userNameLabel.text = viewModel.username
        profileImageView.sd_setImage(with: viewModel.profileImageURL)
        dateLabel.text = viewModel.headerTimeStamp
        likesLabel.attributedText = viewModel.likeString
        retweetLabel.attributedText = viewModel.retweetString
    }
    
    //MARK: - Selectors
    
    @objc func handleProfileImageTapped() {
        print("DEBUG: Open user profile")
        //delegate?.handleProfileImageTapped(self)
    }
    
    @objc func handleActionSheet() {
        print("DEBUG: Show action sheet")
    }
    
    @objc func handleCommentButton() {
        print("DEBUG: Comment button tapped")
    }
    
    @objc func handleRetweetButton() {
        print("DEBUG: Retweet button tapped")
    }
    
    @objc func handleLikeButton() {
        print("DEBUG: Like button tapped")
    }
    
    @objc func handleShareButton() {
        print("DEBUG: Share button tapped")
    }
}
