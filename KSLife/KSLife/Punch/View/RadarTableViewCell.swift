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
    var nutrients: [Nutrient] = []

    private var chartView = RadarChartView()
    
    convenience init( title: String, nutrients: [Nutrient], color: UIColor = .black) {
        self.init(style: .default, reuseIdentifier: "")
        self.title = title
        self.nutrients = nutrients
        for i in nutrients {
             labels.append(i.name)
        }
        chartView.backgroundColor = .white
        chartView.rotationEnabled = true
        chartView.webLineWidth = 1
        chartView.webColor = color
        chartView.innerWebLineWidth = 2
        chartView.innerWebColor = color
        chartView.alpha = 1
        chartView.xAxis.valueFormatter = self
        chartView.setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        chartView.legend.enabled = false
        
        let xAxis = chartView.xAxis
        xAxis.labelFont = .systemFont(ofSize: 13)
        
        let yAxis = chartView.yAxis
        yAxis.axisMinimum = 0
        yAxis.axisMaximum = 1
        yAxis.setLabelCount(5, force: true)
        yAxis.drawLabelsEnabled = false
        yAxis.labelFont = .systemFont(ofSize: 13)
        
        contentView.addSubview(chartView)
        let padding: CGFloat = 20
        chartView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(contentView).offset(padding)
            make.bottom.equalTo(contentView).offset(-padding)
            make.centerX.equalTo(contentView)
            make.width.equalTo(chartView.snp.height)
        }
        
        setData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func setData() {
        var yVals: [ChartDataEntry] = []
        for i in nutrients {
            yVals.append(ChartDataEntry(x: 0, y: i.radarValue))
        }
        let set = RadarChartDataSet(values: yVals, label: title)
        set.lineWidth = 0.5
        set.setColor(.red)
        set.drawFilledEnabled = true
        set.fillColor = .red
        set.fillAlpha = 0.25
        set.drawValuesEnabled = false
        set.valueTextColor = .black
        set.drawHighlightCircleEnabled = false
        
        let data = RadarChartData(dataSet: set)
        chartView.data = data
    }

}

extension RadarTableViewCell: IAxisValueFormatter {

    public func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return labels.count == 0 ? "" : labels[Int(value) % labels.count]
    }
}
