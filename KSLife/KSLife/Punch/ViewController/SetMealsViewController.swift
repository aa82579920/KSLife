//
//  SetMealsViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/30.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class SetMealsViewController: ViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(headerView)
        headerView.addSubview(searchField)
        remakeConstraints()
        searchSetMeals(success: { list in
            self.meals = list
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    private let itemH: CGFloat = 80
    
    private var meals: [SetMeal] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private lazy var searchField: UITextField = {[weak self] in
        let field = UITextField()
        field.backgroundColor = UIColor(hex6: 0xe6e6e6)
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 16)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.delegate = self
        field.addTarget(self, action: #selector(changedTextField), for: .editingChanged)
        
        let image = NSTextAttachment()
        image.image = UIImage(named: "search")
        image.bounds = CGRect(x: 0, y: -3, width: (field.font!.lineHeight), height: (field.font!.lineHeight))
        let imageStr = NSAttributedString(attachment: image)
        let string = NSAttributedString(string: " 请输入医院，日期等关键字进行搜索", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let allStr = NSMutableAttributedString()
        allStr.append(imageStr)
        allStr.append(string)
        field.attributedPlaceholder = allStr
        
        return field
        }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: statusH, width: screenW, height: screenH - statusH - getTabbarHeight()), style: .plain)
        tableView.rowHeight = itemH
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: screenW * 0.2, bottom: 0, right: 0)
        tableView.register(DayDishTableViewCell.self, forCellReuseIdentifier: "DayDishTableViewCellID")
        return tableView
        }()
}

extension SetMealsViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        searchField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func changedTextField() {
        guard let text = searchField.text else {
            return
        }
        var list: [SetMeal] = []
        for item in meals {
            if item.setName.contains(text) {
                list.append(item)
            }
        }
        meals = list
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = SetMealTableViewCell()
        cell.meal = meals[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailMealViewController()
        vc.meal = meals[indexPath.row]
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension SetMealsViewController {
    func remakeConstraints() {
        let padding: CGFloat = 10
        
        headerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(screenW)
        }
        
        searchField.snp.makeConstraints { (make) -> Void in
            make.left.top.equalTo(headerView).offset(padding)
            make.bottom.right.equalTo(headerView).offset(-padding)
        }
    }
    
    func setUpNav(_ animated: Bool){
        self.title = "选择营养套餐"
        
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

extension SetMealsViewController {
    func searchSetMeals(keyword: String = "", page: Int = 0, success: @escaping ([SetMeal]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.searchSetMeals, parameters: ["keyword": keyword, "page": "\(page)"], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: [])
                let meals = try JSONDecoder().decode([SetMeal].self, from: json)
                success(meals)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
}
