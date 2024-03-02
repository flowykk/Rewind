//
//  ViewController.swift
//  Rewind
//
//  Created by Aleksa Khruleva on 18.02.2024.
//

import UIKit

final class ViewController: UIViewController {
    private let button: UIButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        view.backgroundColor = .systemTeal
        configureButton()
    }
    
    private func configureButton() {
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.setTitle("Go To Account View", for: .normal)
        button.backgroundColor = .systemBackground
        
        button.addTarget(self, action: #selector(goToAccount), for: .touchUpInside)
        
        button.setWidth(200)
        button.setHeight(50)
        button.pinCenter(to: view)
    }
    
    @objc
    private func goToAccount() {
        let vc = AccountBuilder.build()
        navigationController?.pushViewController(vc, animated: true)
    }
}
