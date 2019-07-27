//
//  FoodRecordViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/31.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import SwiftDate
import Alamofire
import WebKit

class FoodRecordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        setUpNav()
        getDietRecord(uid: UserInfo.shared.user.uid, success: { dishs in
            self.dishs = dishs
        })
        calendarVc.showAnimation = ActionSheetShowAnimation()
        calendarVc.dismissAnimation = ActionSheetDismissAnimation()
        dateSelectView.block = { date in
            let dayStr = date.toISO([.withFullDate])
            self.dateLabel.text = dayStr
            self.getDietRecord(uid: UserInfo.shared.user.uid, day: dayStr, success: { dishs in
                self.dishs = dishs
            })
        }
        calendarVc.block = { period in
            let starDate = period.0
            let endDate = period.1
            self.applyReport(uid: UserInfo.shared.user.uid, begin: starDate, end: endDate, success: { path in
                print(path)
                if let path = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: path) {
                    UIApplication.shared.open(url)
                }
            })
        }
    }
    
    private var dishs: [Dish] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    private var shouldLoadSections: [Int] = []
    private var vitamin: [(String, String)] = []
    private var amino: [(String, String)] = []
    private var aliphatic: [(String, String)] = []
    
    private let dateSelectViewH: CGFloat = 90
    private let btnNames = ["三天记录", "长期记录"]
    private let sectionFoldName = ["基础营养素", "氨基酸", "脂肪酸", "其他"]
    private let sectionNormalName = ["饮食内容", "饮食评价"]
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.estimatedRowHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight  = 10
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.separatorInset = UIEdgeInsets.zero
        return tableView
    }()
    
    private lazy var dateSelectView: WeeklySelectDateView = {
        let dateView = WeeklySelectDateView(startDate: Date())
        return dateView
    }()
    
    private lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = Date().toFormat("yyyy-MM-dd")
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    
     let calendarVc = CalendarViewController()
}

extension FoodRecordViewController {
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func showCalendar(sender: UIButton) {
        calendarVc.show()
    }
    
    @objc func getReport(sender: UIButton) {
        var begin = ""
        var end = ""
        if sender.tag == 1{
            begin = Date().dateByAdding(-3, .day).date.toISO([.withFullDate])
            end = Date().toISO([.withFullDate])
        } else {
            print("还没写呢")
        }
        applyReport(uid: UserInfo.shared.user.uid, begin: begin, end: end, success: { path in
            print(path)
            if let path = path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed), let url = URL(string: path) {
                UIApplication.shared.open(url)
            }
//            let url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
//            let webView = WKWebView(frame: self.view.bounds)
//            webView.backgroundColor = .white
//            self.view.addSubview(webView)
//            let data = try! Data(contentsOf: url)
//            webView.loadFileURL(URL(fileURLWithPath: path), allowingReadAccessTo: URL(fileURLWithPath: path))
//            let urlStr = URL.init(fileURLWithPath:path)
//            let data = try! Data(contentsOf: urlStr)
//            webView.load(data, mimeType: "application/pdf", characterEncodingName: "utf-8", baseURL: NSURL() as URL)
        })
    }
}

extension FoodRecordViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 9
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let all = [vitamin, amino, aliphatic]
        let n = section - 4
        switch section {
        case 0, 1, 2:
            return 1
        case 3:
            return dishs.count == 0 ? 2 : dishs.count + 1
        case 7:
            return shouldLoadSections.contains(n) ? 2 : 1
        case 8:
            return 2
        default:
            return shouldLoadSections.contains(n) ? all[n].count + 1 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let all = [vitamin, amino, aliphatic]
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        
        switch indexPath.section {
        case 0:
            cell.contentView.addSubview(dateSelectView)
            dateSelectView.snp.makeConstraints { make in
                make.left.right.top.equalTo(cell.contentView)
                make.height.equalTo(dateSelectViewH)
            }
            cell.contentView.addSubview(dateLabel)
            dateLabel.snp.makeConstraints { make in
                make.left.right.bottom.equalTo(cell.contentView)
                make.top.equalTo(dateSelectView.snp.bottom)
            }
        case 1, 2:
            let btn = UIButton()
            cell.contentView.addSubview(btn)
            btn.setTitle(btnNames[indexPath.section - 1], for: .normal)
            btn.setTitleColor(.white, for: .normal)
            btn.titleLabel?.font = .systemFont(ofSize: 18)
            btn.backgroundColor = mainColor
            btn.tag = indexPath.section
            if indexPath.section == 1 {
                btn.addTarget(self, action: #selector(getReport), for: .touchUpInside)
            } else {
                btn.addTarget(self, action: #selector(showCalendar), for: .touchUpInside)
            }
            btn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        case 3:
            if indexPath.row == 0 {
                 cell = FoldTableViewCell(with: .section, name: "饮食内容")
            } else {
                cell = dishs.count == 0 ? FoldTableViewCell(with: .none, name: "暂无数据") : DayDishTableViewCell(with: .weight, dish: dishs[indexPath.row - 1])
            }
        case 8:
            if indexPath.row == 0 {
                cell = FoldTableViewCell(with: .section, name: "饮食评价")
            } else {
                cell = FoldTableViewCell(with: .none, name: "")
            }
        case 7:
            if indexPath.row == 0 {
                cell = FoldTableViewCell(with: .section, name: "其他")
            } else {
                if shouldLoadSections.contains(indexPath.section - 4) {
                    cell = FoldTableViewCell(with: .none, name: "暂无数据")
                }
            }
        default:
            let n = indexPath.section - 4
            
            if indexPath.row == 0 {
                let cell = FoldTableViewCell(with: .section, name: sectionFoldName[n])
                if shouldLoadSections.contains(n) {
                    cell.canUnfold = false
                } else {
                    cell.canUnfold = true
                }
                cell.selectionStyle = .none
                return cell
            } else {
                if shouldLoadSections.contains(n) {
                    cell = dishs.count == 0 ? FoldTableViewCell(with: .none, name: "暂无数据") : FoldTableViewCell(name: [all[n][indexPath.row - 1].0, all[n][indexPath.row - 1].1])
                }
            }
        }
        
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0, 1, 2, 3, 8:
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            let n = indexPath.section - 4
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
            return 120
        case 3:
            if (indexPath.row == 0 || dishs.count != 0) {
                return 60
            } else {
                return 160
            }
        case 7, 8:
            if (indexPath.row == 0) {
                return 60
            } else {
                return 160
            }
        default:
            return 60
        }
    }
}

extension FoodRecordViewController {
    func setUpUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func setUpNav() {
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        
        self.title = "饮食档案"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension FoodRecordViewController {
    func getDietRecord(uid: String, day: String = Date().toISO([.withFullDate]), success: @escaping ([Dish]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.getDietRecord, parameters: ["uid": uid, "day": "\(day)"], success: { dict in
            guard let data = dict["data"] as? [String: Any], let records = data["records"] as? [Any], let dietItems = data["dietItems"] as? [[String: Any]] else {
                return
            }
            for item in dietItems {
                guard let category = item["category"] as? Int, let name = item["name"] as? String, let value = item["value"] as? String, let unit = item["unit"] as? String else {
                    return
                }
                switch category / 100 {
                case 1:
                    self.vitamin.append((name, "\(value)" + unit))
                case 2:
                    self.amino.append((name, "\(value)" + unit))
                case 3:
                    self.aliphatic.append((name, "\(value)" + unit))
                default:
                    break
                }
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: records, options: [])
                let records = try JSONDecoder().decode([Dish].self, from: json)
             success(records)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
    
    func applyReport(uid: String, begin: String, end: String, type: String = "pdf", success: @escaping (String) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: CheckinAPIs.applyReport, parameters: ["uid": uid, "begin": begin, "end": end, "type": type], success: { dict in
            guard let status = dict["status"] as? Int else {
                return
            }
            if status != 200 {
                if let msg = dict["msg"] as? String {
                    self.tipWithLabel(msg: "康食：" + msg)
                }
                return
            }
            guard let data = dict["data"] as? String else {
                self.tipWithLabel(msg: "康食：empty string")
                return
            }
            success(data)
//            print(data)
//            var z = URL(string:data)
//            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
//                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
//                let fileURL = documentsURL.appendingPathComponent("kangshi/\(data)")
//                z = fileURL
//                //两个参数表示如果有同名文件则会覆盖，如果路径中文件夹不存在则会自动创建
//                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
//            }
//
//
//
//            //开始下载
//            Alamofire.download(data.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, to: destination)
//                .responseData { response in
//                    DispatchQueue.main.async {
//
//                        if let path = response.destinationURL?.path{
//                            success(path)
//                        }
//                    }
//            }
            //            let destination: DownloadRequest.DownloadFileDestination = { _, _ in
            //                let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            //                let fileName = data.components(separatedBy: "/").last ?? ""
            //                let fileURL = documentsURL.appendingPathComponent("kangshi/" + fileName)
            //                return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
            //            }
            //            Alamofire.download(data.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!, to: destination)
            //                .response { response in
            //                    if let path = response.destinationURL?.path {
            //                        success(path)
            //                    }
            //            }
            
        }, failure: { _ in
            self.tipWithLabel(msg: "康食：网络错误，请稍后再试")
        })
    }
}
