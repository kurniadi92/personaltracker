//
//  RecordedPeriodeViewParam.swift
//  personaltracker
//
//  Created by kur niadi  on 14/07/22.
//

import Foundation

struct RecordedPeriodeViewParam: Equatable {
    let start: Int
    let end: Int
    var formattedPeriode: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMM"
        
        let startText = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(start)))
        let endText = dateFormatter.string(from: Date(timeIntervalSince1970: TimeInterval(end)))
        
        return "\(startText) - \(endText)"
    }
}
