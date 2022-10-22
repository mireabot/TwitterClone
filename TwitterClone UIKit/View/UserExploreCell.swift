//
//  UserExploreCell.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/22/22.
//

import Foundation
import UIKit
import SDWebImage

class UserExploreCell : UITableViewCell {
    // MARK: - Properties
    
    var userManager: UserModel? {
        didSet {
            configure()
        }
    }
    
    private lazy var profileImageView : UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.setDimensions(width: 40, height: 40)
        iv.layer.cornerRadius = 40 / 2
        iv.backgroundColor = .twitterBlue
        
        return iv
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "@username"
        
        return label
    }()
    
    private let fullNameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.text = "Full name"
        
        return label
    }()
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageView)
        profileImageView.centerY(inView: self,leftAnchor: leftAnchor,paddingLeft: 12)
        
        let userInfoStack = UIStackView(arrangedSubviews: [usernameLabel, fullNameLabel])
        userInfoStack.axis = .vertical
        userInfoStack.distribution = .fillEqually
        userInfoStack.spacing = 5
        userInfoStack.alignment = .leading
        addSubview(userInfoStack)
        
        userInfoStack.centerY(inView: self, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Helpers
    
    func configure() {
        guard let user = userManager else { return }
        
        usernameLabel.text = user.username
        fullNameLabel.text = user.fullName
        
        guard let profileURL = URL(string: user.profileImageURL) else { return }
        profileImageView.sd_setImage(with: profileURL)
        
    }
    
}
