//
//  WelcomePageViewModelTest.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 10/07/22.
//

import XCTest
import RxSwift

@testable import personaltracker

extension XCTestCase {
    func wait(interval: TimeInterval = 0.2 , completion: @escaping (() -> Void)) {
        let exp = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            completion()
            exp.fulfill()
        }
        waitForExpectations(timeout: interval + 0.1) // add 0.1 for sure asyn after called
    }
}

class WelcomePageViewModelTest: XCTestCase {
    
    private var viewModel: WelcomePageViewModel!
    private var testHelper: RxSignalTestHelper<WelcomePageViewModelEvent>!

    override func setUpWithError() throws {
        testHelper = RxSignalTestHelper()
    }
    
    func testViewLoad_IfAlreadyHaveName_ShouldGoToMainPage() {
        let storageMock = SettingStorageMock()
        storageMock.saveName(name: "random")
        
        viewModel = WelcomePageViewModelImpl(storage: storageMock)
                
        testHelper.observeValue(observable: viewModel.event)
        
        viewModel.viewLoad()
        
        wait {
            XCTAssertEqual(
                self.testHelper.values,
                [.goToMainPage]
            )
        }

    }
    
    func testViewLoadIfAlready_Not_HaveNameShould_NOT_GoToMainPage() {
        viewModel = WelcomePageViewModelImpl(storage: SettingStorageMock())
                
        testHelper.observeValue(observable: viewModel.event)
        
        viewModel.viewLoad()
        
        wait {
            XCTAssertEqual(self.testHelper.values, [.enableGo(isEnabled: false)])
        }
    }
    
    func testOnTextChange_WhenNotJustSpaceOrWhiteSpaceOrEmpty_ShouldReturnEanbleGoTrue() {
        viewModel = WelcomePageViewModelImpl(storage: SettingStorageMock())
                
        testHelper.observeValue(observable: viewModel.event)
        
        viewModel.onTextChange(text: " cool kid ")
        
        wait {
            XCTAssertEqual(self.testHelper.values, [.enableGo(isEnabled: true)])
        }
    }

    func testOnTextChange_WhenJustSpaceOrWhiteSpaceOrEmpty_ShouldReturnEanbleGoFalse() {
        viewModel = WelcomePageViewModelImpl(storage: SettingStorageMock())
                
        testHelper.observeValue(observable: viewModel.event)
        
        viewModel.onTextChange(text: " ")
        viewModel.onTextChange(text: "")
        
        wait {
            XCTAssertEqual(self.testHelper.values, [.enableGo(isEnabled: false), .enableGo(isEnabled: false)])
        }
    }
    
    func testGoTapped_shouldSaveName_theGoToMain() {
        let storageMock = SettingStorageMock()
        viewModel = WelcomePageViewModelImpl(storage: storageMock)
                
        testHelper.observeValue(observable: viewModel.event)
        
        viewModel.goTapped(name: "random")
        
        wait {
            XCTAssertEqual(self.testHelper.values, [.goToMainPage])
            XCTAssertEqual(storageMock.getName(), "random")
        }
    }
}