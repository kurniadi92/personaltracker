//
//  SettingPageViewModelTest.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 11/07/22.
//

import XCTest

@testable import personaltracker

class SettingPageViewModelTest: XCTestCase {

    private var viewModel: SettingPageViewModel!
    private var testHelper: RxSignalTestHelper<SettingPageViewModelEvent>!
    private var settingInteractor: SettingInteractor!
    
    override func setUpWithError() throws {
        testHelper = RxSignalTestHelper()
        settingInteractor = SettingInteractorMock()
        viewModel = SettingPageViewModelImpl(setting: settingInteractor)
        
        testHelper.observeValue(observable: viewModel.event)
    }
    
    func testViewLoad_shouldUpdateCurrencyAndResetDay() {
        viewModel.viewLoad()
        
        wait {
            XCTAssertEqual(self.testHelper.values,
                           [
                            .updateCurrency(currency: "default"),
                            .updateResetDay(resetDay: "Every 999")
                           ]
            )
        }
    }
    
    func testOnCurrencyTapped_shouldTriggerEventShowCurrency() {
        viewModel.onCurrenncyTapped()
        
        wait {
            XCTAssertEqual(self.testHelper.values, [.showCurrencySelection(items: ["A", "B", "C"])])
        }
    }
    
    func testOnDayResetSelected_shouldTriggerEventShow() {
        viewModel.onDayResetTapped()
        
        wait {
            XCTAssertEqual(self.testHelper.values, [.showDayResetInput(current: 999)])
        }
    }
    
    func testOnCurrencySelected_shouldUpdateSetting()  {
        viewModel.onCurrencySelected(currency: "selected")
        wait {
            XCTAssertEqual(self.testHelper.values, [.updateCurrency(currency: "selected")])
        }
    }
    
    func testOnResetDaySelected_isInvalid_shouldTriggerErrorMessage() {
        viewModel.onResetDaySelected(day: 0)
        viewModel.onResetDaySelected(day: -1)
        viewModel.onResetDaySelected(day: 32)
        
        wait {
            XCTAssertEqual(self.testHelper.values, [
                .showError(message: "Day should between 1 until 28. We still a MVP :)"),
                .showError(message: "Day should between 1 until 28. We still a MVP :)"),
                .showError(message: "Day should between 1 until 28. We still a MVP :)")
            ])
        }
    }

    func testOnResetDaySelected_valid_shouldUpdateSetting() {
        viewModel.onResetDaySelected(day: 12)
        
        wait {
            XCTAssertEqual(self.testHelper.values, [.updateResetDay(resetDay: "Every 12")])
        }
    }
}
