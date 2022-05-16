//
//  TeamStandigViewModel.swift
//  FanChatApp
//
//  Created by max on 16.05.2022.
//

import Foundation

protocol TeamStandingProtocol: AnyObject {
    var teams: [Standing] { get }
    func getResults(completion: @escaping () -> Void)
    func numberOfItems() -> Int
}

class TeamStandingViewModel: TeamStandingProtocol {
        
    var teams: [Standing] = []
    
    func getResults(completion: @escaping () -> Void) {
        NetworkManager.shared.getResults { [weak self] data in
            switch data {
            case .success(let team):
                guard let receivedteams = team?.standings else { return }
                self?.teams = receivedteams
                completion()
            case .failure(let error):
                print (error)
                completion()
            }
        }
    }
    
    func numberOfItems() -> Int {
        teams.count
    }

}
