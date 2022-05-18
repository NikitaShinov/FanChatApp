//
//  ResultsViewController.swift
//  FanChatApp
//
//  Created by max on 22.03.2022.
//

import UIKit
import CoreMedia

class ResultsViewController: UITableViewController {
    
    private var viewModel: TeamStandingProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    private func configureUI() {
        navigationController?.navigationBar.prefersLargeTitles = true
        title = "Results"
        view.backgroundColor = .systemBackground
        tableView.register(TeamStandingCell.self, forCellReuseIdentifier: TeamStandingCell.identifier)
        viewModel = TeamStandingViewModel()
        viewModel.getResults {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        tableView.separatorStyle = .none
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.teams.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TeamStandingCell.identifier, for: indexPath) as! TeamStandingCell
        let team = viewModel.teams[indexPath.row]
        
        cell.teamRank.text = "\(indexPath.row + 1)"
        
        cell.teamName.text = team.team.name
        if let image = team.team.logos.first?.href {
            cell.teamImage.loadImage(urlString: image)
        }
        if let summary = team.note?.description {
            cell.teamSummary.text = "\(summary) zone"
            
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }

}
