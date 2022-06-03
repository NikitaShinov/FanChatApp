//
//  EnableBiometricViewController.swift
//  FanChatApp
//
//  Created by max on 03.06.2022.
//

import UIKit

class EnableBiometricViewController: UIViewController {
    
    let biometricAuth = BiometricAuth()
    var biometricType: String?
    
    private let appLogo: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "pl-logo")
        return imageView
    }()
    
    private let disclaimerLabel: UILabel = {
        let label = UILabel()
        label.text = "Keep your app safe without sacrificing the convenience by enabling the Face ID/Touch ID"
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private let serviceImage: UIImageView = {
        let image = UIImageView()
        image.clipsToBounds = true
        return image
    }()
    
    private let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(UIColor.purple, for: .normal)
        return button
    }()
    
    private let enableButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .purple
        button.setTitle("Enable", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemYellow
        setupUI()
        
        switch biometricAuth.biometricType() {
        case .faceID:
            biometricType = "Face ID"
            serviceImage.image = UIImage(systemName: "faceid")
        default:
            biometricType = "Touch ID"
            serviceImage.image = UIImage(systemName: "touchid")
        }
    }
    
    private func setupUI() {
        view.addSubview(appLogo)
        view.addSubview(disclaimerLabel)
        view.addSubview(serviceImage)
        view.addSubview(skipButton)
        view.addSubview(enableButton)
        enableButton.addTarget(self, action: #selector(enableButtonTapped), for: .touchUpInside)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let size = view.width / 3
        
        appLogo.frame = CGRect(x: (view.width / 2) - (size / 2),
                               y: 40,
                               width: size,
                               height: size * 1.5)
        
        skipButton.frame = CGRect(x: view.width - 50,
                                  y: 40,
                                  width: 40,
                                  height: 20)
        
        disclaimerLabel.frame = CGRect(x: 20,
                                       y: appLogo.bottom + 20,
                                       width: view.width - 40,
                                       height: 100)
        
        serviceImage.frame = CGRect(x: (view.width / 2) - 60,
                                    y: disclaimerLabel.bottom + 20,
                                    width: 120,
                                    height: 100)
        
        enableButton.frame = CGRect(x: view.center.x - ((view.width - 70) / 2),
                                    y: view.bottom - 80,
                                    width: view.width - 70,
                                    height: 50)
        
    }
    
    @objc private func enableButtonTapped() {
        loadMainMenu()
    }
    
    @objc private func skipButtonTapped() {
        loadMainMenu()
    }
    
    private func loadMainMenu() {
        let vc = UINavigationController(rootViewController: NewsViewController())
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true, completion: nil)
    }
}
