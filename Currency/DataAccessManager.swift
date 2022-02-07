//
//  DataAccessManager.swift
//  Currency
//
//  Created by Saffi on 2022/1/27.
//

import Foundation
import RxSwift
import RxCocoa
import RealmSwift
import SwiftyJSON

class DataAccessManager {

    static let shared = DataAccessManager()

    private let disposeBag = DisposeBag()

    private let realmDAO = RealmDAO()

    private var lastUpdatedDate = Date()
}

// MARK: - check & update control
extension DataAccessManager {
    func needsInitCurrencyData() -> Bool {
        guard let objects = self.realmDAO.read(type: CurrencyObject.self) else {
            return true
        }
        return objects.count <= 0
    }

    func needsUpdateCurrency() -> Bool {
        guard let newestObject = getNewestCurrency() else {
            return true
        }
        lastUpdatedDate = Date(timeIntervalSince1970: newestObject[0].date)
        return lastUpdatedDate < Date()
    }

    func initCurrencyData() -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in

            let collection = [self.fetchMonthCurrency(baseCurrency: "JPY"), self.fetchMonthCurrency(baseCurrency: "USD"), self.fetchMonthCurrency(baseCurrency: "EUR")]
            Observable.combineLatest(collection)
                .subscribe { error in
                    print("fetch history failed:", error)
                } onCompleted: {
                    observer.onCompleted()
                }.disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }

    func updateCurrency() -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in

            let collection = [self.fetchCurrency(baseCurrency: "JPY"), self.fetchCurrency(baseCurrency: "USD"), self.fetchCurrency(baseCurrency: "EUR")]
            Observable.combineLatest(collection)
                .subscribe { error in
                    print("update currency failed:", error)
                } onCompleted: {
                    observer.onCompleted()
                }.disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }
}

// MARK: - Realm controls
extension DataAccessManager {
    private func currencyMaxID() -> Int {
        guard let objects = self.realmDAO.read(type: CurrencyObject.self) else {
            return 0
        }
        return objects.count
    }

    private func updateCurrency(objects: [CurrencyObject]) {
        self.realmDAO.update(objects)
    }

    func getNewestCurrency(dateNumber: Int = 1) -> [CurrencyObject]? {
        guard let result = self.realmDAO.read(type: CurrencyObject.self) else {
            return nil
        }
        let objects: [CurrencyObject] = result.sorted(byKeyPath: "date", ascending: false).map { $0 }
        let fetchCounts = AppConfig.favoriteCurrency.count * dateNumber
        return Array(objects.prefix(fetchCounts))
    }

    func getWeekCurrency(name: String, date: Date) -> [CurrencyObject]? {
        let predicate = "currency = '\(name)'"
        guard let result = self.realmDAO.read(type: CurrencyObject.self, predicate: predicate), result.count > 0 else {
            return nil
        }
        let fromDate = date.lastWeek().timeIntervalSince1970
        let toDate = date.timeIntervalSince1970
        let objects: [CurrencyObject] = result.filter("date BETWEEN {%@, %@}", fromDate, toDate)
                                              .sorted(byKeyPath: "date")
                                              .map { $0 }
        return objects
    }
}

// MARK: - fetch API
private extension DataAccessManager {

    func fetchCurrency(baseCurrency: String) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in

            let fromDate = self.lastUpdatedDate.tomorrow().toString(format: .yyyyMMdd)
            let toDate = Date().toString(format: .yyyyMMdd)
            NetworkManager.fetchCurrency(baseCurrency: baseCurrency, fromDate: fromDate, toDate: toDate)
                .subscribe { [weak self] currencyModel in
                    guard let objects = self?.parsedModel(queryCurrency: baseCurrency, model: currencyModel) else {
                        return
                    }
                    self?.updateCurrency(objects: objects)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }.disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }

    func fetchMonthCurrency(baseCurrency: String) -> Observable<Void> {
        return Observable<Void>.create { observer -> Disposable in

            let fromDate = Date().lastMonth().toString(format: .yyyyMMdd)
            let toDate = Date().toString(format: .yyyyMMdd)
            NetworkManager.fetchCurrency(baseCurrency: baseCurrency, fromDate: fromDate, toDate: toDate)
                .subscribe { [weak self] currencyModel in
                    guard let objects = self?.parsedModel(queryCurrency: baseCurrency, model: currencyModel) else {
                        return
                    }
                    self?.updateCurrency(objects: objects)
                    observer.onCompleted()
                } onError: { error in
                    observer.onError(error)
                }.disposed(by: self.disposeBag)

            return Disposables.create()
        }
    }

    func parsedModel(queryCurrency: String, model: CurrencyModel) -> [CurrencyObject] {
        guard let currencyDailyDict = model.data.dictionary else {
            return []
        }
        var id: Int = self.currencyMaxID()
        var objects: [CurrencyObject] = []
        currencyDailyDict.forEach { (date: String, currencyJson: JSON) in
            guard let currencyDict = currencyJson.dictionaryObject as? Dictionary<String, Double> else {
                return
            }
            currencyDict.forEach { (currency: String, exchangeRate: Double) in
                guard currency == "TWD" else { return }
                id += 1
                let timeInterval = date.toDate(format: .yyyyMMdd).timeIntervalSince1970
                let object = CurrencyObject(id: id, date: timeInterval, currency: queryCurrency, exchangeRate: exchangeRate)
                objects.append(object)
            }
        }
        return objects
    }
}
