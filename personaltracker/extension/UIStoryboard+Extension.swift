//
//  UIStoryboard+Extension.swift
//  personaltracker
//
//  Created by kur niadi  on 13/07/22.
//

import Foundation
import UIKit

extension UIStoryboard {
    static func createViewController<T: UIViewController>(vc: T.Type) -> T? {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: String(describing: vc.self)) as? T
        
        return newViewController
    }
}
