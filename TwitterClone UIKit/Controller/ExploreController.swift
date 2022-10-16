//
//  ExploreController.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/14/22.
//

import Foundation
import UIKit

class ExploreController: UITabBarController {
    
    // MARK: - Properties
    
    
    //MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Explore"
    }
}
