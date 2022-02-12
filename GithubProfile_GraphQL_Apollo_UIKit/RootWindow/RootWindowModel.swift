//
//  RootWindowModel.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/11.
//

import Foundation
import FirebaseAuth
import RxSwift
import RxCocoa

protocol RootWindowModel {
    func isOnCurrentUser() -> Observable<RootState>
    func reVerseIsOnCurrentUser() -> Observable<RootState>
}

struct RootWindowModelImpl: RootWindowModel {
    func isOnCurrentUser() -> Observable<RootState> {
        guard let _ = Auth.auth().currentUser else {
            return .just(.main)
        }
        return .just(.signIn)
    }
    
    func reVerseIsOnCurrentUser() -> Observable<RootState> {
        guard let _ = Auth.auth().currentUser else {
            return .just(.signIn)
        }
        return .just(.main)
    }
}
