//
//  UserDetailsViewController.swift
//  FanChatApp
//
//  Created by max on 13.05.2022.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    var user: User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = user?.username
        
        view.backgroundColor = .yellow
    }
    
}
