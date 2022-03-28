//
//  RegistrationViewModel.swift
//  FanChatApp
//
//  Created by max on 17.03.2022.
//

import Foundation


protocol TeamsViewModelProtocol: AnyObject {
    var teams: [Standing] { get }
    func getResults(completion: @escaping () -> Void)
    func numberOfItems() -> Int
    func titleForRow(for row: Int) -> String
}


class RegistrationViewModel: TeamsViewModelProtocol {
    var teams: [Standing] = []
    
    func getResults(completion: @escaping () -> Void) {
        NetworkManager.shared.getResults { [weak self] result in
            switch result {
            case .success(let data):
                guard let data = data else { return }
                self?.teams = data.standings
                completion()
            case .failure(let error):
                print (error.localizedDescription)
                completion()
            }
        }
    }
    
    func numberOfItems() -> Int {
        teams.count
    }
    
    func titleForRow(for row: Int) -> String {
        teams[row].team.name
    }
    
    
    
}
