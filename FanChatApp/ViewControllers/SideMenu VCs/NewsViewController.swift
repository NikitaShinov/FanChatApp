//
//  FeedViewController.swift
//  FanChatApp
//
//  Created by max on 21.03.2022.
//

import UIKit
import SafariServices

protocol HomeViewControllerDelegate: AnyObject {
    func didTapMenuButton()
}

class NewsViewController: UITableViewController {
    
    private var viewModel: FeedViewModelProtocol!
    
    weak var delegate: HomeViewControllerDelegate?
    
    let spinner = UIActivityIndicatorView(style: .large)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FeedViewModel()
        configureUI()
        print ("configuring UI")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading"), style: .done, target: self, action: #selector(didTapMenuButton))
        configureSpinnerView()
        showSpinnerLoadingView(isShowing: true)
        viewModel.getNews {
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.showSpinnerLoadingView(isShowing: false)
            }
        }
    }
    
    @objc func didTapMenuButton() {
        delegate?.didTapMenuButton()
    }
    
    private func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        
        title = "Feed"
        tableView.register(FeedTableViewCell.self,
                           forCellReuseIdentifier: FeedTableViewCell.identifier)
        tableView.refreshControl = pulltoRefresh
        view.backgroundColor = .systemBackground
        tableView.separatorStyle = .none
        
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
                }
                print ("success refreshing")
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
        170
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
