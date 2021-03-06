//
//  InfiniteTableViewController.swift
//  GithubProfile_GraphQL_Apollo_UIKit
//
//  Created by 정하민 on 2022/02/12.
//

import Foundation
import UIKit
import RxCocoa
import RxSwift
import SnapKit

// STEP1. TableView에 String Data 40개를 뿌린다. <DONE>
// STEP2. TableView에 마지막에 닿았을 때, 데이터를 추가생성하는 시그널을 호출한다. <DONE>
// STEP3. TableView에 마지막에 닿았을 때, 나타나는 로더뷰를 생성한다. <DONE>
// STEP4. 로더뷰 Footer로 넣기 <DONE>
// STEP5. 위로 올라갔다가, 다시 내려왔을 때 현재 data가 돌고 있다면, skip되어야한다. <DONE>
// STEP6. Performance를 위해 DiffableDataSource를 이용해보자 <DONE>

typealias LastRowIndex = Int
protocol InfiniteTableViewModelBindable {
    // input
    var viewDidLoad: PublishRelay<Void> { get }
    var loadMoreData: PublishRelay<LastRowIndex> { get }
    // output
    var reloadTableView: Driver<[Item]> { get }
    var shouldShowLoadView: Driver<Bool> { get }
}

enum Section: String {
    case main
}

final class InfiniteTableViewController: UIViewController {
    let tableView = UITableView()
    let loaderView = UIView()
    lazy var loader = UIActivityIndicatorView()

    let disposeBag = DisposeBag()

    // viewData
    var tableViewDataSource: UITableViewDiffableDataSource<Section, Item>?
    var viewModel: InfiniteTableViewModelBindable?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(InfiniteTableViewCell.self, forCellReuseIdentifier: "InfiniteTableViewCell")
        tableView.delegate = self
        
        tableViewDataSource = UITableViewDiffableDataSource<Section, Item>(tableView: self.tableView, cellProvider: { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfiniteTableViewCell") as? InfiniteTableViewCell else { return UITableViewCell() }
            cell.configure(text: item.text)
            return cell
        })
    }
    
    func bind(viewModel: InfiniteTableViewModelBindable) {
        self.viewModel = viewModel
        
        viewModel.reloadTableView
            .drive(self.rx.reloadTableView)
            .disposed(by: disposeBag)
        
        viewModel.shouldShowLoadView
            .drive(self.rx.shouldShowLoadView)
            .disposed(by: disposeBag)
    }
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.top.leading.trailing.bottom.equalToSuperview()
        }
    
        loaderView.backgroundColor = .white
        loaderView.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 50)
        
        loaderView.addSubview(loader)
        loader.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        viewModel?.viewDidLoad.accept(Void())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension Reactive where Base: InfiniteTableViewController {
    var reloadTableView: Binder<[Item]> {
        return Binder(base) { base, items in
            guard var dataSourceSnapShot = base.tableViewDataSource?.snapshot() else { return }
            if dataSourceSnapShot.sectionIdentifiers.contains(where: { section in
                return section == .main
            }) {
                dataSourceSnapShot.appendItems(items, toSection: .main)
            } else {
                dataSourceSnapShot.appendSections([.main])
                dataSourceSnapShot.appendItems(items, toSection: .main)
            }
            base.tableViewDataSource?.apply(dataSourceSnapShot)
        }
    }
    
    var shouldShowLoadView: Binder<Bool> {
        return Binder(base) { base, shouldShow in
            UIView.animate(withDuration: 0.3) { [weak base] in
                guard let base = base else { return }
                if shouldShow {
                    base.tableView.tableFooterView = base.loaderView
                    base.loader.startAnimating()
                } else {
                    base.tableView.tableFooterView = nil
                    base.loader.stopAnimating()
                }
            }
        }
    }
}

extension InfiniteTableViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, estimatedHeightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            viewModel?.loadMoreData.accept(indexPath.row)
        }
    }
}
