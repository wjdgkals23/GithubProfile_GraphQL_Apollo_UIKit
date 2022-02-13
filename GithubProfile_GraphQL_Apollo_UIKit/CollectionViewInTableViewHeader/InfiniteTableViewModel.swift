//
//  InfiniteTableViewModel.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/12.
//

import Foundation
import RxCocoa
import RxSwift

struct Item: Hashable {
    let uuid = UUID()
    var text: String
}

final class InfiniteTableViewModel: InfiniteTableViewModelBindable {
    // input
    let viewDidLoad = PublishRelay<Void>()
    let loadMoreData = PublishRelay<LastRowIndex>()
    
    // output
    let reloadTableView: Driver<[Item]>
    let shouldShowLoadView: Driver<Bool>
    
    init() {
        let loadMoreWhenDistinct = loadMoreData
            .distinctUntilChanged()
            .share()

        let loadedSignal = Observable<Void>
            .merge(
                viewDidLoad.asObservable(),
                loadMoreWhenDistinct.map { _ in Void() }
            )
            .delay(.seconds(2), scheduler: ConcurrentMainScheduler.instance) // 서버에서 동작하는 것처럼 꾸미기
            .share()
        
        self.shouldShowLoadView = Observable
            .merge(
                loadMoreWhenDistinct.map { _ in true },
                loadedSignal.map { _ in false }
            )
            .asDriver(onErrorJustReturn: true)
        
        self.reloadTableView = loadedSignal
            .map { _ in
                return [Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA"),Item(text: "AAA")]
            }
            .asDriver(onErrorJustReturn: [])
    }
}
