//
//  MainViewControllerVM.swift
//  Currency
//
//  Created by Saffi on 2022/1/27.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class MainViewControllerVM: BaseViewModel {

    struct Output {
        let reloadData = PublishRelay<Void>()
    }

    private let disposeBag = DisposeBag()

    private(set) var output = Output()

    private var sectionTitle: [String] = []
    private var currencyObjects: [String: [CurrencyObject]] = [:]

    override init() {
        super.init()

        if DataAccessManager.shared.needsInitCurrencyData() {
            DataAccessManager.shared.initCurrencyData()
                .subscribe(onCompleted: { [weak self] in
                    self?.fetchCurrency()
                }).disposed(by: disposeBag)

        } else if DataAccessManager.shared.needsUpdateCurrency() {
            DataAccessManager.shared.updateCurrency()
                .subscribe(onCompleted: { [weak self] in
                    self?.fetchCurrency()
                }).disposed(by: disposeBag)

        } else {
            fetchCurrency()
        }
    }
}

extension MainViewControllerVM {
    // Section
    func numerOfSection() -> Int {
        return sectionTitle.count
    }

    func headerViewTitle(section: Int) -> String {
        guard section < sectionTitle.count else {
            return ""
        }
        return sectionTitle[section]
    }

    // Rows
    func numberOfRow(in section: Int) -> Int {
        guard section < currencyObjects.count else {
            return 0
        }
        let date = sectionTitle[section]
        return currencyObjects[date]?.count ?? 0
    }

    func cellViewModel(at indexPath: IndexPath) -> CurrencyCellVM? {
        guard indexPath.section < sectionTitle.count else {
            return nil
        }
        guard let objects = currencyObjects[sectionTitle[indexPath.section]], indexPath.row < objects.count else {
            return nil
        }
        let object = objects[indexPath.row]
        return CurrencyCellVM(with: object)
    }
}

private extension MainViewControllerVM {
    func fetchCurrency() {
        guard let objects = DataAccessManager.shared.getNewestCurrency(dateNumber: 2) else {
            return
        }
        var models: [String: [CurrencyObject]] = [:]
        for object in objects {
            let dateString = Date(timeIntervalSince1970: object.date).toString(format: .yyyyMMdd)
            var value = models[dateString] ?? []
            value.append(object)
            models[dateString] = value
        }
        sectionTitle = Array(models.keys).sorted(by: { $0 > $1 })
        currencyObjects = models
        output.reloadData.accept(())
    }
}
