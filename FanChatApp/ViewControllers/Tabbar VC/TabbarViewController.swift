//
//  TabbarViewController.swift
//  FanChatApp
//
//  Created by max on 14.05.2022.
//

import Foundation
import UIKit

class MainTabbarViewController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTabBar()
        setupMiddleButton()

    }

    
    func setupTabBar() {
        
        let controller1 = FeedViewController()
        controller1.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "newspaper"), tag: 1)
        let nav1 = UINavigationController(rootViewController: controller1)

        let controller2 = UsersViewController()
        controller2.tabBarItem = UITabBarItem(title: "Users", image: UIImage(systemName: "person.2"), tag: 2)
        let nav2 = UINavigationController(rootViewController: controller2)
        
        let controller3 = ResultsViewController()
        controller3.tabBarItem = UITabBarItem(title: "Results", image: UIImage(systemName: "timer.square"), tag: 3)
        let nav3 = UINavigationController(rootViewController: controller3)

        let controller4 = ProfileViewController()
        controller4.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 4)
        let nav4 = UINavigationController(rootViewController: controller4)

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
