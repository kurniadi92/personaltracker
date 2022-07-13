//
//  XCTestCase+Extension.swift
//  personaltrackerTests
//
//  Created by kur niadi  on 13/07/22.
//

import Foundation
import XCTest

extension XCTestCase {
    func wait(interval: TimeInterval = 0.2 , completion: @escaping (() -> Void)) {
        let exp = expectation(description: "")
        DispatchQueue.main.asyncAfter(deadline: .now() + interval) {
            completion()
            exp.fulfill()
        }
        waitForExpectations(timeout: interval + 0.1) // add 0.1 for sure asyn after called
    }
}
