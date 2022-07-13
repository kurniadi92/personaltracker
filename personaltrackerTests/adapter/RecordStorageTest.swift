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
            imageId: "location"
        )
         
        let record = try! storage.save(data: recordRaw).toBlocking().first()
                
        let expectedRecord = try! storage.get(uid: recordRaw.uid).toBlocking().first()
        
        XCTAssertEqual(record, expectedRecord!)
    }
    
    func testCreateAndDeleteRecord() {
        let storage = RecordStorageImpl(realm: self.realm)
        let recordRaw = RecordRaw(
            uid: "uuid",
            title: "mock",
            category: "category",
            type: "type",
            amount: 100,
            imageId: "location"
        )
         
        let record = try! storage.save(data: recordRaw).toBlocking().first()
        let delete = try! storage.delete(uid: "uuid").toBlocking().first()
                
        let count = realm().objects(Record.self).filter { $0.uid == "uuid" }.count
        XCTAssertEqual(0, count)
    }
    
    func testCreateAndGetAllRecord() {
        let storage = RecordStorageImpl(realm: self.realm)
        let recordRaw = RecordRaw(
            uid: "uuid",
            title: "mock",
            category: "category",
            type: "type",
            amount: 100,
            imageId: "id"
        )
        let record = try! storage.save(data: recordRaw).toBlocking().first()

        let expectedRecord = try! storage.getAll().toBlocking().first()

        XCTAssertEqual([record!], expectedRecord)
    }
    
    func testCreateAndGetAllByRange() {
        let storage = RecordStorageImpl(realm: self.realm)
        let recordRaw = RecordRaw(
            uid: "uuid",
            title: "mock",
            category: "category",
            type: "type",
            amount: 100,
            imageId: "id"
        )
        
        let recordRaw2 = RecordRaw(
            uid: "uuid-2",
            title: "mock-2",
            category: "category-2",
            type: "type-2",
            amount: 100,
            imageId: "id-2"
        )
        
        let record1 = try! storage.save(data: recordRaw).toBlocking().first()
        Thread.sleep(forTimeInterval: 1)
        let record2 = try! storage.save(data: recordRaw2).toBlocking().first()
        Thread.sleep(forTimeInterval: 1)
        
        let expectedRecord = try! storage
            .getByRange(start: Int(Date().timeIntervalSince1970 - (10 * 100)),
                        end: Int(Date().timeIntervalSince1970)).toBlocking().first()

        XCTAssertEqual([record1!, record2!], expectedRecord)
    }
}
