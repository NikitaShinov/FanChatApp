//
//  MenuViewController.swift
//  FanChatApp
//
//  Created by max on 17.05.2022.
//

import UIKit

protocol MenuViewControllerDelegate: AnyObject {
    func didSelectViewController(vc: MenuViewController.MenuOptions)
}

class MenuViewController: UIViewController {
    
    weak var delegate: MenuViewControllerDelegate?
    
    private var viewModel: ProfileViewModelProtocol!
    
    let grayColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    
    enum MenuOptions: String, CaseIterable {
        case news = "News"
        case userFeed = "Feed"
        case users = "Users"
        case results = "Results"
        case profile = "Profile"
        case shareApp = "Share App"
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.cellId)
        table.register(MenuHeader.self, forHeaderFooterViewReuseIdentifier: MenuHeader.identifier)
        table.backgroundColor = nil
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        view.addSubview(tableView)
        view.backgroundColor = .purple
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
        tableView.separatorStyle = .none
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.cellId, for: indexPath) as! MenuTableViewCell
//        cell.viewModel = MenuCellViewModel(menuOption: MenuOptions.allCases[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelectViewController(vc: item)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier: MenuHeader.identifier) as! MenuHeader
        viewModel = ProfileViewModel()
        viewModel.getUser { user in
            view.profileName.text = user.username
            view.profileImage.loadImage(urlString: user.profileImageUrl)
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        100
    }
}
