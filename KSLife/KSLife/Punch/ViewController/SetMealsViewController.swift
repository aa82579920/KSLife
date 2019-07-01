//
//  SetMealsViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/30.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
//
//class SetMealsViewController: ViewController {
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        super.viewDidLoad()
//        view.backgroundColor = .white
//        setUpUI()
//        setUpNav()
//    }
//    
//    private let itemH: CGFloat = 100
//    
//    private lazy var searchField: UITextField = {[weak self] in
//        let field = UITextField()
//        field.backgroundColor = UIColor(hex6: 0xe6e6e6)
//        field.borderStyle = .roundedRect
//        field.font = UIFont.systemFont(ofSize: 16)
//        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
//        field.leftViewMode = .always
//        field.delegate = self
//        
//        let image = NSTextAttachment()
//        image.image = UIImage(named: "search")
//        image.bounds = CGRect(x: 0, y: -3, width: (field.font!.lineHeight), height: (field.font!.lineHeight))
//        let imageStr = NSAttributedString(attachment: image)
//        let string = NSAttributedString(string: " 请输入医院，日期等关键字进行搜索", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
//        let allStr = NSMutableAttributedString()
//        allStr.append(imageStr)
//        allStr.append(string)
//        field.attributedPlaceholder = allStr
//        
//        return field
//        }()
//    
//    private lazy var searchBtn: UIButton = {
//        let btn = NavButton(frame: CGRect.zero, title: "搜索")
//        btn.addTarget(self, action: #selector(search), for: .touchUpInside)
//        return btn
//    }()
//    
//    private lazy var headerView: UIView = {
//        let view = UIView()
//        view.backgroundColor = .clear
//        return view
//    }()
//    
//    private lazy var tableView: UITableView = {[unowned self] in
//        let tableView = UITableView(frame: CGRect(x: 0, y: statusH, width: screenW, height: screenH - statusH - getTabbarHeight()), style: .plain)
//        tableView.estimatedRowHeight = itemH
//        tableView.delegate = self
//        tableView.dataSource = self
//        tableView.separatorStyle = .singleLine
//        tableView.backgroundColor = .white
//        tableView.showsVerticalScrollIndicator = false
//        tableView.separatorInset = UIEdgeInsets(top: 0, left: screenW * 0.2, bottom: 0, right: 0)
//        tableView.register(DayDishTableViewCell.self, forCellReuseIdentifier: "DayDishTableViewCellID")
//        return tableView
//        }()
//}
//
//extension SetMealsViewController: UITableViewDelegate, UITableViewDataSource {
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 0
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell()
//        cell.selectionStyle = .none
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        return headerView
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////        let vc = DoctorViewController()
////        vc.hidesBottomBarWhenPushed = true
////        self.navigationController?.pushViewController(vc, animated: true)
//    }
//}
