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
    
    let grayColor = UIColor(red: 33/255.0, green: 33/255.0, blue: 33/255.0, alpha: 1)
    
    enum MenuOptions: String, CaseIterable {
        case feed = "Feed"
        case users = "Users"
        case results = "Results"
        case profile = "Profile"
        case shareApp = "Share App"
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.cellId )
        table.backgroundColor = .purple
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
    }
}

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        MenuOptions.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.cellId, for: indexPath) as! MenuTableViewCell
        cell.viewModel = MenuCellViewModel(menuOption: MenuOptions.allCases[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let item = MenuOptions.allCases[indexPath.row]
        delegate?.didSelectViewController(vc: item)
    }
}
