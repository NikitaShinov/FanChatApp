//
//  ChatViewController.swift
//  FanChatApp
//
//  Created by max on 22.03.2022.
//

import UIKit
import SideMenu

class UsersViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private var viewModel: UsersViewModelProtocol!
    
    var collectionView: UICollectionView?
    
    var menu: SideMenuNavigationController!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViewModel()
        setupLayout()
        setupCollectionView()
        setupUI()
        setupSearchBar()
        
    }
    
    private func setupSearchBar() {
        let searchController = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
    }
    
    private func setupUI() {
        title = "Users"
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading"),
                                                           style: .done,
                                                           target: self,
                                                           action: #selector(didTapMenuButton))
        navigationItem.leftBarButtonItem?.tintColor = .purple
        menu = SideMenuNavigationController(rootViewController: MenuListController())
        menu?.leftSide = true
        menu?.setNavigationBarHidden(true, animated: false)
        SideMenuManager.default.leftMenuNavigationController = menu
    }
    
    @objc private func didTapMenuButton() {
        present(menu, animated: true)
    }
    
    private func setupLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 1
        layout.minimumInteritemSpacing = 1
        layout.itemSize = CGSize(width: (view.frame.size.width / 3) - 1,
                                 height: (view.frame.size.width / 3) - 1)
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView?.keyboardDismissMode = .onDrag
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
        DispatchQueue.main.async {
            cell.viewModel = self.viewModel.userCellViewModel(at: indexPath)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("did tap cell at: \(indexPath.item)")
        
        let user = viewModel.users[indexPath.item]
        let vc = UserDetailsCollectionViewController()
        vc.user = user
        navigationController?.pushViewController(vc, animated: true)
        
    }

}

extension UsersViewController: UISearchBarDelegate {
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        guard let searchQuery = searchBar.text else { return }
        viewModel.searchUsers(with: searchQuery) {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        viewModel.getUsers {
            DispatchQueue.main.async {
                self.collectionView?.reloadData()
            }
        }
    }
}
