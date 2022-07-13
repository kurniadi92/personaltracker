//
//  DashboardViewModelTest.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 13/07/22.
//

import XCTest
import RxSwift

@testable import personaltracker

class DashboardViewModelTest: XCTestCase {

    private var viewModel: DashboardViewModel!
    private var testHelper: RxSignalTestHelper<DashboardViewModelEvent>!
    private var interactor: DashboardInteractorMock!
    
    let periodes = [
        RecordedPeriode(start: 1, end: 10),
        RecordedPeriode(start: 11, end: 20),
        RecordedPeriode(start: 21, end: 30),
    ]
    
    override func setUpWithError() throws {
        testHelper = RxSignalTestHelper()
        interactor = DashboardInteractorMock()
        viewModel = DashboardViewModelImpl(dashboardInteractor: interactor,
                                           currentDate: { return Date(timeIntervalSince1970: TimeInterval(18)) }
        )
        
        interactor.setRecordedPeriode(periode: periodes)
        interactor.setRecord(record: createRandomRecord())
        
        testHelper.observeValue(observable: viewModel.event)
    }
    
    func testViewLoad_success_shouldPrepareViewAndChart() {
        viewModel.viewLoad()
        
        wait {
            XCTAssertEqual(self.testHelper.values, [
                .updateGreetingLabel(greeting: "Hi, mock-name"),
                .updateCalendarLabel(start: "01 Jan", end: "01 Jan"),
                .updateBarChart(viewParams: [BarChartViewParam(day: 1, amount: 317)]),
                .updatePieChart(viewParams: [PieChartViewParam(totalExpense: 175.0, category: "FnB"),
                                             PieChartViewParam(totalExpense: 100.0, category: "Sport"),
                                             PieChartViewParam(totalExpense: 42.0, category: "Activity")]),
                .updateTable,
                .highlightDate
            ])
        }
    }
    
    func testViewLoad_error_shouldShowMessage() {
        viewModel = DashboardViewModelImpl(dashboardInteractor: DashboardInteractorErrorMock(),
                                           currentDate: { return Date(timeIntervalSince1970: TimeInterval(1000)) }
        )
        
        testHelper.observeValue(observable: viewModel.event)
        
        viewModel.viewLoad()
        
        wait {
            XCTAssertEqual(self.testHelper.values, [
                .updateGreetingLabel(greeting: "Hi, mock-name"),
                .showError(message: RxError.unknown.localizedDescription)
            ])
        }
    }
    
    func testRecordCount_should_returnTotalRecordItem() {
        viewModel.viewLoad()
        
        wait {
            XCTAssertEqual(8, self.viewModel.recordCount)
        }
    }
    
    func testCalendarTap_should_openPeriodeSelector() {
        viewModel.viewLoad()
        
        wait {
            self.testHelper.reset()
        }
        
        viewModel.calendarTap()
        
        wait {
            XCTAssertEqual(self.testHelper.values,
                           [.openPeriodeSelector(periodes:
                                                    self.periodes.map { RecordedPeriodeViewParam(start: $0.start, end: $0.end) }
                                                )
                           ])
        }
    }
    
    func testGetItem_should_returnRecordCellViewParam() {
        viewModel.viewLoad()
        
        wait {
            self.testHelper.reset()
        }
        
        let expected = RecordCellViewParam(uid: "7", title: "mock-title7", category: "Sport", type: "expense", amount: 10, createdAt: 16, formattedDate: "01-Jan")
        
        XCTAssertEqual(expected, viewModel.getItem(for: 1))
    }
    
    func testChangePeriode_should_prepareViewAndChart() {
        viewModel.viewLoad()
        
        wait {
            self.testHelper.reset()
        }
        
        viewModel.changePeriode(periode: RecordedPeriodeViewParam(start: 1, end: 10))

        wait {
            XCTAssertEqual(self.testHelper.values, [
                .updateCalendarLabel(start: "01 Jan", end: "01 Jan"),
                .updateBarChart(viewParams: [BarChartViewParam(day: 1, amount: 317)]),
                .updatePieChart(viewParams: [
                    PieChartViewParam(totalExpense: 175.0, category: "FnB"),
                    PieChartViewParam(totalExpense: 100.0, category: "Sport"),
                    PieChartViewParam(totalExpense: 42.0, category: "Activity")
                ]),
                .updateTable,
                .highlightDate
            ])
        }
    }
    
    func testToggleSortByDate_should_reorderItemByDate() {
        viewModel.viewLoad()
        
        wait {
            self.testHelper.reset()
            XCTAssertEqual(40, self.viewModel.getItem(for: 0).createdAt)
        }
        
        viewModel.toggleSortByDate()
        
        wait {
            XCTAssertEqual(1, self.viewModel.getItem(for: 0).createdAt)
        }
    }
    
    func testToggleSortByCategory_should_reorderItemByCategory() {
        viewModel.viewLoad()
        
        wait {
            self.testHelper.reset()
        }
        
        viewModel.toggleSortByCategory()
        
        wait {
            XCTAssertEqual("Activity", self.viewModel.getItem(for: 0).category)
        }
        
        viewModel.toggleSortByCategory()
        
        wait {
            XCTAssertEqual("Sport", self.viewModel.getItem(for: 0).category)
        }
    }
    
    func testToggleSortByName_should_reorderItemByName() {
        viewModel.viewLoad()
        
        wait {
            self.testHelper.reset()
        }
        
        viewModel.toggleSortByName()
        
        wait {
            XCTAssertEqual("mock-title1", self.viewModel.getItem(for: 0).title)
        }
        
        viewModel.toggleSortByName()
        
        wait {
            XCTAssertEqual("mock-title8", self.viewModel.getItem(for: 0).title)
        }
    }
    
    func testToggleSortByAmount_should_reorderItemByAmount() {
        viewModel.viewLoad()
        
        wait {
            self.testHelper.reset()
        }
        
        viewModel.toggleSortByAmount()
        
        wait {
            XCTAssertEqual(10, self.viewModel.getItem(for: 0).amount)
        }
        
        viewModel.toggleSortByAmount()
        
        wait {
            XCTAssertEqual(800, self.viewModel.getItem(for: 0).amount)
        }
    }
    
    private func createRandomRecord() -> [Record] {
        let record1 = Record(uid: "1", title: "mock-title1", category: "FnB", type: "expense", amount: 100, imageId: "", createdAt: 1)
        let record2 = Record(uid: "2", title: "mock-title2", category: "Salary", type: "income", amount: 800, imageId: "", createdAt: 2)
        let record3 = Record(uid: "3", title: "mock-title3", category: "Activity", type: "expense", amount: 30, imageId: "", createdAt: 4)
        let record4 = Record(uid: "4", title: "mock-title4", category: "FnB", type: "expense", amount: 20, imageId: "", createdAt: 11)
        let record5 = Record(uid: "5", title: "mock-title5", category: "Sport", type: "expense", amount: 90, imageId: "", createdAt: 13)
        let record6 = Record(uid: "6", title: "mock-title6", category: "FnB", type: "expense", amount: 55, imageId: "", createdAt: 15)
        let record7 = Record(uid: "7", title: "mock-title7", category: "Sport", type: "expense", amount: 10, imageId: "", createdAt: 16)
        let record8 = Record(uid: "8", title: "mock-title8", category: "Activity", type: "expense", amount: 12, imageId: "", createdAt: 40)
        
        return [record1, record2, record3, record4, record5, record6, record7, record8]
    }
}
