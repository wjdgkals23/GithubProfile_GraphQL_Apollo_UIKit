//
//  RootWindowViewModel.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/11.
//

import Foundation
import RxSwift
import RxCocoa

class RootWindowViewModel {
    static let reloadSessionTime = 0
    
    let rootState: Driver<RootState>
    
    let becomeActive = PublishRelay<Date>()
    let becomeInActive = PublishRelay<Date>()
    
    let disposeBag = DisposeBag()
    
    init(model: RootWindowModel =  RootWindowModelImpl()) {
        let checkSessionWhenShouldBeActive = becomeActive
            .withLatestFrom(becomeInActive) { becomeActiveTime, becomeInActiveTime -> Bool in
                let value = becomeActiveTime.timeIntervalSince1970 - becomeInActiveTime.timeIntervalSince1970
                return Int(value) > Self.reloadSessionTime
            }
            .filter { $0 }
            .map { _ in Void() }
            .flatMapLatest(model.reVerseIsOnCurrentUser)
        
        let timer = model.isOnCurrentUser()
            .delay(.seconds(1), scheduler: MainScheduler.instance)
            .share()
        
        let initialCheckSession = Observable
            .merge(
                timer,
                model.isOnCurrentUser().skip(until: timer)
            )
            .take(1)
        
        rootState = Observable
            .merge(
                initialCheckSession,
                checkSessionWhenShouldBeActive
            )
            .asDriver(onErrorJustReturn: .signIn)
    }
}
