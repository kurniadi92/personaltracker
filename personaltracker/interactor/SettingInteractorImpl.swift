//
//  SettingInteractorImpl.swift
//  personaltracker
//
//  Created by kur niadi  on 11/07/22.
//

import Foundation

protocol SettingInteractor {
    var getAllCurrency: [String] { get }
    func getSelectedCurrency() -> String
    func getSelectedResetDay() -> Int
    
    func setCurrency(currency: String)
    func setResetDay(day: Int)
}

class SettingInteractorImpl: SettingInteractor {
    
    private let storage: SettingStorage

    init(storage: SettingStorage) {
        self.storage = storage
    }
    
    var getAllCurrency: [String]  {
        return ["IDR", "USD", "SGD"]
    }
    
    func getSelectedCurrency() -> String {
        return storage.getCurrency() ?? "SGD"
    }
    
    func getSelectedResetDay() -> Int {
        let validDay =  (storage.getResetDay() > 0) ? storage.getResetDay() : 1
        return validDay
    }
    
    func setCurrency(currency: String) {
        storage.saveCurrency(currency: currency)
    }
    
    func setResetDay(day: Int) {
        storage.saveResetDay(day: day)
    }
}
