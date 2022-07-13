//
//  AddRecordInteractorMock.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 12/07/22.
//

import Foundation
import RxSwift

@testable import personaltracker

class AddRecordInteractorMock: AddRecordInteractor {
    
    var record: Record!
    var deletedUid: String = ""
    
    func delete(uid: String) -> Single<Void> {
        deletedUid =  uid
        return .just(())
    }
    
    func get(uid: String) -> Single<Record?> {
        record = Record(uid: uid, title: "mock", category: "FnB", type: "expense", amount: 0, imageId: "mock", createdAt: 0)
        
        return .just(record)
    }

    func save(uuid: String?, title: String, amount: Int, category: String, type: String, imageId: String) -> Single<Record> {
        record = Record(uid: uuid ?? "uid", title: title, category: category, type: type, amount: amount, imageId: imageId, createdAt: 0)
        
        return .just(record)
    }

    func getExpenseCategory() -> [String] {
        return ["one", "two"]
    }

    func getIncomeCategory() -> [String] {
        return ["three", "four", "five"]
    }
}

class AddRecordInteractorErrorMock: AddRecordInteractorMock {
    override func save(uuid: String?,  title: String, amount: Int, category: String, type: String, imageId: String) -> Single<Record> {
        return .error(RxError.unknown)
    }
}
