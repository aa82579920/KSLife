//
//  DishDetailViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/29.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class DishDetailViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        setUpNav()
        remakeConstraints()
        actionSheet.showAnimation = ActionSheetShowAnimation()
        actionSheet.dismissAnimation = ActionSheetDismissAnimation()
    }
    
     var shouldLoadSections: [Int] = []
     private let sectionName = ["基础营养素", "氨基酸", "脂肪酸", "其他"]
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.estimatedRowHeight = 60
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight  = 10
        tableView.sectionHeaderHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(FoldTableViewCell.self, forCellReuseIdentifier: "foldCell")
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = mainColor
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("选择添加", for: .normal)
        btn.addTarget(self, action: #selector(popUpView), for: .touchUpInside)
        return btn
    }()
    
    let actionSheet = ActionSheetViewController()
}

extension DishDetailViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1:
            return 1
        default:
            let n = section - 2
            if shouldLoadSections.contains(n) {
                return 10
            } else {
                return 1
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
            let imageView = UIImageView()
            imageView.image = UIImage(named: "scenery")
            cell.contentView.addSubview(imageView)
            imageView.sizeToFit()
            imageView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(screenW)
//                make.height.equalTo(screenH * 0.4)
                make.edges.equalTo(cell.contentView)
            }
        case 1:
            let label = UILabel()
            cell.contentView.addSubview(label)
            label.text = "红烧肉"
            label.font = UIFont.systemFont(ofSize: 15)
            label.sizeToFit()
            label.snp.makeConstraints { make in
                make.top.equalTo(cell.contentView).offset(15)
                make.centerX.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView).offset(-15)
            }
        default:
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
                    cell = FoldTableViewCell(with: .item, name: "hhhhhhh")
                }
            }
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0, 1:
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
            }
            
        }
    }
}

extension DishDetailViewController {
    func setUpUI() {
        view.addSubview(tableView)
        view.addSubview(button)
    }
    
    func setUpNav() {
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.title = "红烧肉"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
     func remakeConstraints() {
        tableView.snp.makeConstraints { make in
            make.width.equalTo(screenW)
            make.top.equalTo(view)
            make.bottom.equalTo(button.snp.top)
        }
        
        button.snp.makeConstraints { make in
            make.width.equalTo(screenW)
            make.height.equalTo(50)
            make.bottom.equalTo(view)
        }
    }
}

extension DishDetailViewController {
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
     @objc func popUpView() {
        actionSheet.show()
    }
}
