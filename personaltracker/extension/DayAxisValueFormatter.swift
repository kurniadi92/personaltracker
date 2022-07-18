//
//  DayAxisValueFormatter.swift
//  personaltracker
//
//  Created by kur niadi  on 13/07/22.
//

import Foundation
import Charts

public class DayAxisValueFormatter: NSObject, AxisValueFormatter {
    private var day = [Int]()
    
    init(day: [Int]) {
        self.day = day
    }
    
    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let day = day.first { $0 == Int(value) }
        
        if let dayUnwrap = day {
            return dayUnwrap.description
        } else {
            return ""
        }
    }
}
