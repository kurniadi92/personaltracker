//
//  DashboardInteractor.swift
//  personaltracker
//
//  Created by kur niadi  on 13/07/22.
//

import Foundation
import RxSwift

struct RecordedPeriode: Equatable {
    let start: Int
    let end: Int
}

protocol DashboardInteractor {
    func getName() -> String
    func getRecordByTimeIntervalRange(periode: RecordedPeriode) -> Single<[Record]>
    func getLatestRecordByTimeIntervalRange(periode: RecordedPeriode, dayBehind: Int) -> Single<[Record]>
    func getRecordedPeriode() -> Single<[RecordedPeriode]>
}

class DashboardInteractorImpl: DashboardInteractor {
    
    private let recordStorage: RecordStorage
    private let settings: SettingStorage
    private let currentDate: () -> Date
    
    init(
        recordStorage: RecordStorage,
        settings: SettingStorage,
        currentDate: @escaping () -> Date
    ) {
        self.recordStorage = recordStorage
        self.settings = settings
        self.currentDate = currentDate
    }
    
    func getName() -> String {
        return settings.getName() ?? "Friend"
    }
    
    func getRecordByTimeIntervalRange(periode: RecordedPeriode) -> Single<[Record]> {
        return recordStorage.getByRange(start: periode.start, end: periode.end)
    }
    
    func getLatestRecordByTimeIntervalRange(periode: RecordedPeriode, dayBehind: Int) -> Single<[Record]> {
        let currentDate = currentDate()
        let previousDate = Date().adding(.day, value: -dayBehind).timeIntervalSince1970
        let validStart = Int(previousDate) > periode.start ? Int(previousDate) : periode.start
        return recordStorage.getByRange(start: periode.start, end: periode.end).map { record in
            return record.filter { $0.createdAt >= validStart && $0.createdAt <= Int(currentDate.timeIntervalSince1970) }
        }
    }
    
    func getRecordedPeriode() -> Single<[RecordedPeriode]> {
        let resetDay = settings.getResetDay() > 10 ? settings.getResetDay().description : "0\(settings.getResetDay())"
        let currentDate = Date()
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        
        var periode = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12].map { monthRaw -> RecordedPeriode in
            let month = monthRaw > 10 ? monthRaw.description :  "0\(monthRaw)"
            let year = currentDate.get(.year)
            
            let startPeriodeDate = formatter.date(from: "\(year)/\(month)/\(resetDay)")
            let endPeriodeDate  = startPeriodeDate?.adding(.month, value: 1)
            
            return RecordedPeriode(start: Int(startPeriodeDate?.timeIntervalSince1970 ?? 0), end: Int(endPeriodeDate?.timeIntervalSince1970 ?? 0))
        }
        
        let previouseYear = formatter.date(from: "\(currentDate.get(.year) - 1)/12/\(resetDay)")
        let firstMonthOfTheYear = formatter.date(from: "\(currentDate.get(.year))/01/\(resetDay)")
        
        periode.insert(RecordedPeriode(start: Int(previouseYear?.timeIntervalSince1970 ?? 0), end: Int(firstMonthOfTheYear?.timeIntervalSince1970 ?? 0)), at: 0)
    
        return Single.just(periode)
    }
}

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }
    
    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }
    
    func noon(using calendar: Calendar = .current) -> Date {
        calendar.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    
    func day(using calendar: Calendar = .current) -> Int {
        calendar.component(.day, from: self)
    }
    
    func adding(_ component: Calendar.Component, value: Int, using calendar: Calendar = .current) -> Date {
        calendar.date(byAdding: component, value: value, to: self)!
    }
    
    func monthSymbol(using calendar: Calendar = .current) -> String {
        calendar.monthSymbols[calendar.component(.month, from: self)-1]
    }
    
    static func lastDay(ofMonth m: Int, year y: Int) -> Int {
        let cal = Calendar.current
        var comps = DateComponents(calendar: cal, year: y, month: m)
        comps.setValue(m + 1, for: .month)
        comps.setValue(0, for: .day)
        let date = cal.date(from: comps)!
        return cal.component(.day, from: date)
    }
}
