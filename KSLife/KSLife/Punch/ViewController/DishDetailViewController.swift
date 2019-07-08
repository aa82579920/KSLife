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
        actionSheet.block = { weight in
            FoodManager.shared.submitDiet(uid: UserInfo.shared.user.uid, kgId: self.dish!.kgID, amount: weight, unit: "克", success: {
                self.tipWithLabel(msg: "添加成功")
            }, failure: { error in
                self.tipWithLabel(msg: error)
            })
            PunchViewController.needFresh = true
        }
    }
    
    var isShowBtn: Bool = true
    
    var dish: SimpleDish? {
        didSet {
            if let dish = dish {
                self.title = dish.name
                imageView.sd_setImage(with: URL(string: dish.icon), placeholderImage: UIImage(named: "noImg"))
                getRecipeInfo(kgId: dish.kgID, type: dish.type, success: {
                    self.tableView.reloadData()
                })
            }
        }
    }
    
    var element = "" {
        didSet {
            tableView.reloadData()
        }
    }
    
    private var vitamin: [(String, String)] = []
    private var amino: [(String, String)] = []
    private var aliphatic: [(String, String)] = []
    
    private var shouldLoadSections: [Int] = []
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
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        return image
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
        let n = section - 2
        let all = [vitamin, amino, aliphatic]
        switch section {
        case 0, 1:
            return 1
        case 2, 3, 4:
            return shouldLoadSections.contains(n) ? all[n].count + 1 : 1
        default:
            return shouldLoadSections.contains(n) ? 2 : 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        
        switch indexPath.section {
        case 0:
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
            label.text = element
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 13)
            label.textColor = .lightGray
            label.sizeToFit()
            label.numberOfLines = 0
            label.snp.makeConstraints { make in
                make.top.left.equalTo(cell.contentView).offset(15)
                make.centerX.equalTo(cell.contentView)
                make.bottom.right.equalTo(cell.contentView).offset(-15)
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
                    if n < 3 {
                        let all = [vitamin, amino, aliphatic]
                        cell = FoldTableViewCell(name: [all[n][indexPath.row - 1].0, all[n][indexPath.row - 1].1])
                    } else {
                        cell = FoldTableViewCell(with: .none, name: "暂无数据")
                    }
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
        if isShowBtn {
            view.addSubview(button)
        }
    }
    
    func setUpNav() {
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.title = dish?.name
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func remakeConstraints() {
        tableView.snp.makeConstraints { make in
            make.width.equalTo(screenW)
            make.top.equalTo(view)
            if isShowBtn {
                make.bottom.equalTo(button.snp.top)
            } else {
                make.bottom.equalTo(view)
            }
            
        }
        if isShowBtn {
            button.snp.makeConstraints { make in
                make.width.equalTo(screenW)
                make.height.equalTo(50)
                make.bottom.equalTo(view)
            }
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

extension DishDetailViewController {
    func getRecipeInfo(kgId: String, type: Int, success: @escaping () -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.getRecipeInfo, parameters: ["kgId": kgId, "type": "\(type)"], success: { dict in
            guard let data = dict["data"] as? [[String: Any]] else {
                return
            }
            for item in data {
                guard let type = item["type"] as? Int, let name = item["name"] as? String, let value = item["value"] as? Double, let unit = item["unit"] as? String else {
                    return
                }
                switch type / 100 {
                case 1:
                    self.vitamin.append((name, "\(value)" + unit))
                case 2:
                    self.amino.append((name, "\(value)" + unit))
                case 3:
                    self.aliphatic.append((name, "\(value)" + unit))
                default:
                    break
                }
            }
            success()
        }, failure: { _ in
            
        })
    }
}
