//
//  ChartAxisValueFormatter.swift
//  Currency
//
//  Created by Saffi on 2022/2/7.
//

import Foundation
import Charts

class ChartAxisValueFormatter: IAxisValueFormatter {
    weak var chart: BarChartView?
    private var titles: [String] = []

    init(titles: [String], chart: BarChartView) {
        self.titles = titles
        self.chart = chart
    }

    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return titles[Int(value)]
    }
}
