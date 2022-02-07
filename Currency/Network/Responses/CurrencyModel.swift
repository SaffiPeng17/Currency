//
//  CurrencyModel.swift
//  Currency
//
//  Created by Saffi on 2022/1/27.
//

import Foundation
import SwiftyJSON

struct CurrencyModel: Codable {
    var query: QueryModel
    var data: JSON

    enum CodingKeys: String, CodingKey {
        case query, data
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        query = try values.decode(QueryModel.self, forKey: .query)
        data = try values.decode(JSON.self, forKey: .data)
    }

    func encode(to encoder: Encoder) throws {}
}

struct QueryModel: Codable {
    var apikey: String?
    var baseCurrency: String
    var dateFrom: String?
    var dateTo: String?
    var timestamp: Int

    enum CodingKeys: String, CodingKey {
        case apikey, baseCurrency = "base_currency", dateFrom = "date_from", dateTo = "date_to", timestamp
    }

    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)

        apikey = try values.decodeIfPresent(String.self, forKey: .apikey)
        baseCurrency = try values.decode(String.self, forKey: .baseCurrency)
        dateFrom = try values.decodeIfPresent(String.self, forKey: .dateFrom)
        dateTo = try values.decodeIfPresent(String.self, forKey: .dateTo)
        timestamp = try values.decode(Int.self, forKey: .timestamp)
    }
}
