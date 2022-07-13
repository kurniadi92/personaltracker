//
//  BarchatView+Extension.swift
//  personaltracker
//
//  Created by kur niadi  on 13/07/22.
//

import Foundation
import Charts

extension BarChartView {
    func setup(day: [Int]) {
        chartDescription.enabled = false
        
        isUserInteractionEnabled = false
        let xAxis = xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.granularity = 1
        xAxis.labelCount = 30
        xAxis.valueFormatter = DayAxisValueFormatter(day: day)

        let leftAxisFormatter = NumberFormatter()
        leftAxisFormatter.minimumFractionDigits = 0
        leftAxisFormatter.maximumFractionDigits = 1
        leftAxisFormatter.negativeSuffix = " $"
        leftAxisFormatter.positiveSuffix = " $"
        
        let leftAxis = leftAxis
        leftAxis.labelFont = .systemFont(ofSize: 10)
        leftAxis.labelCount = 8
        leftAxis.valueFormatter = DefaultAxisValueFormatter(formatter: leftAxisFormatter)
        leftAxis.labelPosition = .outsideChart
        leftAxis.spaceTop = 0.15
        leftAxis.axisMinimum = 0 // FIXME: HUH?? this replaces startAtZero = YES
        
        let rightAxis = rightAxis
        rightAxis.enabled = true
        rightAxis.labelFont = .systemFont(ofSize: 10)
        rightAxis.labelCount = 8
        rightAxis.valueFormatter = leftAxis.valueFormatter
        rightAxis.spaceTop = 0.15
        rightAxis.axisMinimum = 0
        
        let l = legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .bottom
        l.orientation = .horizontal
        l.drawInside = false
        l.form = .circle
        l.formSize = 9
        l.font = UIFont(name: "HelveticaNeue-Light", size: 11)!
        l.xEntrySpace = 4
    }
    
    func setDataBar(source: [Int]) {        
        let yVals = (0..<source.count).map { (i) -> BarChartDataEntry in
            return BarChartDataEntry(x: Double(source[i]), y: Double.random(in: 0..<10))
        }
        
        var set1: BarChartDataSet! = nil
        if let set = data?.first as? BarChartDataSet {
            set1 = set
            set1.replaceEntries(yVals)
            data?.notifyDataChanged()
            notifyDataSetChanged()
        } else {
            set1 = BarChartDataSet(entries: yVals, label: "Expense By Day")
            set1.colors = [NSUIColor(red: 255/255.0, green: 0, blue: 0, alpha: 1.0)]
            set1.drawValuesEnabled = false
            
            let dataChart = BarChartData(dataSet: set1)
            dataChart.setValueFont(UIFont(name: "HelveticaNeue-Light", size: 10)!)
            dataChart.barWidth = 0.9
            data = dataChart
        }
    }
}
