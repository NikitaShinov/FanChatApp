//
//  UsersFeedCollectionViewController.swift
//  FanChatApp
//
//  Created by max on 19.05.2022.
//

import UIKit
import Firebase
import SideMenu

private let reuseIdentifier = "cellId"

class UsersFeedCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView?
    
    private var viewModel: UserFeedProtocol!
    
    var menu: SideMenuNavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        let updateFeedNotificationName = NSNotification.Name(rawValue: "UpdateFeed")
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleUpdateFeed), name: updateFeedNotificationName, object: nil)
    }
    
    private func configure() {
        title = "Some Feed"
        viewModel = UserFeedViewModel()
        viewModel.getUserPosts {
            self.collectionView?.reloadData()
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 10, height: view.frame.size.width / 2)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)


        guard let collectionView = collectionView else { return }
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.register(UserPostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading"), style: .done, target: self, action: #selector(didTapMenuButton))
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
//        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.bubble"), style: .done, target: self, action: #selector(createPost))
    }
    
    @objc private func handleUpdateFeed() {
        viewModel.feed.removeAll()
        viewModel.getUserPosts {
            self.collectionView?.reloadData()
        }
    }
    
    @objc private func didTapMenuButton() {
        present(menu, animated: true)
    }
    
//    @objc private func didTapClose() {
//        navigationController?.dismiss(animated: true, completion: nil)
//    }
    
    @objc private func createPost() {
        let vc = UINavigationController(rootViewController: CreatePostViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.numberOfPosts()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCollectionViewCell
        
        cell.postLabel.text = viewModel.feed[indexPath.item].caption
        cell.userNameLabel.text = viewModel.feed[indexPath.item].userName
        cell.userProfileImageView.loadImage(urlString: viewModel.feed[indexPath.item].imageUrl)
    
        return cell
    }

}
