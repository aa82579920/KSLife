//
//  DiyFoodViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/29.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class DiyFoodViewController: PhotoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpNav()
        remakeConstraints()
    }
    
    private let cellTitles = ["食物名称","食物正面照","营养成分表"]
    private let msgCellID = "msgCellID"
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.sectionHeaderHeight = 60
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: msgCellID)
        return tableView
        }()
    
    private lazy var cellField: UITextField = {[unowned self] in
        let view = UITextField()
        view.delegate = self
        view.placeholder = "如：番茄炒鸡蛋"
        view.font = UIFont.systemFont(ofSize: 13)
        return view
    }()
    
    private lazy var cellBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "photo"), for: .normal)
        btn.addTarget(self, action: #selector(tapAvatar), for: .touchUpInside)
        return btn
    }()
    
}

extension DiyFoodViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate{
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        cellField.resignFirstResponder()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 2
        default:
            return 20
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: msgCellID, for: indexPath)
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
        
        let padding = 15
        var cellViews: [UIView] = []
        for _ in 0..<2 {
            let btn = UIButton()
            btn.setImage(UIImage(named: "photo"), for: .normal)
            btn.addTarget(self, action: #selector(tapAvatar), for: .touchUpInside)
            cellViews.append(btn)
        }
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = cellTitles[indexPath.row]
            cell.contentView.addSubview(cellField)
            cellField.snp.makeConstraints { (make) -> Void in
                make.right.equalTo(cell.contentView).offset(-padding)
                make.height.equalTo(cell.contentView)
            }
        case 1:
            cell.textLabel?.text = cellTitles[indexPath.row + 1]
            cell.contentView.addSubview(cellViews[indexPath.row])
            cellViews[indexPath.row].snp.makeConstraints { (make) -> Void in
                make.right.equalTo(cell.contentView).offset(-padding)
                make.height.equalTo(cell.contentView)
                make.width.equalTo(cellViews[indexPath.row].snp.height)
            }
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: msgCellID, for: indexPath)
            cell.textLabel?.text = "水"
            cell.textLabel?.font = UIFont.systemFont(ofSize: 14)
            cell.textLabel?.sizeToFit()
            let label = UILabel()
            cell.contentView.addSubview(label)
            label.text = "毫克"
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.sizeToFit()
            if indexPath.row == 0 {
                let labelTop = UILabel()
                cell.contentView.addSubview(labelTop)
                labelTop.text = "营养成分按照100克计算"
                labelTop.textColor = mainColor
                labelTop.textAlignment = .center
                labelTop.font = UIFont.systemFont(ofSize: 13)
                labelTop.sizeToFit()
                labelTop.snp.makeConstraints { make in
                    make.top.equalToSuperview()
                    make.bottom.equalTo(label.snp.top).offset(-15)
                    make.centerX.equalTo(cell.contentView)
                }
                label.snp.makeConstraints { make in
                    make.bottom.equalTo(cell.contentView).offset(-10)
                    make.right.equalTo(cell.contentView).offset(-padding)
                }
            } else {
                label.snp.makeConstraints { make in
                    make.centerY.equalTo(cell.contentView)
                    make.right.equalTo(cell.contentView).offset(-padding)
                }
            }
        default:
            break
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0, 1:
            return 60
        default:
            return (indexPath.row == 0) ? 60 : 40
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0, 1:
            let view = UITableViewCell()
            view.backgroundColor = .white
            view.textLabel?.text = ["基本信息","选填信息"][section]
            view.textLabel?.font = UIFont.systemFont(ofSize: 17, weight: .heavy)
            return view
        default:
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0, 1:
            return 60
        default:
            return 0.001
        }
    }
}

extension DiyFoodViewController {
    func setUpUI() {
        view.addSubview(tableView)
    }
    
    func setUpNav() {
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        let rightBtn = NavButton(frame: CGRect(x: 0, y: 5, width: 80, height: 30), title: "确定")
        rightBtn.cardRadius = 5
        rightBtn.addTarget(self, action: #selector(ensure), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        self.title = "添加自定食物"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func remakeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DiyFoodViewController {
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ensure() {
        
    }
}

