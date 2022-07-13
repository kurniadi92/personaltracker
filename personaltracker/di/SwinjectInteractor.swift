//
//  SwinjectInteractor.swift
//  personaltracker
//
//  Created by kur niadi  on 11/07/22.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func registerInteractor() {
        defaultContainer.register(SettingInteractor.self) { r in
            return SettingInteractorImpl(storage: r.resolve(SettingStorage.self)!)
        }
        
        defaultContainer.register(AddRecordInteractor.self) { r in
            return AddRecordInteractorImpl(recordStorage: r.resolve(RecordStorage.self)!)
        }
        
        defaultContainer.register(DashboardInteractor.self) { r in
            return DashboardInteractorImpl(
                recordStorage: r.resolve(RecordStorage.self)!,
                settings: r.resolve(SettingStorage.self)!, currentDate: { return Date() }
            )
        }
    }
}
