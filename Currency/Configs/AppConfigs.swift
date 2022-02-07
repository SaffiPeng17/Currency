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

    struct API {
        static let baseURL = "https://freecurrencyapi.net/api/"
        static let version = "v2"
        static let apiKey = "fe899db0-880e-11ec-ad48-ad08b41ee731"

        struct Path {
            static let currency = "/historical"
        }
    }
}
