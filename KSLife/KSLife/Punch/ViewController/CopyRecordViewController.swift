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
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DayDishTableViewCell(with: .normal)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
}

extension CopyRecordViewController {
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ensure(){
        
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
