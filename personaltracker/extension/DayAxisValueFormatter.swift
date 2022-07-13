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
        return day[Int(value - 1)].description
    }
}
