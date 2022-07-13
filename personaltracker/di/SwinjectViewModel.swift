//
//  SwinjectViewModel.swift
//  personaltracker
//
//  Created by kur niadi  on 10/07/22.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func registerViewModel() {
        defaultContainer.register(WelcomePageViewModel.self) { r in
            return WelcomePageViewModelImpl(storage: r.resolve(SettingStorage.self)!)
        }
        
        defaultContainer.register(SettingPageViewModel.self) { r in
            return SettingPageViewModelImpl(setting: r.resolve(SettingInteractor.self)!)
        }
        
        defaultContainer.register(AddRecordViewModel.self) { r in
            return AddRecordViewModelImpl(addRecordInteractor: r.resolve(AddRecordInteractor.self)!)
        }
        
        defaultContainer.register(DashboardViewModel.self) { r in
            return DashboardViewModelImpl(
                dashboardInteractor: r.resolve(DashboardInteractor.self)!,
                currentDate: { return Date() })
        }
    }
}
