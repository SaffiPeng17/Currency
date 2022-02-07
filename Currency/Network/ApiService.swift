//
//  NetworkManager.swift
//  Currency
//
//  Created by Saffi on 2022/1/27.
//

import Foundation
import Alamofire

enum ApiService: URLRequestConvertible {
    case getCurrency(baseCurrency: String, fromDate: String, toDate: String)

    // MARK: - Path
    private var path: String {
        switch self {
        case .getCurrency:
            return AppConfig.API.Path.currency
        }
    }

    // MARK: - ContentType
    var contentType: String {
        switch self {
        case .getCurrency:
            return "application/json"
        }
    }

    // MARK: - HttpMethod
    private var method: HTTPMethod {
        switch self {
        case .getCurrency:
            return .get
        }
    }

    // MARK: - Parameters
    var parameters: Parameters? {
        switch self {
        case .getCurrency(let baseCurrency, let fromDate, let toDate):
            let parameters = ["apikey": AppConfig.API.apiKey, "base_currency": baseCurrency, "date_from": fromDate, "date_to": toDate]
            return parameters
        }
    }

    // MARK: - URLRequestConvertible
    func asURLRequest() throws -> URLRequest {
        let url = try (AppConfig.API.baseURL + AppConfig.API.version + path).asURL()

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        return try URLEncoding.default.encode(urlRequest, with: parameters)
    }
}
