//
//  ViewController.swift
//  CleanArchitectureProject
//
//  Created by 이수현 on 10/25/24.
//

import UIKit

class UserListViewController: UIViewController {
    
    let viewModel : UserListViewModelProtocol
    init(viewModel: UserListViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        self.view.backgroundColor = .systemRed
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


}

