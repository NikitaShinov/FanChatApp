//
//  FeedViewController.swift
//  FanChatApp
//
//  Created by max on 21.03.2022.
//

import UIKit

class FeedViewController: UITableViewController {
    
    private var viewModel: FeedViewModelProtocol! {
        didSet {
            viewModel.getNews {
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedViewModel()
        configureUI()
        
    }
    
    private func configureUI() {
        title = "Feed"
        tableView.register(FeedTableViewCell.self,
                           forCellReuseIdentifier: FeedTableViewCell.identifier)
//        tableView.refreshControl = pulltoRefresh
        view.backgroundColor = .systemBackground
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfArticles()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FeedTableViewCell.identifier,
                                                 for: indexPath) as! FeedTableViewCell
        cell.viewModel = viewModel.cellViewModel(at: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        200
    }
}
