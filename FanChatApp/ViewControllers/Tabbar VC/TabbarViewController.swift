//
//  TabbarViewController.swift
//  FanChatApp
//
//  Created by max on 14.05.2022.
//

import UIKit
import Firebase
import RAMAnimatedTabBarController

class MainTabbarViewController: RAMAnimatedTabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.delegate = self
        
        DispatchQueue.main.async {
            if Auth.auth().currentUser == nil {
                //showing if not logged in
                let loginController = LoginViewController()
                let navController = UINavigationController(rootViewController: loginController)
                navController.modalPresentationStyle = .fullScreen
                self.present(navController, animated: true, completion: nil)
            }
        }
        
        setupTabBar()
        setupMiddleButton()

    }

    
    func setupTabBar() {
        
        let controller1 = FeedViewController()
        controller1.tabBarItem = RAMAnimatedTabBarItem(title: "Feed",
                                                       image: UIImage(systemName: "newspaper"),
                                                       tag: 1)
        (controller1.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMRotationAnimation()
        let nav1 = UINavigationController(rootViewController: controller1)
        
        let controller2 = UsersViewController()
        controller2.tabBarItem = RAMAnimatedTabBarItem(title: "Users",
                                                       image: UIImage(systemName: "person.2"),
                                                       tag: 2)
        (controller2.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMRotationAnimation()
        let nav2 = UINavigationController(rootViewController: controller2)
        
        let controller3 = ResultsViewController()
        controller3.tabBarItem = RAMAnimatedTabBarItem(title: "Results",
                                                       image: UIImage(systemName: "timer.square"),
                                                       tag: 3)
        (controller3.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMRotationAnimation()
        let nav3 = UINavigationController(rootViewController: controller3)
        
        let controller4 = ProfileViewController()
        controller4.tabBarItem = RAMAnimatedTabBarItem(title: "Profile",
                                                       image: UIImage(systemName: "person"),
                                                       tag: 4)
        (controller4.tabBarItem as? RAMAnimatedTabBarItem)?.animation = RAMRotationAnimation()
        let nav4 = UINavigationController(rootViewController: controller4)
        
//        tabBarController?.tabBar.isTranslucent = true

        viewControllers = [nav1, nav2, nav3, nav4]

    }
    
    func setupMiddleButton() {
        let plusButton = UIButton(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
        var menuButtonFrame = plusButton.frame
        menuButtonFrame.origin.y = view.bounds.height - menuButtonFrame.height - 40
        menuButtonFrame.origin.x = view.bounds.width/2 - menuButtonFrame.size.width/2
        plusButton.frame = menuButtonFrame
        
        plusButton.layer.cornerRadius = menuButtonFrame.height/2
        
        plusButton.setBackgroundImage(UIImage(named: "plus-1"), for: .normal)
        plusButton.addTarget(self, action: #selector(menuButtonAction), for: .touchUpInside)
        view.addSubview(plusButton)
        
        view.layoutIfNeeded()
    }
    
    // MARK: - Actions
    
    @objc private func menuButtonAction() {
        setupAlertController()
    }
    
    func setupAlertController() {
        let alert = UIAlertController(title: "Choose", message: "message type", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Text", style: .default, handler: { _ in
            
        }))
        
        alert.addAction(UIAlertAction(title: "Photo", style: .default, handler: { _ in
            print ("CAMERA CHOSEN")
            let cameraController = CameraController()
    //        let cameraNavController = UINavigationController(rootViewController: cameraController)
            cameraController.modalPresentationStyle = .fullScreen
    //        present(cameraController, animated: true, completion: nil)
            self.present(cameraController, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .destructive, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
