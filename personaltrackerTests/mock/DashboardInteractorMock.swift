//
//  DashboardInteractorMock.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 13/07/22.
//

import Foundation
import RxSwift
import RxCocoa

@testable import personaltracker

class DashboardInteractorMock: DashboardInteractor {
    
    private var recordedPeriode = [RecordedPeriode]()
    private var record = [Record]()
    
    func setRecordedPeriode(periode: [RecordedPeriode]) {
        self.recordedPeriode = periode
    }
    
    func setRecord(record: [Record]) {
        self.record = record
    }
    
    func getName() -> String {
        return "mock-name"
    }
    
    func getRecordByTimeIntervalRange(periode: RecordedPeriode) -> Single<[Record]> {
        return Single.just(self.record)
    }
    
    func getLatestRecordByTimeIntervalRange(periode: RecordedPeriode, dayBehind: Int) -> Single<[Record]> {
        return Single.just(self.record)
    }
    
    func getRecordedPeriode() -> Single<[RecordedPeriode]> {
        return Single.just(self.recordedPeriode)
    }
}

class DashboardInteractorErrorMock: DashboardInteractorMock {
    override func getRecordedPeriode() -> Single<[RecordedPeriode]> {
        return Single.error(RxError.unknown)
    }
}
