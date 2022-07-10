//
//  SettingStorageTest.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 10/07/22.
//

import XCTest

@testable import personaltracker

class SettingStorageTest: XCTestCase {

    private let storage = UserDefaults(suiteName: "test")
    
    func testSaveAndGetName() {
        let sut = SettingStorageImpl(storage: storage!)
        sut.saveName(name: "random-123")
        
        XCTAssertEqual("random-123", sut.getName()!)
    }

    func testSaveAndGetCurrency() {
        let sut = SettingStorageImpl(storage: storage!)
        sut.saveCurrency(currency: "$")
        
        XCTAssertEqual("$", sut.getCurrency())
    }
    
    func testSaveAndGetResetDay() {
        let sut = SettingStorageImpl(storage: storage!)
        sut.saveResetDay(day: 2)
        
        XCTAssertEqual(2, sut.getResetDay())
    }
}
