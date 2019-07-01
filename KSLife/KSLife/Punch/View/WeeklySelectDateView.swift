//
//  WeeklySelectDateView.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/31.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
typealias DayBlock = (_ date: Date)->(Void)
class WeeklySelectDateView: UIView {
    
    var block: DayBlock?
    
    private let weekWidth: CGFloat = screenW / 7
    private let offsetWeeks = 5
    private let offsetDays = 35
    private let contentWidth: CGFloat = 0
    
    private let weekCollectCellID = "weekCollectCellID"
    private let dateCollectCellID = "dateCollectCellID"
    
    private let weekTitles = ["日","一","二","三","四","五","六"]
    
    private lazy var weekCollectView: UICollectionView = {[unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: weekCollectCellID)
        return collectionView
    }()
    
    private lazy var dateCollectView: UICollectionView = {[unowned self] in
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.isPagingEnabled = true
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(DateSelectCollectionViewCell.self, forCellWithReuseIdentifier:  dateCollectCellID)
        return collectionView
    }()
    
    private lazy var dateDataList: [Date] = {
        var list = [Date]()
        list.append(selectedDate)
        let week = selectedDate.weekday
        for i in 1...(offsetDays + week - 1) {
            let target = selectedDate.dateByAdding(-i, .day)
            list.insert(target.date, at: 0)
        }
        for i in 1...(offsetDays - week + 7) {
            let target = selectedDate.dateByAdding(i, .day)
            list.append(target.date)
        }
        return list
    }()
    
    private var selectedDate: Date = Date()

    convenience init(startDate: Date) {
        self.init(frame: .zero)
        backgroundColor = .white
        selectedDate = startDate
        
        addSubview(weekCollectView)
        addSubview(dateCollectView)
        weekCollectView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self)
            make.top.equalTo(self).offset(15)
            make.height.equalTo(25)
        }
        dateCollectView.snp.makeConstraints { (make) -> Void in
            make.left.right.equalTo(self)
            make.top.equalTo(weekCollectView.snp.bottom).offset(5)
            make.height.equalTo(35)
        }
       
        self.perform(#selector(scrollMiddle), with: nil, afterDelay: 0.5)
    }
    
}

extension WeeklySelectDateView {
    @objc func scrollMiddle() {
        self.dateCollectView.scrollToItem(at: IndexPath(item: self.dateDataList.count / 2 - 3, section: 0), at: .left, animated: false)
    }
    
    @objc func scrollSomeDay(date: Date) {
        var tempIndex = 0
        for (index, obj) in self.dateDataList.enumerated() {
            if (date == obj) {
                tempIndex = index
            }
        }
        self.dateCollectView.scrollToItem(at: IndexPath(item: tempIndex - date.weekday + 1, section: 0), at: .left, animated: false)
    }
    
    func updateSelectedDate(date: Date) {
        self.selectedDate = date
        self.dateCollectView.reloadData()
    }
    
    func configDate(date: Date) {
        if date.isBeforeDate(self.dateDataList.last!, granularity: .day) && date.isAfterDate(self.dateDataList[0], granularity: .day) {
            self.selectedDate = date
            self.perform(#selector(scrollSomeDay), with: nil, afterDelay: 0.00001)
            self.dateCollectView.reloadData()
        }
    }
    
    
}

extension WeeklySelectDateView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == self.weekCollectView {
            return 7
        } else {
            return self.dateDataList.count
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.weekCollectView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: weekCollectCellID, for: indexPath)
            cell.backgroundColor = .white
            let weekLable = UILabel()
            weekLable.backgroundColor = .clear
            weekLable.textColor = .black
            weekLable.font = .systemFont(ofSize: 14)
            weekLable.textAlignment = .center
            cell.contentView.addSubview(weekLable)
            weekLable.snp.makeConstraints { (make) -> Void in
                make.edges.equalToSuperview()
            }
            weekLable.text = weekTitles[indexPath.row]
            if (indexPath.row == 0 || indexPath.row == 6) {
                weekLable.alpha = 0.5
            }
            return cell
        } else {
            let tempDate = self.dateDataList[indexPath.row]
            let cell = dateCollectView.dequeueReusableCell(withReuseIdentifier: dateCollectCellID, for: indexPath) as! DateSelectCollectionViewCell
            cell.isUserInteractionEnabled = true
            cell.dayBtn.setTitleColor(.black, for: .normal)
            cell.fillDataWithDate(date: tempDate)
            if tempDate.weekday == 1 || tempDate.weekday == 7 {
                cell.dayBtn.titleLabel?.alpha = 0.5
            } else {
                cell.dayBtn.titleLabel?.alpha = 1
            }
            cell.dayBtn.isSelected = tempDate == self.selectedDate
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == self.weekCollectView {
            return CGSize(width: weekWidth, height: 25)
        } else {
            return CGSize(width: weekWidth, height: 35)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.dateCollectView {
            let tempDate = self.dateDataList[indexPath.row]
            self.updateSelectedDate(date: tempDate)
        }
        if let block = self.block {
            block(dateDataList[indexPath.row])
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

}

