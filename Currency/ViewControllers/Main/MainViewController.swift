//
//  MainViewController.swift
//  Currency
//
//  Created by Saffi on 2022/1/26.
//

import UIKit
import RxSwift

class MainViewController: BaseCoreViewController {

    private let viewModel = MainViewControllerVM()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .white
        tableView.separatorStyle = .none
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(CurrencyHeaderView.self, forHeaderFooterViewReuseIdentifier: "CurrencyHeaderView")
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: "CurrencyCell")
        return tableView
    }()

    override func setupViews() {
        super.setupViews()

        title = "最新匯率資訊"
        view.backgroundColor = .white

        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    override func setupBinding() {
        super.setupBinding()

        LoadingView.shared.show()
        viewModel.output.reloadData
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.tableView.reloadData()
                LoadingView.shared.hide()
            }.disposed(by: self.disposeBag)
    }
}

extension MainViewController: UITableViewDataSource, UITableViewDelegate {
    // Header
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        30.0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.numerOfSection()
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: "CurrencyHeaderView")
        if let header = header as? CurrencyHeaderView {
            header.content = viewModel.headerViewTitle(section: section)
        }
        return header
    }

    // Cell
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        100.0
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRow(in: section)
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cellModel = viewModel.cellViewModel(at: indexPath) else {
            return UITableViewCell()
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell", for: indexPath)
        if let cell = cell as? CurrencyCell {
            cell.setupViewModel(viewModel: cellModel)
        }
        return cell
    }

    // didSelect
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let cellModel = viewModel.cellViewModel(at: indexPath), let object = cellModel.currencyObject else {
            return
        }
        let vm = ChartViewControllerVM(currency: object.currency, date: object.date)
        let vc = ChartViewController(with: vm)
        navigationController?.pushViewController(vc, animated: true)
    }
}
