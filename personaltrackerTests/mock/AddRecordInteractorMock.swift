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
    
    func get(uid: String) -> Single<Record> {
        record = Record(uid: uid, title: "mock", category: "mock", type: "mock", amount: 0, imageId: "mock", createdAt: 0)
        
        return .just(record)
    }

    func save(title: String, amount: Int, category: String, type: String, imageId: String) -> Single<Record> {
        record = Record(uid: "uid", title: title, category: category, type: type, amount: amount, imageId: imageId, createdAt: 0)
        
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
    override func save(title: String, amount: Int, category: String, type: String, imageId: String) -> Single<Record> {
        return .error(RxError.unknown)
    }
}
