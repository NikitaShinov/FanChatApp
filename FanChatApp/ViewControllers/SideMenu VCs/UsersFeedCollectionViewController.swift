//
//  UsersFeedCollectionViewController.swift
//  FanChatApp
//
//  Created by max on 19.05.2022.
//

import UIKit
import Firebase

private let reuseIdentifier = "cellId"

class UsersFeedCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView?
    
    private var viewModel: UserFeedProtocol!
    
    private var user: User?
    
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
            print("GETTING POSTS")
        }

//        viewModel.getFeed {
//            self.collectionView?.reloadData()
//        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width, height: view.frame.size.width / 2)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        view.backgroundColor = .systemBackground
        collectionView.register(UserPostCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "xmark"), style: .done, target: self, action: #selector(didTapClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus.bubble"), style: .done, target: self, action: #selector(createPost))
    }
    
    @objc private func handleUpdateFeed() {
        viewModel.feed.removeAll()
//        viewModel.getFeed {
//            print ("update feed vc")
//            self.collectionView?.reloadData()
//        }
    }
    
    @objc private func didTapClose() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func createPost() {
        let vc = UINavigationController(rootViewController: CreatePostViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
    

    // MARK: UICollectionViewDataSource

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        print (viewModel.numberOfPosts())
        return viewModel.numberOfPosts()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCollectionViewCell
        
        cell.postLabel.text = "\(indexPath.item)"
    
    
        return cell
    }

}
