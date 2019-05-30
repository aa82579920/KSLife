//
//  RadarTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/29.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import Charts

class RadarTableViewCell: UITableViewCell {
    
    var title: String = ""
    var labels: [String] = []

    private var chartView = RadarChartView()
    
    convenience init( title: String, labels: [String]) {
        self.init(style: .default, reuseIdentifier: "")
        self.title = title
        self.labels = labels
        chartView.xAxis.valueFormatter = self
        
        let yAxis = chartView.yAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 100
        yAxis.labelCount = 4
        yAxis.drawLabelsEnabled = false
        
        let dataEntries = (0..<labels.count).map { (i) -> RadarChartDataEntry in
            return RadarChartDataEntry(value: Double(arc4random_uniform(50) + 50))
        }
        let chartDataSet = RadarChartDataSet(values: dataEntries, label: "基础营养素")
        
        let chartData = RadarChartData(dataSets: [chartDataSet])
        
        chartView.data = chartData
        
        contentView.addSubview(chartView)
        let padding: CGFloat = 15
        chartView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(padding)
            make.bottom.equalTo(contentView).offset(-padding)
            make.centerX.equalTo(contentView)
//            make.height.equalTo(300)
            make.width.equalTo(chartView.snp.height)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }

}

extension RadarTableViewCell: IAxisValueFormatter {

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return labels[Int(value) % labels.count]
    }
}
