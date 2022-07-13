//
//  PieChartView+Extensionn.swift
//  personaltracker
//
//  Created by kur niadi  on 13/07/22.
//

import Foundation
import Charts

extension PieChartView {
    func setup() {
        highlightPerTapEnabled = true
        
        let l = legend
        l.horizontalAlignment = .left
        l.verticalAlignment = .top
        l.orientation = .vertical
        l.drawInside = true
        l.xEntrySpace = 7
        l.yEntrySpace = 0
        
        drawEntryLabelsEnabled = false
        
        entryLabelColor = .white
        entryLabelFont = .systemFont(ofSize: 12, weight: .light)
        
        animate(xAxisDuration: 1.4, easingOption: .easeOutBack)
    }
    
    func setDataCount(dataRaw: [PieChartViewParam]) {
        let entries = (0..<dataRaw.count).map { (i) -> PieChartDataEntry in
            let total = dataRaw.map{ $0.totalExpense }.reduce(0, +)
            let value:Double = (Double(dataRaw[i].totalExpense) / Double(total)) * 100
            return PieChartDataEntry(value: value,
                                     label: dataRaw[i].category,
                                     icon: nil)
        }
        
        let set = PieChartDataSet(entries: entries, label: "")
        set.drawIconsEnabled = false
        set.sliceSpace = 2
        
        
        set.colors = ChartColorTemplates.vordiplom()
            + ChartColorTemplates.joyful()
            + ChartColorTemplates.colorful()
            + ChartColorTemplates.liberty()
            + ChartColorTemplates.pastel()
        
        let dataChart = PieChartData(dataSet: set)
        
        let pFormatter = NumberFormatter()
        pFormatter.numberStyle = .percent
        pFormatter.maximumFractionDigits = 1
        pFormatter.multiplier = 1
        pFormatter.percentSymbol = " %"
        dataChart.setValueFormatter(DefaultValueFormatter(formatter: pFormatter))
        
        dataChart.setValueFont(.systemFont(ofSize: 11, weight: .light))
        dataChart.setValueTextColor(.black)
        
        data = dataChart
        highlightValues(nil)
    }
}
