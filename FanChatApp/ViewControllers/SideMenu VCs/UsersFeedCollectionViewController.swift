//
//  UsersFeedCollectionViewController.swift
//  FanChatApp
//
//  Created by max on 19.05.2022.
//

import UIKit

private let reuseIdentifier = "cellId"

class UsersFeedCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    private var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
    
    private func configure() {
        title = "Some Feed"
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
    
    @objc private func didTapClose() {
        navigationController?.dismiss(animated: true, completion: nil)
    }
    
    @objc private func createPost() {
        let vc = CreatePostViewController()
        present(vc, animated: true, completion: nil)
    }
    

    // MARK: UICollectionViewDataSource

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return 10
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! UserPostCollectionViewCell
        
        cell.postLabel.text = "POST"
    
    
        return cell
    }

}
