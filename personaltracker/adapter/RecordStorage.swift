//
//  RecordStorage.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import Foundation
import RxSwift
import RealmSwift

protocol RecordStorage {
    func getAll() -> Single<[Record]>
    func get(uid: String) -> Single<Record>
    func save(data: RecordRaw) -> Single<Record>
    func getByRange(start: Int, end: Int) -> Single<[Record]>
}

class RecordStorageImpl: RecordStorage {
    private let realm: () -> Realm?
    
    init(realm: @escaping () -> Realm?) {
        self.realm = realm
    }
    
    func getAll() -> Single<[Record]> {
        return Single<[Record]>.deferred { [weak self] in
            guard let `self` = self, let realm = self.realm() else {
                return .error(NSError(domain: "Failed to initialize realm", code: 0))
            }
            let records = realm.objects(Record.self)
            
            return .just(Array(records))
        }
    }
    
    func get(uid: String) -> Single<Record> {
        return Single<Record>.deferred { [weak self] in
            guard let `self` = self, let realm = self.realm() else {
                return .error(NSError(domain: "Failed to initialize realm", code: 0))
            }
            
            let record = realm.objects(Record.self).first { $0.uid == uid }
            
            if let record = record {
                return .just(record)
            } else {
                return .error(NSError(domain: "No record found", code: 1))
            }
        }
    }
    
    func getByRange(start: Int, end: Int) -> Single<[Record]> {
        return Single<[Record]>.deferred { [weak self] in
            guard let `self` = self, let realm = self.realm() else {
                return .error(NSError(domain: "Failed to initialize realm", code: 0))
            }
            let records = realm.objects(Record.self).filter("createdAt >= \(start) AND createdAt <= \(end)")
            
            return .just(Array(records))
        }
    }
    
    func save(data: RecordRaw) -> Single<Record> {
        return Single<Record>.deferred { [weak self] in
            guard let `self` = self, let realm = self.realm() else {
                return .error(NSError(domain: "Failed to initialize realm", code: 0))
            }
            
            do {
                let contact = try realm.write { () -> Record in
                    let object = Record(uid: data.uid,
                                        title: data.title,
                                        category: data.category,
                                        type: data.type,
                                        amount: data.amount,
                                        imageId: data.imageId,
                                        createdAt: Int(Date().timeIntervalSince1970))
                    realm.add(object, update: .all)
                    
                    return object
                }
                
                return .just(contact)
            } catch {
                return .error(error)
            }
        }
    }
}
