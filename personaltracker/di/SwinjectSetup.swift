//
//  SwinjectSetup.swift
//  personaltracker
//
//  Created by kur niadi  on 10/07/22.
//

import Foundation
import SwinjectStoryboard

extension SwinjectStoryboard {

    class func setup() {
        defaultContainer.storyboardInitCompleted(WelcomPageViewController.self) { r, n in
            n.viewModel = r.resolve(WelcomePageViewModel.self)!
        }
        
        registerAdapter()
        registerInteractor()
        registerViewModel()
    }
    
    class func resolveDefault<Service>(_ service: Service.Type) -> Service? {
        return SwinjectStoryboard.defaultContainer.synchronize().resolve(service)
    }
}
