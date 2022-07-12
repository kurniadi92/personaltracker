//
//  AddRecordViewModel.swift
//  personaltracker
//
//  Created by kur niadi  on 12/07/22.
//

import Foundation
import RxSwift
import RxCocoa

enum RecordType: String {
    case expense
    case income
}

enum AddRecordViewModelEvent: Equatable {
    case setExpenseAppeareance
    case setIncomeAppeareance
    case updateCategory
    case showSuccess
    case showError(message: String)
}

protocol AddRecordViewModel {
    var event: Signal<AddRecordViewModelEvent> { get }
    var categoryCount: Int { get }
    func viewLoad(type: RecordType)
    func category(index: Int) -> CategoryViewParam
    func itemSize(index: Int) -> CGSize
    func selectCategory(index: Int)
    func setImage(url: URL)
    func save(title: String?, amount: Int)
}

class AddRecordViewModelImpl: AddRecordViewModel {
    
    private var type = RecordType.expense
    private let _event = PublishSubject<AddRecordViewModelEvent>()
    private let addRecordInteractor: AddRecordInteractor
    private var categories = [CategoryViewParam]()
    private var url: URL?
    
    private let disposeBag = DisposeBag()
    
    init(addRecordInteractor: AddRecordInteractor) {
        self.addRecordInteractor = addRecordInteractor
    }
    
    var event: Signal<AddRecordViewModelEvent> {
        return _event.asSignal(onErrorSignalWith: .empty())
    }
    
    var categoryCount: Int {
        return categories.count
    }
    
    func viewLoad(type: RecordType) {
        self.type = type
        if (type == .expense) {
            _event.onNext(.setExpenseAppeareance)
            categories = addRecordInteractor.getExpenseCategory().map { title in
                return CategoryViewParam(name: title)
            }
            categories.insert(CategoryViewParam.addDefault(), at: 0)
            
        } else {
            _event.onNext(.setIncomeAppeareance)
            categories = addRecordInteractor.getIncomeCategory().map { title in
                return CategoryViewParam(name: title)
            }
            categories.insert(CategoryViewParam.addDefault(), at: 0)
        }
        
        _event.onNext(.updateCategory)
    }
    
    func category(index: Int) -> CategoryViewParam {
        return categories[index]
    }
    
    func itemSize(index: Int) -> CGSize {
        let totalMargin = 24
        return CGSize(width: categories[index].name.count * 3 + totalMargin, height: 42)
    }
    
    func selectCategory(index: Int) {
        categories = categories.map { viewParam in
            viewParam.isSelected = false
            return viewParam
        }
        
        categories[index].isSelected = true
        _event.onNext(.updateCategory)
    }
    
    func setImage(url: URL) {
        self.url = url
    }
    
    func save(title: String?, amount: Int) {
        var message: String = ""
        if title == nil || (title?.isEmpty ?? true) {
            message = "Title cannot be empty."
        }
        
        if amount <= 0 {
            let appendix = message.isEmpty ? "" : " "
            message = "\(message)\(appendix)Amount should more than 0."
        }
        
        let selectedCategory = categories.first { $0.isSelected == true }?.name ?? ""
        
        if !message.isEmpty {
            _event.onNext(.showError(message: message))
        } else {
            addRecordInteractor.save(title: title!,
                                     amount: amount,
                                     category: selectedCategory,
                                     type: type.rawValue,
                                     imageId: url?.lastPathComponent ?? "")
            .subscribe(on: ConcurrentDispatchQueueScheduler(qos: .utility))
            .subscribe { [weak self] _ in
                self?._event.onNext(.showSuccess)
            } onFailure: { [weak self] error in
                self?._event.onNext(.showError(message: error.localizedDescription))
            }.disposed(by: disposeBag)

        }
    }
}
