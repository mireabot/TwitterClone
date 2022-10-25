//
//  CaptionTextView.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/20/22.
//

import Foundation
import UIKit

class CaptionTextView : UITextView {
    
    // MARK: - Properties
    var placeHolder : UILabel = {
        let lb = UILabel()
        lb.font = UIFont.systemFont(ofSize: 17)
        lb.textColor = .darkGray
        lb.text = "What's going on?"
        return lb
    }()
    
    //MARK: - LifeCycle
    
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        super.init(frame: frame, textContainer: textContainer)
        
        backgroundColor = .white
        font = UIFont.systemFont(ofSize: 17)
        isScrollEnabled = false
        heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        addSubview(placeHolder)
        placeHolder.anchor(top: topAnchor, left: leftAnchor, paddingTop: 8, paddingLeft: 4)
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleTextInputChange), name: UITextView.textDidChangeNotification, object: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Selectors
    
    @objc func handleTextInputChange() {
        placeHolder.isHidden = !text.isEmpty
    }
}
