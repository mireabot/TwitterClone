//
//  RegistrationViewController.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/16/22.
//

import Foundation
import UIKit

class RegistrationViewController: UIViewController {
    //MARK: - Properties
    
    //MARK: - LifeCycle
    
    override func viewDidLoad() {
         super.viewDidLoad()
        configureUI()
    }
    
    //MARK: - Selectors
    
    //MARK: - Helpers
    
    func configureUI(){
        view.backgroundColor = .twitterBlue
    }
}

