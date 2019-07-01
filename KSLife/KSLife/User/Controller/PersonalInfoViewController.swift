//
//  PersonalInfoViewController.swift
//  KSLife
//
//  Created by uareagay on 2019/4/22.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import SnapKit
import Alamofire
import SwiftyJSON
class PersonalInfoViewController: UIViewController {
    var tableView: UITableView!

    fileprivate let nameLabel: UILabel = {
        let label = UILabel()
        label.text = UserInfo.shared.user.nickname
        label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.semibold)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

    fileprivate let digitLabel: UILabel = {
        let label = UILabel()
        label.text = "康食号：" + UserInfo.shared.user.uid
        label.font = UIFont.systemFont(ofSize: 14, weight: UIFont.Weight.regular)
        label.textAlignment = .left
        label.textColor = .black
        return label
    }()

    fileprivate var imgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .white
//        imgView.layer.masksToBounds = true
//        imgView.layer.cornerRadius = 120/2
        //imgView.image = UIImage.resizedImage(image: UIImage(named: "upic")!, scaledToWidth: 30.0)
        imgView.sd_setImage(with: URL(string: UserInfo.shared.user.photo), placeholderImage: UIImage(named: "upic"))
        return imgView
    }()

    fileprivate var moreImgView: UIImageView = {
        let imgView = UIImageView()
        imgView.backgroundColor = .white
        imgView.image = UIImage(named: "more_arrow")
        return imgView
    }()

    fileprivate var outBtn: UIButton = {
        let btn = UIButton()
        btn.setTitle("退出登录", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.textAlignment = .center
        btn.backgroundColor = .red
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)

        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(tableView)


        self.outBtn.addTarget(self, action: #selector(logout), for: .touchUpInside)

    }

//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//
//        self.navigationController?.setNavigationBarHidden(true, animated: true)
//
//    }
}

extension PersonalInfoViewController {
    @objc func logout() {

    }
}

extension PersonalInfoViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1) {
            return 6
        } else {
            return 1
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 2 {
            let cell = UITableViewCell()
            cell.addSubview(self.outBtn)
            outBtn.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            return cell
        } else if indexPath.section == 0 {
            let cell = UITableViewCell()
            cell.addSubview(self.nameLabel)
            cell.addSubview(self.digitLabel)
            cell.addSubview(self.imgView)
            imgView.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(25)
                make.left.equalToSuperview().inset(30)
                make.width.equalTo(70)
            }
            nameLabel.snp.makeConstraints { make in
                make.left.equalTo(imgView.snp.right).offset(15)
                make.right.equalToSuperview().inset(10)
                make.top.equalToSuperview().inset(25)
                make.height.equalTo(40)
            }
            digitLabel.snp.makeConstraints { make in
                make.left.equalTo(imgView.snp.right).offset(15)
                make.right.equalToSuperview().inset(10)
                make.top.equalTo(nameLabel.snp.bottom)
                make.height.equalTo(30)
            }
            return cell
        }
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DEFAULT")
        let moreImgView = UIImageView()
        moreImgView.backgroundColor = .white
        moreImgView.image = UIImage(named: "more_arrow")
        cell.addSubview(moreImgView)
        moreImgView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(15)
            make.right.equalToSuperview().inset(20)
            make.width.equalTo(7)
        }
        switch indexPath.row {
        case 0:
            cell.imageView?.image = UIImage.resizedImage(image: UIImage(named: "dangan")!, scaledToWidth: 16.0)
            cell.textLabel?.text = "档案"
        case 1:
            cell.imageView?.image = UIImage.resizedImage(image: UIImage(named: "youlu")!, scaledToWidth: 16.0)
            cell.textLabel?.text = "友录"
        case 2:
            cell.imageView?.image = UIImage.resizedImage(image: UIImage(named: "xiaoxi")!, scaledToWidth: 16.0)
            cell.textLabel?.text = "消息"
        case 3:
            cell.imageView?.image = UIImage.resizedImage(image: UIImage(named: "kecheng")!, scaledToWidth: 16.0)
            cell.textLabel?.text = "课程"
        case 4:
            cell.imageView?.image = UIImage.resizedImage(image: UIImage(named: "blune")!, scaledToWidth: 16.0)
            cell.textLabel?.text = "蓝牙"
            let label = UILabel()
            label.text = "已关闭"
            label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
            label.textAlignment = .right
            label.textColor = .black
            cell.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(15)
                make.right.equalTo(moreImgView.snp.left).offset(-30)
                make.width.equalTo(60)
            }
        case 5:
            cell.imageView?.image = UIImage.resizedImage(image: UIImage(named: "about")!, scaledToWidth: 16.0)
            cell.textLabel?.text = "关于"
            let label = UILabel()
            label.text = "V3.0"
            label.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
            label.textAlignment = .right
            label.textColor = .black
            cell.addSubview(label)
            label.snp.makeConstraints { make in
                make.top.bottom.equalToSuperview().inset(15)
                make.right.equalTo(moreImgView.snp.left).offset(-30)
                make.width.equalTo(60)
            }
        default:
            return cell
        }
        return cell
    }
}

extension PersonalInfoViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return 120
        } else if indexPath.section == 2 {
            return 50
        } else {
            return 44
        }
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        if indexPath.section == 0 {
            let personlVC = PersonalPageViewController()
            personlVC.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(personlVC, animated: true)
        }else {
            if indexPath.row == 0 {
                let recordVC = PersonalRecordViewController()
                recordVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(recordVC, animated: true)
            }else if indexPath.row == 1 {
                let youLuVC = YouLuViewController()
                youLuVC.hidesBottomBarWhenPushed = true // 嵌套Navigatiion时隐藏tabBar
                self.navigationController?.pushViewController(youLuVC, animated: true)
            } else if indexPath.row == 2 {
                let vc = MyNewsPageViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }else if indexPath.row == 3 {
                let courseVC = CourseViewController()
                courseVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(courseVC, animated: true)
            }else if indexPath.row == 5 {
                let aboutVC = AboutViewController()
                aboutVC.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(aboutVC, animated: true)
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return section == 0 ? 0 : 25
    }

//    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return 0
//    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }

//    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        return UIView()
//    }
}

