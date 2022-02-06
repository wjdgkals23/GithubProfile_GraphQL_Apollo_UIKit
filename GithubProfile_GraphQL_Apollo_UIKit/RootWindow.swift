//
//  RootWindow.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/06.
//

import UIKit

class RootWindow: UIWindow {
    
    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        
        self.rootViewController = ViewController()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setViewController() {
        self.makeKeyAndVisible()
    }
}
