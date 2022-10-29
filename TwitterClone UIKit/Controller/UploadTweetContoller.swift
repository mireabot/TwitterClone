//
//  UploadTweetContoller.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/20/22.
//

import Foundation
import UIKit
import SDWebImage


class UploadTweetController : UIViewController {
    // MARK: - Properties
    
    private let user: UserModel
    private let config: UploadTweetConfig
    private lazy var viewModel = UploadTweetViewModel(config: config)
    
    private lazy var actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .twitterBlue
        button.setTitle("Tweet", for: .normal)
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17)
        button.setTitleColor(UIColor.white, for: .normal)
        
        button.frame = CGRect(x: 0, y: 0, width: 64, height: 32)
        button.layer.cornerRadius = 32 / 2
        
        button.addTarget(self, action: #selector(handleUpload), for: .touchUpInside)
        return button
    }()
    
    private let profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 48, height: 48)
        iv.layer.cornerRadius = 48 / 2
        return iv
    }()
    
    private lazy var replyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        label.text = "Reply to @mireabot"
        
        return label
    }()
    
    private let captionTextView = CaptionTextView()
    
    
    //MARK: - Lifecycle
    
    init(user: UserModel, config: UploadTweetConfig) {
        self.user = user
        self.config = config
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        
        print("DEBUG: User is \(user.username)")
    }
    
    // MARK: - Selectors
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleUpload() {
        guard let caption = captionTextView.text else { return }
        TweetService.shared.uploadTweet(type: config, caption: caption) { (error, ref) in
            if let error = error {
                print("DEBUG: Error \(error.localizedDescription)")
                return
            }
            
            if case .reply(let tweet) = self.config {
                NotificationService.shared.uploadNotificationType(type: .reply, tweet: tweet)
            }
            
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - API
    
    //MARK: - Helpers
    func configureUI() {
        view.backgroundColor = .white
        
        configurenavigationBar()
        
        let stack = UIStackView(arrangedSubviews: [profileImageView, captionTextView])
        stack.axis = .horizontal
        stack.spacing = 12
        stack.alignment = .leading
        
        /*
        view.addSubview(stack)
        stack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 16, paddingLeft: 16,paddingRight: 16) */
        
        let replyStack = UIStackView(arrangedSubviews: [replyLabel, stack])
        replyStack.axis = .vertical
        replyStack.spacing = 12
        //replyStack.alignment = .leading
        
        
        view.addSubview(replyStack)
        replyStack.anchor(top: view.safeAreaLayoutGuide.topAnchor, left: view.leftAnchor,right: view.rightAnchor, paddingTop: 16, paddingLeft: 16,paddingRight: 16)
        
        guard let profileImageURL = URL(string: user.profileImageURL) else { return }
        profileImageView.sd_setImage(with: profileImageURL, completed: nil)
        profileImageView.layer.masksToBounds = true
        
        // Configure ReplyUI
        
        actionButton.setTitle(viewModel.buttonTitle, for: .normal)
        captionTextView.placeHolder.text = viewModel.placeholderTitle
        
        replyLabel.isHidden = !viewModel.shouldShowReply
        
        guard let replyText = viewModel.replyText else { return }
        replyLabel.text = replyText
    }
    
    func configurenavigationBar() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = navigationController?.navigationBar.standardAppearance
         
        navigationController?.navigationBar.backgroundColor = .white
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: actionButton)
    }
}
