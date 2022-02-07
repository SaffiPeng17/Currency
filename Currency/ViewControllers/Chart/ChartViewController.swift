//
//  ChartViewController.swift
//  Currency
//
//  Created by Saffi on 2022/2/7.
//

import UIKit
import Charts

class ChartViewController: BaseViewController<ChartViewControllerVM> {

    private lazy var chartTitle: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()

    private lazy var chartDateRange: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    private lazy var chartView: BarChartView = {
        let view = BarChartView()
        view.dragEnabled = false
        view.doubleTapToZoomEnabled = false
        view.highlightPerTapEnabled = false
        view.pinchZoomEnabled = false
        view.drawBarShadowEnabled = false
        view.drawBordersEnabled = false
        view.drawGridBackgroundEnabled = true
        view.rightAxis.enabled = false
        view.animate(xAxisDuration: 2)
        return view
    }()

    override func setupViews() {
        super.setupViews()

        title = "匯率歷史紀錄"
        view.backgroundColor = .white

        view.addSubview(chartTitle)
        view.addSubview(chartDateRange)
        view.addSubview(chartView)

        chartTitle.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(25)
            make.leading.equalTo(15)
            make.trailing.equalTo(-15)
            make.height.equalTo(20)
        }

        chartDateRange.snp.makeConstraints { make in
            make.top.equalTo(chartTitle.snp.bottom).offset(15)
            make.leading.trailing.equalTo(chartTitle)
            make.height.equalTo(18)
        }

        chartView.snp.makeConstraints { make in
            make.top.equalTo(chartDateRange.snp.bottom).offset(20)
            make.leading.equalTo(8)
            make.trailing.equalTo(-8)
            make.height.equalToSuperview().multipliedBy(0.6)
        }

        setupTitles()
        setChartData(viewModel.chartTuple)
    }
}

private extension ChartViewController {
    func setupTitles() {
        chartDateRange.text = viewModel.dataRange
        chartTitle.text = viewModel.title
    }

    func setChartData(_ data: (titles: [String], values: [Double])) {
        chartView.noDataText = "No data for the chart."

        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10)
        xAxis.labelCount = data.titles.count
        xAxis.valueFormatter = ChartAxisValueFormatter(titles: data.titles, chart: chartView)

        var entries: [BarChartDataEntry] = []
        for (index, value) in data.values.enumerated() {
            let entry = BarChartDataEntry(x: Double(index), y: value)
            entries.append(entry)
        }

        let chartDataSet = BarChartDataSet(entries: entries, label: viewModel.chartTitle)
        let chartData = BarChartData(dataSet: chartDataSet)
        chartView.data = chartData

        chartView.setNeedsDisplay()
    }
}
