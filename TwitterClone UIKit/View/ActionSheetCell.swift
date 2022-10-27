//
//  ActionSheetCell.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/27/22.
//

import UIKit

class ActionSheetCell: UITableViewCell {
    
    //MARK: - Properties
    
    var option: ActionSheetOptions? {
        didSet {
            configure()
        }
    }
    private let optionImage: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        iv.image = UIImage(named: "twitter_logo_blue")
        
        return iv
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.text = "Test option"
        
        return label
    }()
    
    //MARK: - LifeCycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(optionImage)
        optionImage.centerY(inView: self)
        optionImage.anchor(left: leftAnchor, paddingLeft: 8)
        optionImage.setDimensions(width: 36, height: 36)
        
        addSubview(titleLabel)
        titleLabel.centerY(inView: self)
        titleLabel.anchor(left: optionImage.rightAnchor, paddingLeft: 12)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //MARK: - Helpers
    func configure() {
        titleLabel.text = option?.description
    }
}
