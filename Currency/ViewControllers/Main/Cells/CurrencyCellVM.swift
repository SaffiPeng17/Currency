//
//  CurrencyCellVM.swift
//  Currency
//
//  Created by Saffi on 2022/1/29.
//

import Foundation
import RxSwift
import RxCocoa

class CurrencyCellVM: BaseTableViewCellVM {

    let backgroundColor: BehaviorRelay<UIColor> = BehaviorRelay(value: .white)
    let flagImage: BehaviorRelay<UIImage?> = BehaviorRelay(value: nil)
    let countryTitle: BehaviorRelay<String> = BehaviorRelay(value: "")
    let exchangeRate: BehaviorRelay<String> = BehaviorRelay(value: "")

    private(set) var currencyObject: CurrencyObject?

    override init() {
        super.init()
        self.cellIdentifier = "CurrencyCell"
    }

    convenience init(with object: CurrencyObject) {
        self.init()
        currencyObject = object
        initBinding()
    }

    private func initBinding() {
        guard let object = currencyObject else {
            return
        }
        if let hex = AppConfig.Style.currencyColorHex[object.currency] {
            backgroundColor.accept(UIColor(hex: hex, alpha: 0.6))
        }
        if let iconName = AppConfig.Style.currencyFlag[object.currency] {
            flagImage.accept(UIImage(named: iconName))
        }
        countryTitle.accept(AppConfig.favoriteCurrency[object.currency] ?? "")
        exchangeRate.accept(String(object.exchangeRate))
    }
}
