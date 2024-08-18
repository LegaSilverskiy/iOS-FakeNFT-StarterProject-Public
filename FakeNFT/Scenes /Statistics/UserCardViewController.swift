//
//  UserCardViewController.swift
//  FakeNFT
//
//  Created by Andrey Zhelev on 10.08.2024.
//
import UIKit

final class UserCardViewController: UIViewController {
    
    let servicesAssembly: ServicesAssembly
    
    init(servicesAssembly: ServicesAssembly) {
        self.servicesAssembly = servicesAssembly
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
    }
    
    private func setUI() {
        view.backgroundColor = .systemBackground
    }
}
