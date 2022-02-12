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
// STEP3. TableView에 마지막에 닿았을 때, 나타나는 로더뷰를 생성한다. <DONE> => Footer로 넣기 (Footer로 지정할 경우 높이를 컨트롤하는 것이 불가)

protocol InfiniteTableViewModelBindable {
    // input
    var viewDidLoad: PublishRelay<Void> { get }
    var loadMoreData: PublishRelay<Void> { get }
    // output
    var reloadTableView: Driver<[String]> { get }
    var shouldShowLoadView: Driver<Bool> { get }
}

final class InfiniteTableViewController: UIViewController {
    let tableView = UITableView()
    let loaderView = UIView()
    lazy var loader = UIActivityIndicatorView()
    var loaderViewHeightConstraint: Constraint?

    let disposeBag = DisposeBag()

    // viewData
    var tableViewDataSource: [String]? = []
    var viewModel: InfiniteTableViewModelBindable?
    
    init() {
        super.init(nibName: nil, bundle: nil)
        
        tableView.register(InfiniteTableViewCell.self, forCellReuseIdentifier: "InfiniteTableViewCell")
        tableView.delegate = self
        tableView.dataSource = self
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
            $0.top.leading.trailing.equalToSuperview()
        }
    
        view.addSubview(loaderView)
        
        loaderView.backgroundColor = .white
        loaderView.snp.makeConstraints { [weak self] snp in
            snp.top.equalTo(tableView.snp.bottom)
            snp.leading.trailing.bottom.equalToSuperview()
            self?.loaderViewHeightConstraint = snp.height.equalTo(0).constraint
        }
        
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
    var reloadTableView: Binder<[String]> {
        return Binder(base) { base, data in
            base.tableViewDataSource?.append(contentsOf: data)
            base.tableView.reloadData()
        }
    }
    
    var shouldShowLoadView: Binder<Bool> {
        return Binder(base) { base, shouldShow in
            UIView.animate(withDuration: 0.3) { [weak base] in
                guard let base = base else { return }
                if shouldShow {
                    base.loaderViewHeightConstraint?.update(offset: 50)
                    base.loader.startAnimating()
                } else {
                    base.loaderViewHeightConstraint?.update(offset: 0)
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
}

extension InfiniteTableViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tableViewDataSource?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "InfiniteTableViewCell") as? InfiniteTableViewCell else { return UITableViewCell() }
        
        guard let data = tableViewDataSource?[indexPath.row] else {
            return UITableViewCell() }
    
        cell.configure(text: data)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == tableView.numberOfRows(inSection: indexPath.section) - 1 {
            viewModel?.loadMoreData.accept(Void())
        }
    }
}
