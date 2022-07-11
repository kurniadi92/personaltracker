//
//  SettingStorageMock.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 11/07/22.
//

import Foundation

@testable import personaltracker

class SettingStorageMock: SettingStorage {
    private var name: String?
    private var currency: String?
    private var day: Int = 0

    func saveCurrency(currency: String) {
        self.currency = currency
    }
    
    func saveResetDay(day: Int) {
        self.day = day
    }
    
    func getCurrency() -> String? {
        return currency
    }
    
    func getResetDay() -> Int {
        return day
    }
        
    func saveName(name: String) {
        self.name = name
    }
    
    func getName() -> String? {
        return name
    }
}
