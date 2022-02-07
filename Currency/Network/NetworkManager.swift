//
//  NetworkManager.swift
//  Currency
//
//  Created by Saffi on 2022/1/27.
//

import Foundation
import Alamofire
import RxSwift
import RealmSwift
import SwiftyJSON

enum ApiError: Error {
    case requestFailure, parseFailure
}

class NetworkManager {

    class func fetch<T: Codable>(_ urlRequest: ApiService) -> Observable<T> {
        return Observable<T>.create { observer in
            
            AF.request(urlRequest)
                .response { (response: AFDataResponse<Data?>) in
                    switch response.result {
                    case .success(let data):
                        guard let data = data else {
                            observer.onError(ApiError.requestFailure)
                            return
                        }
                        do {
                            let object = try JSONDecoder().decode(T.self, from: data)
                            observer.onNext(object)
                        } catch {
                            observer.onError(ApiError.parseFailure)
                        }

                    case .failure(let error):
                        observer.onError(ApiError.requestFailure)
                    }
                }
            return Disposables.create()
        }
    }
}

extension NetworkManager {
    class func fetchCurrency(baseCurrency: String, fromDate: String, toDate: String) -> Observable<CurrencyModel> {
        return NetworkManager.fetch(.getCurrency(baseCurrency: baseCurrency, fromDate: fromDate, toDate: toDate))
    }
}
