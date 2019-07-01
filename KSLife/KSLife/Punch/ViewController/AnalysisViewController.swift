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
        analyseDiet(uid: UserInfo.shared.user.uid, day: Date().toISO([.withFullDate]), success: {
            self.tableView.reloadData()
        })
    }
    
    private var shouldLoadSections: [Int] = []
    private var vitamin: [(String, String)] = []
    private var amino: [(String, String)] = []
    private var aliphatic: [(String, String)] = []
    
    //RadarView
    private let num = [5, 6, 9]
    private let colors: [UIColor] = [UIColor(hex6: 0x2EA9DF), UIColor(hex6: 0x42602D), UIColor(hex6: 0xB28FCE)]
    private let titles = ["基础营养素", "维生素", "微量元素"]
    private var datas: [[Nutrient]] = [[],[],[]]
    
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
        let n = section - 1
        let all = [vitamin, amino, aliphatic]
        switch section {
        case 0:
            return 3
        case 1, 2, 3:
            return shouldLoadSections.contains(n) ? all[n].count + 1 : 1
        default:
            return shouldLoadSections.contains(n) ? 2 : 1
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
            let i = indexPath.row
            cell = RadarTableViewCell(title: titles[i], nutrients: datas[i], color: colors[i])
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
                    if n < 3 {
                        let all = [vitamin, amino, aliphatic]
                        cell = FoldTableViewCell(name: [all[n][indexPath.row - 1].0, all[n][indexPath.row - 1].1])
                    } else {
                        cell = FoldTableViewCell(with: .none, name: "暂无数据")
                    }
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
            return 340
        default:
            return 60
        }
    }
}

extension AnalysisViewController {
    func setUpUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension AnalysisViewController {
    func analyseDiet(uid: String, day: String, success: @escaping () -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.analyseDiet, parameters: ["uid": uid, "day": day], success: { dict in
            guard let data = dict["data"] as? [String: Any], let dietItems = data["dietItems"] as? [[String: Any]] else {
                return
            }
            for item in dietItems {
                guard let category = item["category"] as? Int, let name = item["name"] as? String, let value = item["value"] as? String, let unit = item["unit"] as? String else {
                    return
                }
                switch category / 100 {
                case 1:
                    self.vitamin.append((name, value + unit))
                    guard let radarValue = item["radarValue"] as? Double, let referValue = item["referValue"] as? Double else {
                        return
                    }
                    let nut = Nutrient(name: name, unit: unit, value: value, radarValue: radarValue, referValue: referValue)
                    switch category {
                    case 100:
                        self.datas[0].append(nut)
                    case 101:
                        self.datas[2].append(nut)
                    case 102:
                        self.datas[1].append(nut)
                    default:
                        break
                    }
                case 2:
                    self.amino.append((name, value + unit))
                case 3:
                    self.aliphatic.append((name, value + unit))
                default:
                    break
                }
            }
            success()
        }, failure: { _ in
            
        })
    }
}
