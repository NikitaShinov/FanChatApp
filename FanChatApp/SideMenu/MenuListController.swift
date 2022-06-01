//
//  MenuListController.swift
//  FanChatApp
//
//  Created by max on 01.06.2022.
//

import UIKit
import SideMenu

class MenuListController: UITableViewController {
    
    private var viewModel: ProfileViewModelProtocol!
    
    enum MenuOptions: String, CaseIterable {
        case news = "News"
        case userFeed = "Feed"
        case users = "Users"
        case results = "Results"
        case profile = "Profile"
        case shareApp = "Share App"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    private func configureTableView() {
        view.backgroundColor = .purple
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.cellId)
        tableView.register(MenuHeader.self, forHeaderFooterViewReuseIdentifier: MenuHeader.identifier)
        tableView.separatorStyle = .none
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.cellId, for: indexPath) as! MenuTableViewCell
        cell.viewModel = MenuCellViewModel(menuOption: MenuOptions.allCases[indexPath.row])
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
//        let item = MenuOptions.allCases[indexPath.row]
//        switch indexPath.row {
//        case 0:
//            present(<#T##viewControllerToPresent: UIViewController##UIViewController#>, animated: <#T##Bool#>, completion: <#T##(() -> Void)?##(() -> Void)?##() -> Void#>)
//        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuHeader.identifier) as! MenuHeader
        viewModel = ProfileViewModel()
        viewModel.getUser { user in
            view.profileName.text = user.username
            view.profileImage.loadImage(urlString: user.profileImageUrl)
        }
        return view
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }
}
