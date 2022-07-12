//
//  SwinjectAdapter.swift
//  personaltracker
//
//  Created by kur niadi  on 10/07/22.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {
    class func registerAdapter() {
        defaultContainer.register(SettingStorage.self) { _ in
            return SettingStorageImpl(storage: UserDefaults.standard)
        }
        
        defaultContainer.register(RecordStorage.self) { _ in
            return RecordStorageImpl(realm: RealmCreator.create())
        }
    }
}
