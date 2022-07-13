//
//  SettingPageViewModel.swift
//  personaltracker
//
//  Created by kur niadi  on 11/07/22.
//

import Foundation
import RxSwift
import RxCocoa

enum SettingPageViewModelEvent: Equatable {
    case updateCurrency(currency: String)
    case updateResetDay(resetDay: String)
    case showError(message: String)
    case showCurrencySelection(items: [String])
    case showDayResetInput(current: Int)
}

protocol SettingPageViewModel {
    func viewLoad()
    func onCurrenncyTapped()
    func onDayResetTapped()
    func onCurrencySelected(currency: String)
    func onResetDaySelected(day: Int)
    
    var event: Signal<SettingPageViewModelEvent> { get }
}

class SettingPageViewModelImpl: SettingPageViewModel {
    
    private let _event = PublishSubject<SettingPageViewModelEvent>()
    private let setting: SettingInteractor
    
    var event: Signal<SettingPageViewModelEvent> {
        return _event.asSignal(onErrorSignalWith: .empty())
    }
    
    init(setting: SettingInteractor) {
        self.setting = setting
    }
    
    private var resetDayWord: String {
        return "Every \(setting.getSelectedResetDay())"
    }
    
    func viewLoad() {
        _event.onNext(.updateCurrency(currency: setting.getSelectedCurrency()))
        _event.onNext(.updateResetDay(resetDay: resetDayWord))
    }
    
    func onCurrenncyTapped() {
        _event.onNext(.showCurrencySelection(items: setting.getAllCurrency))
    }
    
    func onDayResetTapped() {
        _event.onNext(.showDayResetInput(current: setting.getSelectedResetDay()))
    }
    
    func onCurrencySelected(currency: String) {
        setting.setCurrency(currency: currency)
        _event.onNext(.updateCurrency(currency: setting.getSelectedCurrency()))
    }
    
    func onResetDaySelected(day: Int) {
        if day > 0 && day <= 28 {
            setting.setResetDay(day: day)
            _event.onNext(.updateResetDay(resetDay: resetDayWord))
        } else {
            _event.onNext(.showError(message: "Day should between 1 until 28. We still a MVP :)"))
        }
    }
}
