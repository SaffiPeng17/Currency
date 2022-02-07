//
//  CurrencyObject.swift
//  Currency
//
//  Created by Saffi on 2022/1/27.
//

import Foundation
import RealmSwift

class CurrencyObject: Object {
    @Persisted(primaryKey: true) var _id: Int = 0
    @Persisted var date: Double
    @Persisted var currency: String = ""
    @Persisted var exchangeRate: Double = 0.0

    convenience init(id: Int, date: Double, currency: String, exchangeRate: Double) {
        self.init()
        self._id = id
        self.date = date
        self.currency = currency
        self.exchangeRate = exchangeRate
    }
}
