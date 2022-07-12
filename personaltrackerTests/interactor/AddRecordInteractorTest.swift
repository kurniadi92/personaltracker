//
//  AddRecordInteractorTest.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 12/07/22.
//

import XCTest
import RxSwift

@testable import personaltracker

class AddRecordInteractorTest: XCTestCase {
    
    private var recordStorage: RecordStorage!
    private var interactor: AddRecordInteractor!
    
    override func setUpWithError() throws {
        recordStorage = RecordStorageMock()
        interactor = AddRecordInteractorImpl(recordStorage: recordStorage)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetExpenseCategory() {
        XCTAssertEqual(["FnB", "Event", "Debt", "Groceries", "Activity", "Fuel", "Education"], interactor.getExpenseCategory())
    }
    
    func testGetIncomeCategory() {
        XCTAssertEqual(["Salary", "Passive", "Bonus", "Gift"], interactor.getIncomeCategory())
    }

    func testSave_shouldStore_rawData() {
        let result = try! interactor.save(title: "mock", amount: 0, category: "category", type: "type", imageId: "id").toBlocking().first()
        
        let expected = try! recordStorage.get(uid: "uuid").toBlocking().first()
        
        XCTAssertEqual(expected, result)
    }
    
    func testGet_shouldRetrieve_record() {
        let result = try! interactor.save(title: "mock", amount: 0, category: "category", type: "type", imageId: "id").toBlocking().first()
        
        let expected = try! interactor.get(uid: "uuid").toBlocking().first()
        
        XCTAssertEqual(expected, result)
    }
}
