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
    
    private let userImage: CustomImageView = {
        let image = CustomImageView()
        image.layer.masksToBounds = true
        image.backgroundColor = .white
        return image
    }()
    
    private let detailsLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    private let divider: UIView = {
        let label = UIView()
        label.backgroundColor = UIColor.systemPurple
        return label
    }()
    
    private let collection: UICollectionView = {
        let collection = UICollectionView()
        return collection
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        setupScrollView()
    }
    
    private func setupUI() {
        guard let userName = user?.username else { return }
        title = userName
        detailsLabel.text = "\(userName)'s recent posts:"
        guard let image = user?.profileImageUrl else { return }
        userImage.loadImage(urlString: image)
        view.backgroundColor = .systemBackground
    }
    
    private func setupScrollView() {
        view.addSubview(scrollView)
        scrollView.addSubview(userImage)
        scrollView.addSubview(detailsLabel)
        scrollView.addSubview(divider)
        scrollView.addSubview(collection)
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
        
        detailsLabel.frame = CGRect(x: 20,
                                    y: userImage.bottom + 30,
                                    width: scrollView.width,
                                    height: 30)
        
        divider.frame = CGRect(x: 0,
                               y: detailsLabel.bottom + 5,
                               width: scrollView.width,
                               height: 1)
        

        
    }
    
}
