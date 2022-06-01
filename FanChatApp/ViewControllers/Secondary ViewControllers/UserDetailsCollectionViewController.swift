//
//  UserDetailsCollectionViewController.swift
//  FanChatApp
//
//  Created by max on 25.05.2022.
//

import UIKit
import Firebase

class UserDetailsCollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    let headerId = "headerId"
    private var collectionView: UICollectionView?
    var user: User?
    var viewModel: UserDetailsViewModelProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupUI()

    }

    private func setupUI() {
        view.backgroundColor = .blue
        title = user?.username
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: view.frame.size.width - 10, height: view.frame.size.width / 2)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        guard let collectionView = collectionView else { return }
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
        collectionView.register(UserDetailsPostCollectionViewCell.self,
                                forCellWithReuseIdentifier: UserDetailsPostCollectionViewCell.identifier)
        collectionView.register(UserDetailsHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func setupViewModel() {
        viewModel = UserDetailsViewModel()
        guard let uid = user?.uid else { return }
        print (uid)
        viewModel.fetchUserPosts(user: uid) {
            self.collectionView?.reloadData()
            print (self.viewModel.userPosts.count)
        }
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print ("NUMBER OF ITEMS \(viewModel.numberOfItems())")
        return viewModel.numberOfItems()
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserDetailsPostCollectionViewCell.identifier,
                                                       for: indexPath) as! UserDetailsPostCollectionViewCell
        cell.userProfileImageView.loadImage(urlString: viewModel.userPosts[indexPath.item].imageUrl)
        cell.userNameLabel.text = viewModel.userPosts[indexPath.item].userName
        cell.postLabel.text = viewModel.userPosts[indexPath.item].caption
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                     withReuseIdentifier: headerId,
                                                                     for: indexPath) as! UserDetailsHeader
        if let user = user {
            header.userImage.loadImage(urlString: user.profileImageUrl)
            header.detailsLabel.text = "Recent posts by \(user.username):"
        }
        return header
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 200)
    }


}
