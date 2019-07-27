//
//  CalendarViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/21.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
typealias PeriodBlock = (_ period: (String, String))->(Void)

class CalendarViewController: SwiftPopup {
    
    var block: PeriodBlock?
    
    var calendarView: CalendarView?
    /// 年月显示
    var yearOMonthLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()
    /// 日历顶部显示年份月份
    var yearOMonth: Date = Date() {
        didSet {
            //年份月份展示label
            self.yearOMonthLabel.text = self.formatYearOMonth(yearOMonth)
            //月份日期展示collectionview
            self.calendarView?.date = yearOMonth
        }
    }
    /// 上一个月份按钮
    var lastButton: UIButton = UIButton()
    /// 下一个月份按钮
    var nextButton: UIButton = UIButton()
    
    var cellWidth: CGFloat = 0.0
    var cellHeight: CGFloat = 0.0
    /// 日历外边框
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    /// 日历外边框宽度
    var contentWidth: CGFloat = 0.0
    
    var firstLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.textAlignment = .center
        return label
    }()
    
    var secondLabel: UILabel = {
        let label = UILabel()
        label.layer.cornerRadius = 5
        label.layer.borderWidth = 1
        label.layer.borderColor = UIColor.lightGray.cgColor
        label.textAlignment = .center
        return label
    }()
    
    var sureButton: UIButton = {
        let button = NavButton(frame: CGRect.zero, title: "确定")
        button.shadowBlur = 0
        button.shadowOpacity = 0
        button.backgroundColor = mainColor
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "万年历"
        contentWidth = view.bounds.width
        cellWidth = (contentWidth/7)
        cellHeight = 40
        yearOMonthLabel.text = formatYearOMonth(yearOMonth)
        //上个月按钮
        lastButton.setBackgroundImage(UIImage(named: "month_left"), for: .normal)
        lastButton.addTarget(self, action: #selector(getLastMonth), for: .touchUpInside)
        nextButton.setBackgroundImage(UIImage(named: "month_right"), for: .normal)
        nextButton.addTarget(self, action: #selector(getNextMonth), for: .touchUpInside)
        let calendarViewFrame = CGRect(x: 0, y: 70, width: view.bounds.width, height: 265)
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        calendarView = CalendarView(frame: calendarViewFrame, collectionViewLayout: layout)
        contentView.addSubview(calendarView ?? UICollectionView())
        calendarView?.getDatesBlock = { period in
//            self.firstLabel.text = period.0
//            self.secondLabel.text = period.1
        }
        self.calendarView?.date = yearOMonth
        
        sureButton.addTarget(self, action: #selector(selectPeriod), for: .touchUpInside)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentView.frame = CGRect(x: 0, y: self.view.bounds.height - 80 - 265 - 45, width: contentWidth, height: 80 + 265 + 45)
        view.addSubview(self.contentView)
        
        yearOMonthLabel.frame = CGRect(x: contentWidth/2-100, y: 0, width: 200, height: 30)
        contentView.addSubview(yearOMonthLabel)
        
        lastButton.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        contentView.addSubview(self.lastButton)
        
        nextButton.frame = CGRect(x: contentWidth - 30, y: 0, width: 30, height: 30)
        contentView.addSubview(self.nextButton)
        
        let weekView = WeekView(frame: CGRect(x: 0, y: 30, width: contentWidth, height: 30))
        contentView.addSubview(weekView)
        let padding: CGFloat = 10
        let width = (contentWidth - padding * 4 ) / 3
        firstLabel.frame = CGRect(x: padding, y: 80 + 265, width: width, height: 30)
        contentView.addSubview(firstLabel)
        secondLabel.frame = CGRect(x: width + 2 * padding, y: 80 + 265, width: width, height: 30)
        contentView.addSubview(secondLabel)
        sureButton.frame = CGRect(x: 2 * width + 3 * padding, y: 80 + 265, width: width, height: 30)
        contentView.addSubview(sureButton)
        
    }
    
    /// 获取上个月的同一日期
    @objc func getLastMonth() {
        let calendar = Calendar.init(identifier: .gregorian)
        var comLast = DateComponents()
        comLast.setValue(-1, for: .month)
        self.yearOMonth = calendar.date(byAdding: comLast, to: self.yearOMonth)!
    }
    /// 获取下个月的同一日期
    @objc func getNextMonth() {
        let calendar = Calendar.init(identifier: .gregorian)
        var comLast = DateComponents()
        comLast.setValue(+1, for: .month)
        self.yearOMonth = calendar.date(byAdding: comLast, to: self.yearOMonth)!
    }
    /// 将日期展示为年月
    func formatYearOMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy年MM月"
        let string = formatter.string(from: date)
        return string
    }
    
    //点击确定
    @objc func selectPeriod() {
        if firstLabel.text != "" && secondLabel.text != ""{
            if let block = block {
                block((firstLabel.text!, secondLabel.text!))
                dismiss()
                return
            }
        }
        self.tipWithLabel(msg: "请选择完整时间")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        dismiss()
    }
}

