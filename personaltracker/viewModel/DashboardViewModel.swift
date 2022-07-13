//
//  DashboardViewModel.swift
//  personaltracker
//
//  Created by kur niadi  on 13/07/22.
//

import Foundation
import RxCocoa
import RxSwift

enum SortType {
    case asc
    case desc
}

enum DashboardViewModelEvent: Equatable {
    case updateBarChart(viewParams: [BarChartViewParam])
    case updatePieChart(viewParams: [PieChartViewParam])
    case updateGreetingLabel(greeting: String)
    case updateCalendarLabel(start: String, end: String)
    case showError(message: String)
    case updateTable
    case openPeriodeSelector(periodes: [RecordedPeriodeViewParam])
    case highlightDate
    case highlightName
    case highlightCategory
    case highlightAmount
}

protocol DashboardViewModel {
    var event: Signal<DashboardViewModelEvent> { get }
    var recordCount: Int { get }
    func viewLoad()
    func calendarTap()
    func getItem(for index:Int) -> RecordCellViewParam
    func changePeriode(periode: RecordedPeriodeViewParam)
    func toggleSortByDate()
    func toggleSortByCategory()
    func toggleSortByName()
    func toggleSortByAmount()
}

class DashboardViewModelImpl: DashboardViewModel {
    
    private let _event = PublishSubject<DashboardViewModelEvent>()
    
    var event: Signal<DashboardViewModelEvent> {
        return _event.asSignal(onErrorSignalWith: .empty())
    }
    
    var recordCount: Int {
        return records.count
    }
    
    private let dashboardInteractor: DashboardInteractor
    private let currentDate: () -> Date
    private let disposeBag = DisposeBag()
    
    private var records = [RecordCellViewParam]()
    private var categorySort: SortType? = SortType.desc
    private var nameSort: SortType?
    private var dateSort: SortType?
    private var amountSort: SortType?
    
    private var recordedPeriode = [RecordedPeriode]()
    private var currentPeriode: RecordedPeriode?
        
    init(
        dashboardInteractor: DashboardInteractor,
        currentDate: @escaping () -> Date
    ) {
        self.dashboardInteractor = dashboardInteractor
        self.currentDate = currentDate
    }
    
    func getItem(for index: Int) -> RecordCellViewParam {
        return records[index]
    }
    
    func viewLoad() {
        _event.onNext(.updateGreetingLabel(greeting: "Hi, \(dashboardInteractor.getName())"))
        
        let currentDate = self.currentDate()
        let currentPeriode = dashboardInteractor.getRecordedPeriode()
            .map { [weak self] periodes -> RecordedPeriode? in
                self?.recordedPeriode = periodes
                let currentTimeInterval = currentDate.timeIntervalSince1970
                self?.currentPeriode = periodes.first { Int(currentTimeInterval) >= $0.start &&  Int(currentTimeInterval) <= $0.end }
                return self?.currentPeriode
            }
        
        loadFromPeriode(periodeSignal: currentPeriode)
    }
    
    func calendarTap() {
        _event.onNext(
            .openPeriodeSelector(periodes: recordedPeriode.map { RecordedPeriodeViewParam(start: $0.start, end: $0.end) })
        )
    }
    
    func changePeriode(periode: RecordedPeriodeViewParam) {
        loadFromPeriode(periodeSignal: Single.just(RecordedPeriode(start: periode.start, end: periode.end)))
    }
    
    func toggleSortByDate() {
        if dateSort == nil || dateSort == .desc {
            dateSort = .asc
            records = records.sorted { $0.createdAt < $1.createdAt }
        } else {
            dateSort = .desc
            records = records.sorted { $0.createdAt > $1.createdAt }
        }
        
        nameSort = nil
        categorySort = nil
        amountSort = nil
        
        self._event.onNext(.highlightDate)
        self._event.onNext(.updateTable)
    }
    
    func toggleSortByCategory() {
        if categorySort == nil || categorySort == .desc {
            categorySort = .asc
            records = records.sorted { $0.category < $1.category }
        } else {
            categorySort = .desc
            records = records.sorted { $0.category > $1.category }
        }
        
        nameSort = nil
        dateSort = nil
        amountSort = nil
        
        self._event.onNext(.highlightCategory)
        self._event.onNext(.updateTable)
    }
    
    func toggleSortByName() {
        if nameSort == nil || nameSort == .desc {
            nameSort = .asc
            records = records.sorted { $0.title < $1.title }
        } else {
            nameSort = .desc
            records = records.sorted { $0.title > $1.title }
        }
        
        categorySort = nil
        dateSort = nil
        amountSort = nil
        
        self._event.onNext(.highlightName)
        self._event.onNext(.updateTable)
    }
    
    func toggleSortByAmount() {
        if amountSort == nil || amountSort == .desc {
            amountSort = .asc
            records = records.sorted { $0.amount < $1.amount }
        } else {
            amountSort = .desc
            records = records.sorted { $0.amount > $1.amount }
        }
        
        nameSort = nil
        dateSort = nil
        categorySort = nil
        
        self._event.onNext(.highlightAmount)
        self._event.onNext(.updateTable)
    }
    
    private func loadFromPeriode(periodeSignal: Single<RecordedPeriode?>) {
        periodeSignal
            .map { [weak self] periode -> RecordedPeriode? in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd MMM"
                
                let startText = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(periode?.start ?? 0)))
                let endText = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(periode?.end ?? 0)))

                self?._event.onNext(.updateCalendarLabel(start: startText, end: endText))
                
                return periode
            }
            .flatMap { [weak self] periode -> Single<([Record], [Record])> in
            guard let `self` = self, let periode = periode else { return Single.error(RxError.unknown) }
            return Single.zip(self.dashboardInteractor.getRecordByTimeIntervalRange(periode: periode), self.dashboardInteractor.getLatestRecordByTimeIntervalRange(periode: periode, dayBehind: 14))
        }
        .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
        .subscribe { [weak self] (periodeRecord, last14Record) in
            guard let `self` = self else { return }
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MMM"
            
            self.records = periodeRecord.map { record in
                return RecordCellViewParam(uid: record.uid,
                                           title: record.title,
                                           category: record.category,
                                           type: record.type,
                                           amount: record.amount,
                                           createdAt: record.createdAt,
                                           formattedDate: dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(record.createdAt))))
            }.sorted { $0.createdAt > $1.createdAt }
            
            let grouping = Dictionary(grouping: periodeRecord.filter { $0.type == RecordType.expense.rawValue }, by: { $0.category })
                .map { key, value in
                    return PieChartViewParam(totalExpense: value.map { Float($0.amount) }.reduce(0, +), category: key)
            }
            
            let barChartParams = self.createBarChartViewParam(record: last14Record)
            
            self.resetSort()
            self._event.onNext(.updateBarChart(viewParams: barChartParams))
            self._event.onNext(.updatePieChart(viewParams: grouping.sorted { $0.totalExpense > $1.totalExpense }))
            self._event.onNext(.updateTable)
            self._event.onNext(.highlightDate)
            
        } onFailure: { error in
            self._event.onNext(.showError(message: error.localizedDescription))
        }.disposed(by: disposeBag)
    }
    
    private func createBarChartViewParam(record: [Record]) -> [BarChartViewParam] {
        let barChatRawData = Dictionary(grouping: record.filter { $0.type == RecordType.expense.rawValue }, by: { Date(timeIntervalSince1970: TimeInterval($0.createdAt)).get(.day) })
            .map { key, value -> BarChartViewParam in
                return BarChartViewParam(day: key, amount: value.map { $0.amount }.reduce(0, +))
        }
        
        var param = [BarChartViewParam]()
        let currentDay = currentDate().get(.day)
        let past14Day = 14
        let start = currentDay - past14Day > 0 ? currentDay - past14Day : 1
        
        for day in start...currentDay {
            if let data = barChatRawData.first(where: { $0.day == day }) {
                param.append(data)
            } else {
                param.append(BarChartViewParam(day: day, amount: 0))
            }
        }
        
        return param
    }
    
    private func resetSort() {
        dateSort = .desc
        nameSort = nil
        dateSort = nil
        categorySort = nil
    }
}
