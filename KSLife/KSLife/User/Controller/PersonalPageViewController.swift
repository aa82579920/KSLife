//
//  PersonalPageViewController.swift
//  KSLife
//
//  Created by uareagay on 2019/4/23.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
// 我的页面
class PersonalPageViewController: UIViewController {
    
    var tableView: UITableView!

    fileprivate var imgView: UIImageView = {
        let imgView = UIImageView(frame: CGRect(x: 0, y: 0, width: 60, height: 60 ))
        imgView.backgroundColor = .white
        imgView.image = UIImage(named: "upic")
        return imgView
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "个人资料"

        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)

        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(tableView)

    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.navigationController?.setNavigationBarHidden(false, animated: true)
//
//    }
//
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//    }



}

extension PersonalPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 0) {
            return 1
        } else {
            return 3
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DEFAULT")
        guard indexPath.section == 1 else {
            cell.textLabel?.text = "头像"
            cell.accessoryView = self.imgView
            return cell
        }

        let moreImgView = UIImageView()
        moreImgView.backgroundColor = .white
        moreImgView.image = UIImage(named: "more_arrow")
        cell.addSubview(moreImgView)
        moreImgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(7)
        }
        let label = UILabel()
        //label.text = "182****7568"
        label.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        label.textAlignment = .right
        label.textColor = .gray
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.right.equalTo(moreImgView.snp.left).offset(-20)
            make.width.equalTo(230)
        }
        if indexPath.row == 0 {
            cell.textLabel?.text = "昵称"
            label.text = "不可弃也"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "个性签名"
            label.text = "寂寞的程序员"
        } else {
            cell.textLabel?.text = "手机号码"
            label.text = "182****7568"
        }
        return cell
    }
}

extension PersonalPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 80
        } else {
            return 44
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print(indexPath)
        if indexPath.section ==  0 {
            
        }else {
            if indexPath.row == 0 {
                let setNameVC = SetNameController()
                self.navigationController?.pushViewController(setNameVC, animated: true)
            }else if indexPath.row == 1 {
                let setIntroVC = SetIntroController()
                self.navigationController?.pushViewController(setIntroVC, animated: true)
            }
        }
    }

}

