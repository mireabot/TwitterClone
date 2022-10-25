//
//  MainTabController.swift
//  TwitterClone UIKit
//
//  Created by Mikhail Kolkov on 10/14/22.
//

import UIKit
import Firebase

class MainTabController: UITabBarController {
    
    // MARK: - Properties
    
    var user: UserModel? {
        didSet {
            guard let nav = viewControllers?[0] as? UINavigationController else { return }
            guard let feed = nav.viewControllers.first as? FeedViewController else { return }
            
            feed.user = user
        }
    }
    
    let actionButton : UIButton = {
        let button = UIButton(type: .system)
        button.tintColor = .white
        button.backgroundColor = .twitterBlue
        button.setImage(UIImage(named: "new_tweet"), for: .normal)
        button.addTarget(self, action: #selector(handleActionButtonTapped), for: .touchUpInside)
        return button
    }()
    
    //MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        logOut()
        view.backgroundColor = .twitterBlue
        authUserandUpdateUI()
        
    }
    //    MARK: - API Section
    
    func fetchUser() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        UserService.shared.fetchUser(uid: uid) { user in
            self.user = user
        }
    }
    
    func authUserandUpdateUI() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let nav = UINavigationController(rootViewController: LoginViewController())
                nav.modalPresentationStyle = .fullScreen
                self.present(nav,animated: true, completion: nil)
            }
        }
        else {
            configureViewController()
            configureUI()
            fetchUser()
        }
    }
    
    func logOut() {
        do {
            try Auth.auth().signOut()
        }
        catch let error {
            print("DEBUG: Failed with \(error.localizedDescription)")
        }
    }
    //MARK: - Selectors
    @objc func handleActionButtonTapped() {
        guard let user = user else { return }
        let controller = UploadTweetController(user: user, config: .tweet)
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    
    //MARK: - Helpers
    
    func configureUI() {
        view.addSubview(actionButton)
        actionButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor, paddingBottom: 64, paddingRight: 16, width: 56, height: 56)
        actionButton.layer.cornerRadius = 56 / 2
        
    }
    
    func configureViewController() {
        let feed = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        let nav1 = templateNavController(image: UIImage(named: "home_unselected"), rootViewController: feed)
        
        let explore = ExploreController()
        let nav2 = templateNavController(image: UIImage(named: "search_unselected"), rootViewController: explore)
        
        let notifications = NotificationsViewController()
        let nav3 = templateNavController(image: UIImage(named: "like_unselected"), rootViewController: notifications)
        
        let messaging = MessagingViewController()
        let nav4 = templateNavController(image: UIImage(named: "ic_mail_outline_white_2x-1"), rootViewController: messaging)
        
        viewControllers = [nav1, nav2, nav3, nav4]
    }
    
    func templateNavController(image: UIImage?, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = image
        nav.navigationBar.barTintColor = .white
        nav.navigationBar.tintColor = .twitterBlue
        return nav
    }
}
