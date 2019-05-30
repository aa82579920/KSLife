//
//  PunchViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class PunchViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        remakeConstraints()
        lastDayBtn = dayBtns[0]
        lastDayBtn.isSelected = true
        scoreView.addDishBtn.addTarget(self, action: #selector(addDish), for: .touchUpInside)
    }
    
    private let btnTitles = ["复制前天记录", "复制昨天记录", "选择营养套餐"]
    private var btns: [UIButton] = []
    
    private let dayTitles = ["前日", "昨日", "今日"]
    private var dayBtns: [UIButton] = []
    
    private lazy var lastDayBtn = UIButton()
    
    private let dayDishTableViewCellID = "dayDishTableViewCellID"
    private let itemH: CGFloat = 90
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = itemH
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DayDishTableViewCell.self, forCellReuseIdentifier: dayDishTableViewCellID)
        return tableView
    }()
    
    private lazy var tableHeaderView: UIView = {
        let view = UIView()
        return view
    }()
    
    private lazy var scoreView = ScoreView(frame: .zero)
    
    private lazy var scrollLine: UIView = {
        let line = UIView()
        line.backgroundColor = mainColor
        return line
    }()
    
    private lazy var sectionHeaderView: UIView = {
        let view = UIView()
        return view
    }()
    
}

extension PunchViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DayDishTableViewCell(with: .normal)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let change = UITableViewRowAction(style: .normal, title: "修改") {
            action, index in
            UIAlertController.showAlert(message: "点击了“更多”按钮")
        }
        change.backgroundColor = UIColor.lightGray
        let delete = UITableViewRowAction(style: .normal, title: "删除") {
            action, index in

            tableView.reloadData()
        }
        delete.backgroundColor = UIColor.red
        
        return [change, delete]
    }
}

extension PunchViewController {
    @objc func chooseDay(sender: UIButton) {
        sender.isSelected = true
        lastDayBtn.isSelected = false
        lastDayBtn = sender
        let scrollLineX = CGFloat(lastDayBtn.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
    }
    
    @objc func addDish() {
        let vc = AddDishViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func copyRecord() {
        let vc = CopyRecordViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PunchViewController {
    
    func setUpUI() {
        view.addSubview(tableView)
        tableView.addSubview(tableHeaderView)
//        tableView.addSubview(sectionHeaderView)
        
        tableHeaderView.addSubview(scoreView)
        
        for i in 0..<3 {
            let btn = NavButton(frame: CGRect.zero, title: btnTitles[i])
            btn.shadowBlur = 0
            btn.shadowOpacity = 0
            btn.backgroundColor = mainColor
            btn.setTitleColor(.white, for: .normal)
            btn.setTitle(btnTitles[i], for: .normal)
            btn.addTarget(self, action: #selector(copyRecord), for: .touchUpInside)
            btns.append(btn)
            tableHeaderView.addSubview(btn)
        }

        for i in 0..<3 {
            let dayBtn = UIButton(frame: CGRect.zero)
            dayBtn.tag = i
            dayBtn.setTitle(dayTitles[i], for: .normal)
            dayBtn.backgroundColor = .white
            dayBtn.setTitleColor(.black, for: .normal)
            dayBtn.setTitleColor(mainColor, for: .selected)
            dayBtn.addTarget(self, action: #selector(chooseDay), for: .touchUpInside)
            dayBtns.append(dayBtn)
            tableHeaderView.addSubview(dayBtn)
        }
        setupButtomMenuAndScrollLine()
    }
    
    func setupButtomMenuAndScrollLine() {
        //添加底线
        let buttomLine = UIView()
        buttomLine.backgroundColor = UIColor.gray
        let lineH: CGFloat = 0.5
        tableHeaderView.addSubview(buttomLine)
        
        //添加scrollLine
        tableHeaderView.addSubview(scrollLine)
        
        buttomLine.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(tableHeaderView)
            make.width.equalTo(view)
            make.height.equalTo(lineH)
            make.left.equalTo(view)
        }
        
        scrollLine.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(tableHeaderView)
            make.width.equalTo(view.bounds.width / 3)
            make.height.equalTo(2)
            make.left.equalTo(view)
        }
    }
    
    func remakeConstraints() {
        tableView.snp.makeConstraints { (make) -> Void in
            make.edges.equalToSuperview()
        }
        tableHeaderView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
        }
        remakeHeaderConstraints()
    }
    
    func remakeHeaderConstraints() {
        let padding: CGFloat = 10
        scoreView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(tableHeaderView)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.height * 0.25)
        }
        
        for i in 0..<3 {
            btns[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(scoreView.snp.bottom).offset(padding)
                make.width.equalTo(tableHeaderView).multipliedBy(0.3)
            }
        }
        btns[1].snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(tableHeaderView)
        }
        btns[0].snp.makeConstraints { (make) -> Void in
            make.right.equalTo(btns[1].snp.left).offset(-padding)
        }
        btns[2].snp.makeConstraints { (make) -> Void in
            make.left.equalTo(btns[1].snp.right).offset(padding)
        }
        
        for i in 0..<3 {
            dayBtns[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(btns[0].snp.bottom).offset(padding)
                make.width.equalTo(view.bounds.width / 3)
                make.bottom.equalTo(tableHeaderView)
                make.height.equalTo(view.bounds.width / 8)
            }
        }
        dayBtns[1].snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(tableHeaderView)
        }
        dayBtns[0].snp.makeConstraints { (make) -> Void in
            make.right.equalTo(dayBtns[1].snp.left)
        }
        dayBtns[2].snp.makeConstraints { (make) -> Void in
            make.left.equalTo(dayBtns[1].snp.right)
        }

    }
}

extension UIAlertController {
    //在指定视图控制器上弹出普通消息提示框
    static func showAlert(message: String, in viewController: UIViewController) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "确定", style: .cancel))
        viewController.present(alert, animated: true)
    }
    
    //在根视图控制器上弹出普通消息提示框
    static func showAlert(message: String) {
        if let vc = UIApplication.shared.keyWindow?.rootViewController {
            showAlert(message: message, in: vc)
        }
    }
}
