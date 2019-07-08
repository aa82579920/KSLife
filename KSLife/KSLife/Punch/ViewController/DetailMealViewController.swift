//
//  DetailMealViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/8.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class DetailMealViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(button)
        setUpNav()
        remakeConstraints()
    }
    
    var meal: SetMeal? {
        didSet {
            tableView.reloadData()
        }
    }
    
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
        return tableView
    }()
    
    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = mainColor
        btn.setTitleColor(.white, for: .normal)
        btn.setTitle("选择添加", for: .normal)
        btn.addTarget(self, action: #selector(submitSet), for: .touchUpInside)
        return btn
    }()
    
}

extension DetailMealViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        switch indexPath.section {
        case 0:
            let imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            imageView.sd_setImage(with: URL(string: meal?.icon ?? ""), placeholderImage: UIImage(named: "noImg"))
            imageView.sizeToFit()
            imageView.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(screenW)
                make.edges.equalToSuperview()
            }
        case 1:
            let label = UILabel()
            cell.contentView.addSubview(label)
            label.text = meal?.setName
            label.textColor = .lightGray
            label.font = .systemFont(ofSize: 15)
            label.textAlignment = .center
            label.sizeToFit()
            label.numberOfLines = 0
            label.snp.makeConstraints { make in
                make.top.left.equalTo(cell.contentView).offset(15)
                make.bottom.right.equalTo(cell.contentView).offset(-15)
            }
        case 2:
            let label = UILabel()
            cell.contentView.addSubview(label)
            label.text = meal?.intro
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 15)
            label.textColor = .black
            label.sizeToFit()
            label.numberOfLines = 0
            label.snp.makeConstraints { make in
                make.top.left.equalTo(cell.contentView).offset(15)
                make.bottom.right.equalTo(cell.contentView).offset(-15)
            }
        default:
            break
        }
        return cell
    }
}

extension DetailMealViewController {
    func setUpNav() {
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.title = meal?.setName
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
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

extension DetailMealViewController {
    
    @objc func submitSet() {
        submitUserSetMeal(id: meal!.id, success: {
            PunchViewController.needFresh = true
        })
    }
    
    func submitUserSetMeal(id: Int, uid: String = UserInfo.shared.user.uid, success: @escaping () -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.submitUserSetMeal, parameters: ["id": "\(id)", "uid": uid], success: { dict in
            guard let status = dict["status"] as? Int else {
                return
            }
            if status == 200 {
                self.tipWithLabel(msg: "添加成功")
                success()
            } else {
                if let msg = dict["msg"] as? String {
                    self.tipWithLabel(msg: "康食：" + msg)
                }
            }
        }, failure: { error in
            self.tipWithLabel(msg: error.localizedDescription)
        })
    }
}
