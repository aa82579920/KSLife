//
//  5000 AnalysisViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/23.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class AnalysisViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
    }
    
    var shouldLoadSections: [Int] = []
    
    private let sectionName = ["基础营养素", "氨基酸", "脂肪酸", "其他", "专家分析"]
    
    private let itemH: CGFloat = 100
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.estimatedRowHeight = 0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight  = 10
        tableView.sectionHeaderHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        return tableView
        }()

}

extension AnalysisViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        default:
            let n = section - 1
            if shouldLoadSections.contains(n) {
                return 10
            } else {
                return 1
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        
        switch indexPath.section {
        case 0:
            cell = RadarTableViewCell(title: "", labels: ["水", "能量","蛋白质","碳水化合物","膳食纤维"])
        default:
            let n = indexPath.section - 1
            
            if indexPath.row == 0 {
                let cell = FoldTableViewCell(with: .section, name: sectionName[n])
                if shouldLoadSections.contains(n) {
                    cell.canUnfold = false
                } else {
                    cell.canUnfold = true
                }
                cell.selectionStyle = .none
                return cell
            } else {
                if shouldLoadSections.contains(n) {
                    cell = FoldTableViewCell(with: .item, name: "hhhhhhh")
                }
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            let n = indexPath.section - 1
            if indexPath.row == 0 {
                if self.shouldLoadSections.contains(n) {
                    self.shouldLoadSections = self.shouldLoadSections.filter { e in
                        return e != n
                    }
                } else {
                    self.shouldLoadSections.append(n)
                }
                tableView.reloadData()
                tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.section), at: .top, animated: true)
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 330
        default:
            return 60
        }
    }
}

extension AnalysisViewController {
    func setUpUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
}
