//
//  WelcomePageViewModel.swift
//  personaltracker
//
//  Created by kur niadi  on 10/07/22.
//

import Foundation
import RxSwift
import RxCocoa

enum WelcomePageViewModelEvent: Equatable {
    case goToMainPage
    case enableGo(isEnabled: Bool)
}

protocol WelcomePageViewModel {
    
    func viewDidAppear()
    func goTapped(name: String)
    func onTextChange(text: String)
    
    var event: Signal<WelcomePageViewModelEvent> { get }
}

class WelcomePageViewModelImpl: WelcomePageViewModel {
        
    private let storage: SettingStorage
    private let _event = PublishSubject<WelcomePageViewModelEvent>()
    
    var event: Signal<WelcomePageViewModelEvent> {
        return _event.asSignal(onErrorSignalWith: .empty())
    }
    
    init(storage: SettingStorage) {
        self.storage = storage
    }
    
    func viewDidAppear() {
        if storage.getName() != nil {
            _event.onNext(.goToMainPage)
        } else {
            _event.onNext(.enableGo(isEnabled: false))
        }
    }
    
    func onTextChange(text: String) {
        let cleanText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        _event.onNext(.enableGo(isEnabled: !cleanText.isEmpty))
    }
    
    func goTapped(name: String) {
        storage.saveName(name: name)
        storage.saveResetDay(day: 1)
        _event.onNext(.goToMainPage)
    }
}
