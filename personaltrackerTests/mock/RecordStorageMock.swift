//
//  RecordStorageMock.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 12/07/22.
//

import Foundation
import RxSwift

@testable import personaltracker

class RecordStorageMock: RecordStorage {
    
    private var record: Record!
    
    func getAll() -> Single<[Record]> {
        return Single.just([])
    }
    
    func get(uid: String) -> Single<Record> {
        return Single.just(record)
    }
    
    func save(data: RecordRaw) -> Single<Record> {
        record = Record(uid: "uuid", title: data.title, category: data.category, type: data.type, amount: data.amount, imageId: data.imageId, createdAt: 0)
        
        return Single.just(record)
    }
}
