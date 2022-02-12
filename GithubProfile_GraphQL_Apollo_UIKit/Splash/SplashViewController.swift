//
//  SplashViewController.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/10.
//

import Foundation
import UIKit

final class SplashViewController: UIViewController {
    
    override func viewDidLoad() {
        let label = UILabel()
        label.text = "Splash"
        
        self.view.backgroundColor = .systemBlue
        self.view.addSubview(label)
        
        label.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
