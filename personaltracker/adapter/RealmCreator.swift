//
//  RealmCreator.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import Foundation
import RealmSwift

class RealmCreator {
    static func create(inMemoryIdentifier: String? = nil) -> () -> Realm? {
        if let inMemoryIdentifier =  inMemoryIdentifier {
            return { createInMemoryRealm(inMemoryIdentifier: inMemoryIdentifier) }
        } else { return createRealm }
    }
    
    private static func createRealm() -> Realm? {
        do {
            return try Realm()
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }

    private static func createInMemoryRealm(inMemoryIdentifier: String) -> Realm? {
        let configuration = Realm.Configuration(inMemoryIdentifier: inMemoryIdentifier)
        return try? Realm(configuration: configuration)
    }
}
