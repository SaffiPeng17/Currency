//
//  RealmDAO.swift
//  Currency
//
//  Created by Saffi on 2022/1/27.
//

import Foundation
import RealmSwift

class RealmDAO {

    private let queueLabel: String = "realm.write.queue"

    init() {
        // get realm file path
        print("realm path:", Realm.Configuration.defaultConfiguration.fileURL?.absoluteString as Any)
    }
}

// MARK: - Interfaces
extension RealmDAO {
    func update<S: Sequence>(_ objects: S, policy: Realm.UpdatePolicy = .all) where S.Iterator.Element: Object {
        DispatchQueue(label: queueLabel).sync {
            let realm = try! Realm()
            try? realm.write {
                realm.add(objects, update: policy)
            }
        }
    }

    func read<O: Object>(type: O.Type, predicate: String? = nil) -> Results<O>? {
        DispatchQueue(label: queueLabel).sync {
            let realm = try! Realm()
            let result = realm.objects(O.self)
            guard let predicate = predicate else {
                return result
            }
            return result.filter(predicate)
        }
    }
}
