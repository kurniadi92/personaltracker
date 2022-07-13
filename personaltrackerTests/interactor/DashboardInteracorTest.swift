//
//  DashboardInteracorTest.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 13/07/22.
//

import XCTest

@testable import personaltracker

class DashboardInteracorTest: XCTestCase {
    private var recordStorage: RecordStorageMock!
    private var settings: SettingStorage!
    
    private var interactor: DashboardInteractor!
    
    override func setUpWithError() throws {
        recordStorage = RecordStorageMock()
        settings = SettingStorageMock()
        
        settings.saveResetDay(day: 28)
        
        let date: Double = 1657703707 //13 July 2022 09:15:07
        
        interactor = DashboardInteractorImpl(recordStorage: recordStorage, settings: settings, currentDate: {
            return Date(timeIntervalSince1970: date)
        })
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    func testGetName_shouldReturn_name() {
        settings.saveName(name: "random")
        XCTAssertEqual("random", interactor.getName())
    }
    
    func testGetRecordByTimeIntervalRange_shouldReturn_recordedData() {
        let record1 = Record()
        record1.createdAt = 150
        
        let record2 = Record()
        record2.createdAt = 400
        
        recordStorage.setRecord(records: [record1, record2])
        let result = try! interactor.getRecordByTimeIntervalRange(periode: RecordedPeriode(start: 123, end: 456)).toBlocking().first()
        
        XCTAssertEqual([150, 400], result!.map { $0.createdAt })
    }
    
    func testGetRecordByTimeIntervalRangeWithMaxLimit_shouldReturn_recordedDataAsThatLimit() {
        let record1 = Record()
        record1.uid = "record1"
        record1.createdAt = 1657358107 //Saturday, 9 July 2022 09:15:07
        
        let record2 = Record()
        record2.uid = "record2"
        record2.createdAt = 1657530907 //Monday, 11 July 2022 09:15:07
        
        let record3 = Record()
        record3.uid = "record3"
        record3.createdAt = 1657617307 // Tuesday, 12 July 2022 09:15:07
        
        let start = 1655122507 // Monday, 13 June 2022 12:15:07
        let end = 1657800907 // Thursday, 14 July 2022 12:15:07
        
        recordStorage.setRecord(records: [record1, record2, record3])
        
        let result = try! interactor.getLatestRecordByTimeIntervalRange(periode: RecordedPeriode(start: start, end: end), dayBehind: 3).toBlocking().first()
        
        XCTAssertEqual([record2, record3], result!)
    }
    
    func testGetRecordedPeriode() {
        let recordedPeriode = try! interactor.getRecordedPeriode().toBlocking().first()
        XCTAssertEqual(recordedPeriode!.first, RecordedPeriode(start: 1640624400, end: 1643302800))
        XCTAssertEqual(recordedPeriode!.last, RecordedPeriode(start: 1672160400, end: 1674838800))
    }
}
