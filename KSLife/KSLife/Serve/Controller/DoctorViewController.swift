//
//  DoctorViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class DoctorViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNav(animated)
    }
    
    var shouldLoadSections: [Int] = []
    
    
    private let sectionName = ["医师近期安排", "咨询", "医友圈", "调查问卷", "全部课程"]
    private let itemH: CGFloat = 100
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.estimatedRowHeight = itemH
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

extension DoctorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 3:
            return 1
        case let section where section > 1 && section < 2 + sectionName.count:
            let n = section - 2
            if shouldLoadSections.contains(n) {
                if section == 6 {
                    return 2
                } else {
                    return 5
                }
            } else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        
        switch indexPath.section {
        case 0:
            let imageView = UIImageView()
            imageView.image = UIImage(named: "scenery")
            cell.contentView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(screenH * 0.4)
                make.width.equalTo(screenW)
                make.top.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView).priority(.low)
            }
        case 1:
            cell = DetailMsgTableViewCell()
        case let section where section > 1 && section < 2 + sectionName.count:
            let n = indexPath.section - 2
            
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
                    switch indexPath.section {
                    case 2:
                         cell = FoldTableViewCell(with: .docPlan, name: "hhhhhhh")
                    case 4:
                        cell = FoldTableViewCell(with: .docCircle, name: "hhhhhhh")
                    case 5:
                        cell = FoldTableViewCell(with: .docForm, name: "hhhhhhh")
                    case 6:
                        cell = FoldTableViewCell(with: .none, name: "")
                    default:
                        break
                    }
                }
            }
        default:
            cell = UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 5 && indexPath.row != 0) {
            let vc = FormViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        switch indexPath.section {
        case 0, 1, 3:
            tableView.deselectRow(at: indexPath, animated: true)
        default:
            let n = indexPath.section - 2
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
            } else {

            }
        }
    }
}

extension DoctorViewController {
    
    func setUpUI(){
        view.addSubview(tableView)
    }
    
    func setUpNav(_ animated: Bool) {
        
            let image = UIImage(named: "ic_back")
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
 
       
       self.title = "医生详情"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
        
        let rightBtn = NavButton(frame: CGRect(x: 0, y: 5, width: 80, height: 30), backgroundColor: UIColor(hex6: 0xCB4042), titleColor: UIColor.white, title: "预约")
        rightBtn.cardRadius = 5
        rightBtn.addTarget(self, action: #selector(booking), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func booking() {
        
    }
    
}
