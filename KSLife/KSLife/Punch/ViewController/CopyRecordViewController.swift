//
//  CopyRecordViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/26.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class CopyRecordViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        setUpNav()
    }
    
    var dishs: [Dish] = [] {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var addDishs: [Dish] = []
    
    private var num = 0
    
    private let copyDishTableViewCellID = "copyDishTableViewCellID"
    private let itemH: CGFloat = 90
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = itemH
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DayDishTableViewCell.self, forCellReuseIdentifier: copyDishTableViewCellID)
        return tableView
        }()
}

extension CopyRecordViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishs.count == 0 ? 1 : dishs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dishs.count == 0 ? 160 : itemH
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dishs.count == 0 ? FoldTableViewCell(with: .none, name: "亲，没找到相关数据") : DayDishTableViewCell(with: .normal, dish: dishs[indexPath.row])
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "添加"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        addDishs.append(dishs[indexPath.row])
        dishs.remove(at: indexPath.row)
        tableView.reloadData()
    }
}

extension CopyRecordViewController {
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ensure(){
        //        submitRecords(dishs: self.addDishs) {
        //            PunchViewController.needFresh = true
        //        }
        submitRecords(dishs: addDishs)
        PunchViewController.needFresh = true
        self.navigationController?.popViewController(animated: true)
    }
}

extension CopyRecordViewController {
    func setUpUI() {
        view.addSubview(tableView)
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
    }
    
    func setUpNav() {
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        let rightBtn = NavButton(frame: CGRect(x: 0, y: 5, width: 80, height: 30), backgroundColor: mainColor, titleColor: UIColor.white, title: "确定")
        rightBtn.cardRadius = 5
        rightBtn.addTarget(self, action: #selector(ensure), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        self.title = "已打卡食品"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
}
extension CopyRecordViewController {
    func submitRecords(dishs: [Dish]) {
        for dish in dishs {
            let uid = UserInfo.shared.user.uid, kgId = dish.kgID, amount = dish.amount, unit = dish.unit
            FoodManager.shared.submitDiet(uid: uid, kgId: kgId, amount: amount, unit: unit, success: {
                self.tipWithLabel(msg: "添加成功")
            }, failure: { error in
                self.tipWithLabel(msg: error)
            })
        }
    }
}
