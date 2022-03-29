//
//  FeedViewController.swift
//  FanChatApp
//
//  Created by max on 21.03.2022.
//

import UIKit
import SafariServices

class FeedViewController: UITableViewController {
    
    private var viewModel: FeedViewModelProtocol!
    
    let spinner = UIActivityIndicatorView(style: .large)
//    {
//        didSet {
//            viewModel.getNews {
//                self.tableView.reloadData()
//                print ("Start filling the tableview")
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedViewModel()
        configureUI()
        print ("configuring UI")
        configureSpinnerView()
        showSpinnerLoadingView(isShowing: true)
        viewModel.getNews {
            self.tableView.reloadData()
            self.showSpinnerLoadingView(isShowing: false)
        }
    }
    
    private func configureUI() {
        title = "Feed"
        tableView.register(FeedTableViewCell.self,
                           forCellReuseIdentifier: FeedTableViewCell.identifier)
        tableView.refreshControl = pulltoRefresh
        view.backgroundColor = .systemBackground
        
    }
    
    let pulltoRefresh: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refreshFeed(sender:)), for: .valueChanged)
        return refreshControl
    }()
    
    @objc private func refreshFeed(sender:UIRefreshControl) {
        viewModel.refreshNews { [weak self] result in
            switch result {
            case .success(_):
                print ("refreshing")
                DispatchQueue.main.async {
                    self?.showSpinnerLoadingView(isShowing: false)
                    self?.tableView.reloadData()
                    print ("success refreshing")
                }
            case .failure(_):
                DispatchQueue.main.async {
                    self?.showSpinnerLoadingView(isShowing: false)
                    self?.showAlert(title: "Network error!", message: "Check your network connection or restart the app")
                }
            }
            
        }
        sender.endRefreshing()
    }
    
    private func showSpinnerLoadingView(isShowing: Bool) {
        if isShowing {
            self.spinner.isHidden = false
            spinner.startAnimating()
        } else if spinner.isAnimating {
            spinner.stopAnimating()
            spinner.isHidden = true
        }
    }
    
    private func configureSpinnerView() {
        
        spinner.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.addSubview(spinner)
        
        spinner.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor, constant: 0),
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor, constant: -75),
            spinner.heightAnchor.constraint(equalToConstant: 24),
            spinner.widthAnchor.constraint(equalToConstant: 24)
        ])
        spinner.isHidden = true
    }
    
    func showAlert(title: String, message: String) {
           let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
           alert.addAction(UIAlertAction(title: "Ок", style: UIAlertAction.Style.default, handler: nil))
           self.present(alert, animated: true, completion: nil)
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let item = viewModel.news[indexPath.row]
        
        let config = SFSafariViewController.Configuration()
        guard let url = URL(string: item.link) else { return }
        let safariVC = SFSafariViewController(url: url, configuration: config)
        safariVC.modalPresentationStyle = .automatic
        present(safariVC, animated: true, completion: nil)
    }
}
