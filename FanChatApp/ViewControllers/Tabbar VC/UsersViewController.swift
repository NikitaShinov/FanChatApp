//
//  ChatViewController.swift
//  FanChatApp
//
//  Created by max on 22.03.2022.
//

import UIKit

class UsersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var viewModel: UsersViewModelProtocol!
    
    var collectionView: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViewModel()
        setupUI()
        setupLayout()
        setupCollectionView()
    }
    
    private func setupUI() {
        title = "Users"
    }
    
    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width / 3) - 1,
                                 height: (view.frame.size.width / 3) - 1)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    }
    
    private func setupCollectionView() {
        guard let collectionView = collectionView else { return }
        collectionView.register(UserCollectionViewCell.self,
                                forCellWithReuseIdentifier: UserCollectionViewCell.identifier)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.frame = view.bounds
        view.addSubview(collectionView)
    }
    
    private func setupViewModel() {
        viewModel = UsersViewModel()
        viewModel.getUsers {
            self.collectionView?.reloadData()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print ("NUMBER OF USERS ON USERCOLLECTION:\(viewModel.numberOfUsers())")
        return viewModel.numberOfUsers()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserCollectionViewCell.identifier, for: indexPath) as! UserCollectionViewCell
        cell.viewModel = viewModel.userCellViewModel(at: indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }

}

