//
//  SearchDishViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/8.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import MJRefresh

class SearchDishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(searchField)
        view.addSubview(tableView)
        setUpNav()
        searchField.becomeFirstResponder()
        searchRecipes(success: { list in
            self.dishs = list
        })
        let footer = MJRefreshAutoNormalFooter()
        footer.setRefreshingTarget(self, refreshingAction: Selector(("getMore")))
        footer.setTitle("没有更多数据了", for: .noMoreData)
        tableView.mj_footer = footer
    }
    
    private var page: Int = 0
    
    private var dishs: [SimpleDish] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    private let searchViewH: CGFloat = 40
    private let itemH: CGFloat = 80
    
    private lazy var searchField: UITextField = {[weak self] in
        let field = UITextField(frame: CGRect(x: 15, y: statusH + navigationBarH, width: screenW - 30, height: searchViewH))
        field.backgroundColor = UIColor(hex6: 0xe6e6e6)
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 15
        field.font = UIFont.systemFont(ofSize: 16)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.delegate = self
        field.returnKeyType = .search
        
        let image = NSTextAttachment()
        image.image = UIImage(named: "search")
        image.bounds = CGRect(x: 0, y: -3, width: (field.font!.lineHeight), height: (field.font!.lineHeight))
        let imageStr = NSAttributedString(attachment: image)
        let string = NSAttributedString(string: " 请输入食品名称", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let allStr = NSMutableAttributedString()
        allStr.append(imageStr)
        allStr.append(string)
        field.attributedPlaceholder = allStr
        
        return field
        }()
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: statusH + navigationBarH + searchViewH, width: screenW, height: screenH - statusH - navigationBarH - searchViewH), style: .plain)
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

extension SearchDishViewController: UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text ?? ""
        searchRecipes(keyword: text, page: 0, success: { list in
            self.dishs = list
        })
        textField.resignFirstResponder()
        return true
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchField.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let dish = dishs[indexPath.row]
        let cell = DayDishTableViewCell(with: .simple, dish: dish)
        cell.selectionStyle = .none
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 12)
        label.backgroundColor = dish.type == 0 ? mainColor : .green
        label.text = dish.type == 0 ? "食材" : "菜肴"
        label.textAlignment = .center
        label.layer.cornerRadius = 3
        label.clipsToBounds = true
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.top.right.equalTo(cell.dishImage)
            make.width.equalTo(cell.dishImage).multipliedBy(0.8)
            make.height.equalTo(15)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DishDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.dish = dishs[indexPath.row]
        if dishs[indexPath.row].type == 0 {
             vc.element = dishs[indexPath.row].name
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension SearchDishViewController {
    func setUpNav() {
        self.title = "搜索菜品"
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension SearchDishViewController {
    
    @objc func getMore() {
        page += 1
        let text = searchField.text ?? ""
        searchRecipes(keyword: text, page: page, success: { list in
            if list.count <= 0 {
                self.tableView.mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.dishs += list
            }
        })
        self.tableView.mj_footer.endRefreshing()
    }
    
    func searchRecipes(keyword: String = "", page: Int = 0, success: @escaping ([SimpleDish]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.searchRecipes, parameters: ["page": "\(page)", "keyword": keyword], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: [])
                let list = try JSONDecoder().decode([SimpleDish].self, from: json)
                success(list)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
}
