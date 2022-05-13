//
//  UserDetailsViewController.swift
//  FanChatApp
//
//  Created by max on 13.05.2022.
//

import UIKit

class UserDetailsViewController: UIViewController {
    
    var user: User?
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        scrollView.isUserInteractionEnabled = true
        return scrollView
    }()
    
    lazy var userImage: CustomImageView = {
        let image = CustomImageView()
        image.layer.masksToBounds = true
        image.backgroundColor = .white
        return image
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupScrollView()
    }
    
    private func setupUI() {
        guard let userName = user?.username else { return }
        title = userName
        guard let image = user?.profileImageUrl else { return }
        userImage.loadImage(urlString: image)
        view.backgroundColor = .systemBackground
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(userImage)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        let size = scrollView.width / 3
        
        userImage.frame = CGRect(x: (scrollView.width - size)/2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        userImage.layer.cornerRadius = size / 2

        
    }
    
}
