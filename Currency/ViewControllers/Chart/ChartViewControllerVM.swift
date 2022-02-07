//
//  ChartViewControllerVM.swift
//  Currency
//
//  Created by Saffi on 2022/2/7.
//

import Foundation

class ChartViewControllerVM: BaseViewModel {

    var dataRange: String = ""
    var title: String = ""

    var chartTuple: (titles: [String], values: [Double]) = ([], [])
    var chartTitle: String = ""

    private var currentCurrency: String = ""
    private var currentDate: Date = Date()
    private var currencyObjects: [CurrencyObject] = []

    init(currency: String, date: TimeInterval) {
        super.init()
        currentCurrency = currency
        currentDate = Date(timeIntervalSince1970: date)
        setupCurrencyData()
    }

    private func setupCurrencyData() {
        guard let objects = DataAccessManager.shared.getWeekCurrency(name: currentCurrency, date: currentDate), objects.count > 0 else {
            return
        }
        currencyObjects = objects

        title = String(format: "%@匯率紀錄", AppConfig.favoriteCurrency[currentCurrency] ?? "")

        var dRange: (from: String, to: String) = ("", "")
        var titles: [String] = []
        var values: [Double] = []

        currencyObjects.enumerated().forEach { (index, object) in
            let title = Date(timeIntervalSince1970: object.date)
            titles.append(title.toString(format: .Md))
            if index == 0 {
                dRange.from = title.toString(format: .yyyyMMdd)
            } else if index == (currencyObjects.count - 1) {
                dRange.to = title.toString(format: .yyyyMMdd)
            }
            let value = Double(object.exchangeRate)
            values.append(value)
        }
        dataRange = dRange.from + " ~ " + dRange.to
        chartTuple = (titles, values)
        chartTitle = String(format: "%@匯率７日紀錄", AppConfig.favoriteCurrency[currentCurrency] ?? "")
    }
}
