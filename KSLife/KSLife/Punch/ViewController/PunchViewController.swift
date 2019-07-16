//
//  PunchViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class PunchViewController: UIViewController {
    
    static var needFresh = false
    static var dietIds = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        remakeConstraints()
        lastDayBtn = dayBtns[2]
        lastDayBtn.isSelected = true
        scoreView.addDishBtn.addTarget(self, action: #selector(addDish), for: .touchUpInside)
        getHomeInfo(uid: UserInfo.shared.user.uid, success: { dishs in
            self.dishs = dishs
            self.todayDishs = dishs
        })
        DoctorAPIs.getRemainFlower(success: { num in
            self.scoreView.flower = num
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if PunchViewController.needFresh {
            getHomeInfo(uid: UserInfo.shared.user.uid, success: { dishs in
                self.dishs = dishs
                self.todayDishs = dishs
            })
            PunchViewController.needFresh = false
        }
    }
    
    private var todayDishs: [Dish] = []
    
    private var dishs: [Dish] = [] {
        didSet {
            self.tableView.reloadData()
        }
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
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DayDishTableViewCell.self, forCellReuseIdentifier: dayDishTableViewCellID)
        return tableView
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
        return dishs.count == 0 ? 1 : dishs.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dishs.count == 0 ? 160 : itemH
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dishs.count == 0 ? FoldTableViewCell(with: .none, name: "数据空") : DayDishTableViewCell(with: .normal, dish: dishs[indexPath.row])
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    private func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCell.EditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let change = UITableViewRowAction(style: .normal, title: "修改") {
            action, index in
            let alert = UIAlertController.init(title: "修改数量", message: "请输入摄入的克数？\n\n\n", preferredStyle: .alert)
            let field = UITextField()
            field.borderStyle = .roundedRect
            alert.view.addSubview(field)
            field.snp.makeConstraints { make in
                //                make.bottom.equalTo(alert.view).offset(-padding)
                make.bottom.equalTo(alert.view).offset(-50)
                make.height.equalTo(35)
                make.width.equalTo(alert.view).multipliedBy(0.9)
                make.centerX.equalTo(alert.view)
            }
            
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                print("点击了确定")
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        change.backgroundColor = UIColor.lightGray
        let delete = UITableViewRowAction(style: .normal, title: "删除") {
            action, index in
            let alert = UIAlertController.init(title: "删除提示", message: "确定要删除此项？", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)
            let okAction = UIAlertAction(title: "确定", style: .default, handler: {
                action in
                FoodManager.shared.udpateDiet(id: PunchViewController.dietIds[indexPath.row])
                self.dishs.remove(at: indexPath.row)
                PunchViewController.dietIds.remove(at: indexPath.row)
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.reloadData()
            })
            alert.addAction(cancelAction)
            alert.addAction(okAction)
            self.present(alert, animated: true, completion: nil)
        }
        delete.backgroundColor = UIColor.red
        
        return [change, delete]
    }
}

extension PunchViewController {
    @objc func chooseDay(sender: UIButton) {
        lastDayBtn.isSelected = false
        sender.isSelected = true
        lastDayBtn = sender
        let scrollLineX = CGFloat(lastDayBtn.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        switch sender {
        case self.dayBtns[0]:
            getLastRecord(uid: UserInfo.shared.user.uid, day: 2, success: { dishs in
                self.dishs = dishs
            })
        case self.dayBtns[1]:
            getLastRecord(uid: UserInfo.shared.user.uid, day: 1, success: { dishs in
                self.dishs = dishs
            })
        case self.dayBtns[2]:
            dishs = todayDishs
        default:
            break
        }
    }
    
    @objc func addDish() {
        let vc = AddDishViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func copyRecord(sender: UIButton) {
        let vc = CopyRecordViewController()
        switch sender {
        case self.btns[0]:
            getLastRecord(uid: UserInfo.shared.user.uid, day: 2, success: { dishs in
                vc.dishs = dishs
            })
            
        case self.btns[1]:
            getLastRecord(uid: UserInfo.shared.user.uid, day: 1, success: { dishs in
                vc.dishs = dishs
            })
        default:
            let vc = SetMealsViewController()
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
            return
        }
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension PunchViewController {
    
    func setUpUI() {
        view.addSubview(tableView)
        
        view.addSubview(scoreView)
        
        for i in 0..<3 {
            let btn = NavButton(frame: CGRect.zero, title: btnTitles[i])
            btn.shadowBlur = 0
            btn.shadowOpacity = 0
            btn.backgroundColor = mainColor
            btn.setTitleColor(.white, for: .normal)
            btn.setTitle(btnTitles[i], for: .normal)
            btn.addTarget(self, action: #selector(copyRecord), for: .touchUpInside)
            btns.append(btn)
            view.addSubview(btn)
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
            view.addSubview(dayBtn)
        }
        setupButtomMenuAndScrollLine()
    }
    
    func setupButtomMenuAndScrollLine() {
        //添加底线
        let buttomLine = UIView()
        buttomLine.backgroundColor = UIColor.gray
        let lineH: CGFloat = 0.5
        view.addSubview(buttomLine)
        
        //添加scrollLine
        view.addSubview(scrollLine)
        
        buttomLine.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(dayBtns[0])
            make.width.equalTo(view)
            make.height.equalTo(lineH)
            make.left.equalTo(view)
        }
        
        scrollLine.snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(buttomLine)
            make.width.equalTo(view.bounds.width / 3)
            make.height.equalTo(2)
            make.right.equalTo(view)
        }
    }
    
    func remakeConstraints() {
        tableView.snp.makeConstraints { (make) -> Void in
            make.left.right.bottom.equalTo(view)
            make.top.equalTo(scrollLine.snp.bottom)
        }
        let padding: CGFloat = 10
        scoreView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view)
            make.width.equalTo(view.bounds.width)
            make.height.equalTo(view.bounds.height * 0.25)
        }
        
        for i in 0..<3 {
            btns[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(scoreView.snp.bottom).offset(padding*3)
                make.width.equalTo(view).multipliedBy(0.3)
            }
        }
        btns[1].snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
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
                make.height.equalTo(view.bounds.width / 8)
            }
        }
        dayBtns[1].snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(view)
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

extension PunchViewController {
    func getHomeInfo(uid: String, success: @escaping ([Dish]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.getHomeInfo, parameters: ["uid": uid], success: { dict in
            guard let data = dict["data"] as? [String: Any], let score = data["score"] as? String, let dishs = data["records"] as? [Any] else {
                return
            }
            self.scoreView.score = score
            do {
                let json = try JSONSerialization.data(withJSONObject: dishs, options: [])
                let dishs = try JSONDecoder().decode([Dish].self, from: json)
                success(dishs)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
    
    func getLastRecord(uid: String, day: Int = 1, success: @escaping ([Dish]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.getLastRecord, parameters: ["uid": uid, "day": "\(day)"], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: [])
                let dishs = try JSONDecoder().decode([Dish].self, from: json)
                success(dishs)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
}
