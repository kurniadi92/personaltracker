//
//  SettingInteractorMock.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 11/07/22.
//

import Foundation
@testable import personaltracker

class SettingInteractorMock: SettingInteractor {
    
    private var selectedCurrency = "default"
    private var selectedDay = 999
    
    var getAllCurrency: [String] {
        return ["A", "B", "C"]
    }
    
    func getSelectedCurrency() -> String {
        return selectedCurrency
    }
    
    func getSelectedResetDay() -> Int {
        return selectedDay
    }
    
    func setCurrency(currency: String) {
        selectedCurrency = currency
    }
    
    func setResetDay(day: Int) {
        selectedDay = day
    }
}
