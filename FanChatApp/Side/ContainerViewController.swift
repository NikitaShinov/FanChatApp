//
//  ContainerViewController.swift
//  FanChatApp
//
//  Created by max on 17.05.2022.
//

import UIKit

class ContainerViewController: UIViewController {
        
    enum MenuState {
        case opened
        case closed
    }
    
    private var menuState: MenuState = .closed
    
    let menuVC = MenuViewController()
    let feedVC = FeedViewController()
    let usersVC = UsersViewController()
    let resultsVC = ResultsViewController()
    var navVC: UINavigationController?

    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChildsVCs()
    }
    
    private func addChildsVCs() {
        
        menuVC.delegate = self
        addChild(menuVC)
        view.addSubview(menuVC.view)
        
        feedVC.delegate = self
        let navVC = UINavigationController(rootViewController: feedVC)
        addChild(navVC)
        view.addSubview(navVC.view)
        navVC.didMove(toParent: self)
        self.navVC = navVC
        

    }
    
}

extension ContainerViewController: HomeViewControllerDelegate {
    func didTapMenuButton() {
        print ("GOING TO MENU")
        toggleMenu(completion: nil)
    }
    
    func toggleMenu(completion: (() -> Void)?) {
        switch menuState {
        case .closed:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = self.feedVC.view.frame.size.width - 100
            } completion: { done in
                if done {
                    self.menuState = .opened
                }
            }
        case .opened:
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut) {
                self.navVC?.view.frame.origin.x = 0
            } completion: { done in
                if done {
                    self.menuState = .closed
                    DispatchQueue.main.async {
                        completion?()
                    }
                }
            }
        }
    }
}
    
extension ContainerViewController: MenuViewControllerDelegate {
    func didSelectViewController(vc: MenuViewController.MenuOptions) {
        toggleMenu { [weak self] in
            switch vc {
            case .feed:
                self?.resetToFeed()
            case .users:
                self?.goToUsers()
                break
            case .results:
                self?.goToResult()
            case .profile:
                break
            case .shareApp:
                break
            }
        }
    }
    
    func goToResult() {
//        let vc = resultsVC
//        feedVC.addChild(vc)
//        feedVC.view.addSubview(vc.view)
//        vc.didMove(toParent: feedVC)
//        vc.view.frame = view.frame
//        feedVC.title = vc.title
        let vc = UINavigationController(rootViewController: resultsVC)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func goToUsers() {
//        let vc = usersVC
//        feedVC.addChild(vc)
//        feedVC.view.addSubview(vc.view)
//        vc.didMove(toParent: feedVC)
//        vc.view.frame = view.frame
//        feedVC.title = vc.title
        let vc = UINavigationController(rootViewController: usersVC)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
    
    func resetToFeed() {
//        resultsVC.view.removeFromSuperview()
//        resultsVC.didMove(toParent: nil)
//        feedVC.title = "Feed"
        let vc = feedVC
        present(vc, animated: true, completion: nil)
    }
}
