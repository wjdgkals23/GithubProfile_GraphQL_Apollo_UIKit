//
//  InfiniteTableViewModel.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/12.
//

import Foundation
import RxCocoa
import RxSwift

final class InfiniteTableViewModel: InfiniteTableViewModelBindable {
    // input
    let viewDidLoad = PublishRelay<Void>()
    let loadMoreData = PublishRelay<Void>()
    
    // output
    let reloadTableView: Driver<[String]>
    let shouldShowLoadView: Driver<Bool>
    
    static let tableViewInitialDataSource: [String] = ["AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA","AAA"]
    
    init() {
        let loadedSignal = Observable<Void>
            .merge(
                viewDidLoad.asObservable(),
                loadMoreData.asObservable()
            )
            .delay(.seconds(2), scheduler: ConcurrentMainScheduler.instance)
            .share()
        
        self.shouldShowLoadView = Observable
            .merge(
                loadMoreData.map { _ in true },
                loadedSignal.map { _ in false }
            )
            .asDriver(onErrorJustReturn: true)
        
        self.reloadTableView = loadedSignal
            .map { _ in Self.tableViewInitialDataSource }
            .asDriver(onErrorJustReturn: [])
    }
}
