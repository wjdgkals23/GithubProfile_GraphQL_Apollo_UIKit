//
//  RootWindow.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/06.
//

import UIKit
import RxSwift
import RxCocoa

enum RootState {
    case splash
    case main
    case signIn
}

class RootWindow: UIWindow {
    let disposeBag = DisposeBag()
    
    init(viewModel: RootWindowViewModel, windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        self.rootViewController = SplashViewController()
        self.makeKeyAndVisible()
        
        viewModel.rootState
            .drive(self.rx.setRootViewController)
            .disposed(by: disposeBag)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: RootWindow {
    var setRootViewController: Binder<RootState> {
        return Binder(base) { base, state in
            switch state {
            case .main:
                let vc = InfiniteTableViewController()
                let vm = InfiniteTableViewModel()
                vc.bind(viewModel: vm)
                
                base.rootViewController = vc
            case .splash, .signIn:
                base.rootViewController = SplashViewController()
            }
            base.makeKeyAndVisible()
            UIView.transition(with: base, duration: 0.3, options: .transitionCrossDissolve, animations: nil, completion: nil)
        }
    }
}
