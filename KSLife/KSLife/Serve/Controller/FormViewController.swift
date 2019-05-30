//
//  FormViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/11.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class FormViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tablewView)
        tablewView.addSubview(button)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    private let itemH: CGFloat = 200
    private let formTableViewCellID = "formTableViewCellID"
    
    private lazy var tablewView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .plain)
        tableView.estimatedRowHeight = itemH
        tableView.tableFooterView = self.button
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: formTableViewCellID)
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: screenW, height: 50))
        button.setTitle("提交", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor
        button.layer.cornerRadius = 25
        return button
    }()

}

extension FormViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: formTableViewCellID, for: indexPath)
        let formView = FormView(frame: CGRect(x: 0, y: 0, width: screenW, height: 250), questionStr: "1、您的年龄阶段", optionList: ["23岁及以下", "24-27", "28-30", "30及以上"])
        cell.contentView.addSubview(formView)
        formView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(cell.contentView)
        }
        cell.selectionStyle = .none
        return cell
    }
}

extension FormViewController {
    func setUpNav(_ animated: Bool){
        self.title = "调查问卷"
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
}
