//
//  AppConfigs.swift
//  Currency
//
//  Created by Saffi on 2022/1/27.
//

import Foundation

struct AppConfig {

    static let highlightDays = ["今天", "昨天"]
    static let favoriteCurrency = ["JPY": "日圓", "USD": "美元", "EUR": "歐元"]

    struct Style {
        static let currencyColorHex: [String: Int] = ["JPY": 0xEE846C, "USD": 0x5EC2A4, "EUR": 0xF2AC51]
        static let currencyFlag = ["JPY": "flag_japan", "USD": "flag_usa", "EUR": "flag_eu"]
    }

    struct API {
        static let baseURL = "https://freecurrencyapi.net/api/"
        static let version = "v2"
        static let apiKey = "fe899db0-880e-11ec-ad48-ad08b41ee731"

        struct Path {
            static let currency = "/historical"
        }
    }
}
