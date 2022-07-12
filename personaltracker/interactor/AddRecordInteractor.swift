//
//  AddRecordInteractor.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import Foundation
import RxSwift

protocol AddRecordInteractor {
    func get(uid: String) -> Single<Record>
    func save(title: String, amount: Int, category: String, type: String, imageLocation: String) -> Single<Record>
    func getExpenseCategory() -> [String]
    func getIncomeCategory() -> [String]
}

class AddRecordInteractorImpl: AddRecordInteractor {
    private let recordStorage: RecordStorage
    
    init(recordStorage: RecordStorage) {
        self.recordStorage = recordStorage
    }
    
    func get(uid: String) -> Single<Record> {
        return recordStorage.get(uid: uid)
    }
    
    func save(title: String, amount: Int, category: String, type: String, imageLocation: String) -> Single<Record> {
        let raw = RecordRaw(uid: UUID().uuidString, title: title, category: category, type: type, amount: amount, imageLocation: imageLocation)
        
        return recordStorage.save(data: raw)
    }
    
    func getExpenseCategory() -> [String] {
        return ["FnB", "Event", "Debt", "Groceries", "Activity", "Fuel", "Education"]
    }
    
    func getIncomeCategory() -> [String] {
        return ["Salary", "Passive", "Bonus", "Gift"]
    }
}
