//
//  RecordStorageTest.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 12/07/22.
//

import XCTest
import RxBlocking
import RealmSwift

@testable import personaltracker

class RecordStorageTest: XCTestCase {

    private var realm: () -> Realm = {
        let configuration = Realm.Configuration(inMemoryIdentifier: "test realm")
        
        return try! Realm(configuration: configuration)
    }
    
    func testCreateAndGetRecord() {
        let storage = RecordStorageImpl(realm: self.realm)
        let recordRaw = RecordRaw(
            uid: "uuid",
            title: "mock",
            category: "category",
            type: "type",
            amount: 100,
            imageLocation: "location"
        )
         
        let record = try! storage.save(data: recordRaw).toBlocking().first()
                
        let expectedRecord = try! storage.get(uid: recordRaw.uid).toBlocking().first()
        
        XCTAssertEqual(record, expectedRecord!)
    }
    
    func testCreateAndGetAllRecord() {
        let storage = RecordStorageImpl(realm: self.realm)
        let recordRaw = RecordRaw(
            uid: "uuid",
            title: "mock",
            category: "category",
            type: "type",
            amount: 100,
            imageLocation: "location"
        )
        let record = try! storage.save(data: recordRaw).toBlocking().first()

        let expectedRecord = try! storage.getAll().toBlocking().first()

        XCTAssertEqual([record!], expectedRecord)
    }
}
