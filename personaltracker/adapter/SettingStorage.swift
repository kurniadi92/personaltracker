//
//  SettingStorage.swift
//  personaltracker
//
//  Created by kur niadi  on 10/07/22.
//

import Foundation

protocol SettingStorage {
    func saveName(name: String)
    func saveCurrency(currency: String)
    func saveResetDay(day: Int)
    
    func getName() -> String?
    func getCurrency() -> String?
    func getResetDay() -> Int?
}

class SettingStorageImpl: SettingStorage {
    
    private let NAME_CONST = "name"
    private let CURRENCY_CONST = "currency"
    private let RESET_CONST = "reset"
    
    private let storage: UserDefaults
    
    init(storage: UserDefaults) {
        self.storage = storage
    }
    
    func saveName(name: String) {
        storage.set(name, forKey: NAME_CONST)
    }
    
    func saveCurrency(currency: String) {
        storage.set(currency, forKey: CURRENCY_CONST)
    }
    
    func saveResetDay(day: Int) {
        storage.set(day, forKey: RESET_CONST)
    }
    
    func getName() -> String? {
        return storage.string(forKey: NAME_CONST)
    }
    
    func getCurrency() -> String? {
        return storage.string(forKey: CURRENCY_CONST)
    }
    
    func getResetDay() -> Int? {
        return storage.integer(forKey: RESET_CONST)
    }
}
