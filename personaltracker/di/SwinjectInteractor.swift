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
    }
}
