//
//  SettingInteractorTest.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 11/07/22.
//

import XCTest
import RxSwift

@testable import personaltracker

class SettingInteractorTest: XCTestCase {
    
    private var storageMock: SettingStorageMock!
    
    override func setUpWithError() throws {
        storageMock = SettingStorageMock()
    }
    
    func testIfGetCurrencyNil_shouldReturnSGD() {
        let interactor =  SettingInteractorImpl(storage: storageMock)
        XCTAssertEqual("SGD", interactor.getSelectedCurrency())
    }
    
    func testIfGetCurrencyNotNil_shouldReturnCurrecy() {
        storageMock.saveCurrency(currency: "USD")
        let interactor =  SettingInteractorImpl(storage: storageMock)
        XCTAssertEqual("USD", interactor.getSelectedCurrency())
    }
    
    func testIfGetResetDay0_shouldReturn1() {
        let interactor =  SettingInteractorImpl(storage: storageMock)
        XCTAssertEqual(1, interactor.getSelectedResetDay())
    }
    
    func testIfGetResetDayNotNil_shouldReturnResetDay() {
        storageMock.saveResetDay(day: 2)
        let interactor =  SettingInteractorImpl(storage: storageMock)
        XCTAssertEqual(2, interactor.getSelectedResetDay())
    }
}
