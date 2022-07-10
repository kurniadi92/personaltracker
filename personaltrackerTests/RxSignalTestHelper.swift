//
//  RxSignalTestHelper.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 10/07/22.
//

import Foundation
import RxSwift
import RxCocoa

class RxSignalTestHelper<T> {
    private (set) var values = [T]()
    
    private let disposeBag = DisposeBag()
    
    func reset() {
        values.removeAll()
    }
    
    func observeValue(observable: Signal<T>) {
        observable.emit(onNext: { [weak self] value in
            self?.values.append(value)
        }).disposed(by: disposeBag)
    }
}
