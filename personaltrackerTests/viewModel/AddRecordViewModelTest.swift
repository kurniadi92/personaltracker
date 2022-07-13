//
//  AddRecordViewModelTest.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 12/07/22.
//

import XCTest
import RxSwift

@testable import personaltracker

class AddRecordViewModelTest: XCTestCase {
    
    var viewModel: AddRecordViewModel!
    private var testHelper: RxSignalTestHelper<AddRecordViewModelEvent>!
    
    private var addRecordInteractor: AddRecordInteractor!
    
    override func setUpWithError() throws {
        testHelper = RxSignalTestHelper()
        addRecordInteractor = AddRecordInteractorMock()
        
        viewModel = AddRecordViewModelImpl(addRecordInteractor: addRecordInteractor)
        
        testHelper.observeValue(observable: viewModel.event)
    }
    
    func testViewLoad_withEditAction_shouldSetAppearance() {
        viewModel.viewLoad(type: .undefined, action: .edit(uuid: "uuid"))
        
        wait {
            XCTAssertEqual(self.testHelper.values, [
                .setExpenseAppeareance,
                .updateCategory,
                .setEditAppeareance(viewParam: RecordViewParam(uid: "uuid", title: "mock", category: "FnB", type: "expense", amount: 0, imageId: "mock", createdAt: 0)),
                .updateCategory
            ])
        }
    }
    
    func testViewLoad_withExpenseType_shouldSetExpenseAppearance() {
        viewModel.viewLoad(type: .expense, action: .add)
        
        wait {
            XCTAssertEqual(self.testHelper.values, [
                .setExpenseAppeareance,
                .updateCategory
            ])
        }
    }
    
    func testViewLoad_withIncomeType_shouldSetIncomeAppearance() {
        viewModel.viewLoad(type: .income, action: .add)
        
        wait {
            XCTAssertEqual(self.testHelper.values, [
                .setIncomeAppeareance,
                .updateCategory
            ])
        }
    }
    
    
    func testGetCategory_shouldReturnCategoryViewParam() {
        viewModel.viewLoad(type: .income, action: .add)
        let defaultCategory = CategoryViewParam(name: "General")
        defaultCategory.isSelected = true
        
        XCTAssertEqual(viewModel.category(index: 0),defaultCategory)
        XCTAssertEqual(viewModel.category(index: 1), CategoryViewParam(name: "three"))
        
        viewModel.viewLoad(type: .expense, action: .add)
        XCTAssertEqual(viewModel.category(index: 0),defaultCategory)
        XCTAssertEqual(viewModel.category(index: 1), CategoryViewParam(name: "one"))
    }
    
    func testGetItemSize_shouldReturnCalculatedSizeForCell() {
        viewModel.viewLoad(type: .expense, action: .add)
        XCTAssertEqual(viewModel.itemSize(index: 1), CGSize(width: 33, height: 42))
        
        viewModel.viewLoad(type: .income, action: .add)
        XCTAssertEqual(viewModel.itemSize(index: 1), CGSize(width: 39, height: 42))
    }
    
    func testCategoryCount_shouldReturn_categoriesCount() {
        viewModel.viewLoad(type: .expense, action: .add)
        XCTAssertEqual(viewModel.categoryCount, 3)
        
        viewModel.viewLoad(type: .income, action: .add)
        XCTAssertEqual(viewModel.categoryCount, 4)
    }
    
    func testSelectCategory_shouldUpdateSelected_toTrue() {
        viewModel.viewLoad(type: .expense, action: .add)
        testHelper.reset()
        
        viewModel.selectCategory(index: 1)
        
        wait {
            XCTAssertEqual(self.testHelper.values, [
                .updateCategory
            ])
            
            let selectedCategory = CategoryViewParam(name: "one")
            selectedCategory.isSelected = true
            XCTAssertEqual(self.viewModel.category(index: 1), selectedCategory)
        }
    }
    
    func testSave_shouldSaveAllData_whenSuccess_thenShowSuccess() {
        let interactor = AddRecordInteractorMock()
        viewModel = AddRecordViewModelImpl(addRecordInteractor: interactor)
        testHelper.observeValue(observable: viewModel.event)

        viewModel.viewLoad(type: .expense, action: .add)
        testHelper.reset()
        
        viewModel.setImage(url: URL(fileURLWithPath: "file:///Documents/1657633385"))
                
        viewModel.save(title: "title", amount: 100)
        wait {
            XCTAssertEqual(self.testHelper.values, [
                .showSuccess
            ])
            
            XCTAssertEqual(interactor.record.amount, 100)
            XCTAssertEqual(interactor.record.title, "title")
            XCTAssertEqual(interactor.record.category, "General")
            XCTAssertEqual(interactor.record.type, "expense")
            XCTAssertEqual(interactor.record.imageId, "1657633385")
        }
    }
    
    func testSave_shouldSaveAllData_whenError_thenShowErrorMessage() {
        let interactor = AddRecordInteractorErrorMock()
        viewModel = AddRecordViewModelImpl(addRecordInteractor: interactor)
        testHelper.observeValue(observable: viewModel.event)

        viewModel.viewLoad(type: .expense, action: .add)
        testHelper.reset()
                
        viewModel.save(title: nil, amount: 100)
        viewModel.save(title: "", amount: 100)
        viewModel.save(title: "title", amount: 0)
        viewModel.save(title: "title", amount: -1)
        viewModel.save(title: "title", amount: 100)
        viewModel.save(title: nil, amount: 0)
        viewModel.save(title: "", amount: -1)
        
        wait {
            XCTAssertEqual(self.testHelper.values, [
                .showError(message: "Title cannot be empty."),
                .showError(message: "Title cannot be empty."),
                .showError(message: "Amount should more than 0."),
                .showError(message: "Amount should more than 0."),
                .showError(message: "Title cannot be empty. Amount should more than 0."),
                .showError(message: "Title cannot be empty. Amount should more than 0."),
                .showError(message: RxError.unknown.localizedDescription),
            ])
        }
    }
}
