//
//  PersonalRecordViewController.swift
//  KSLife
//
//  Created by uareagay on 2019/4/23.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class PersonalRecordViewController: UIViewController {

    var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "档案"


        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)

        tableView.delegate = self
        tableView.dataSource = self

        self.view.addSubview(tableView)



    }
}


extension PersonalRecordViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 3 {
            return 3
        } else if section == 0 {
            return 0
        } else {
            return 2
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "DEFAULT")
        guard indexPath.section == 3 else {
            cell.textLabel?.textAlignment = .center
            if indexPath.section == 1 {
                if indexPath.row == 0 {
                    cell.textLabel?.text = "身体状况"
                    cell.textLabel?.textColor = .gray
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 19.0, weight: UIFont.Weight.semibold)
                } else {
                    cell.textLabel?.text = "您的体型正常，处于哺乳期期间"
                }
            } else {
                if indexPath.row == 0 {
                    cell.textLabel?.text = "需求"
                    cell.textLabel?.textColor = .gray
                    cell.textLabel?.font = UIFont.systemFont(ofSize: 19.0, weight: UIFont.Weight.semibold)
                } else {
                    cell.textLabel?.text = "哺乳期"
                }
            }
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
        if indexPath.row == 0 {
            cell.textLabel?.text = "体质检测"
        } else if indexPath.row == 1 {
            cell.textLabel?.text = "饮食档案"
        } else {
            cell.textLabel?.text = "检测档案"
        }
        return cell
    }
}

extension PersonalRecordViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 0 {
            return 55
        }
        if indexPath.section == 2 && indexPath.row == 0 {
            return 55
        }
        return 44
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        print(indexPath)
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 250
        } else {
            return 10
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section == 0 else {
            return UIView()
        }

        let blankView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.bounds.size.width, height: 250))
        blankView.backgroundColor = .white

        let imgView = UIImageView(frame: CGRect(x: (self.view.bounds.size.width - 80) / 2, y: 25, width: 80, height: 80))
        imgView.backgroundColor = .white
        imgView.layer.masksToBounds = true
        imgView.layer.borderWidth = 3.0
        imgView.layer.borderColor = UIColor.lightGray.cgColor
        imgView.layer.cornerRadius = 80/2
        imgView.image = UIImage(named: "upic")

        let nickLabel = UILabel()
        nickLabel.text = "不可弃也"
        nickLabel.font = UIFont.systemFont(ofSize: 17, weight: UIFont.Weight.regular)
        nickLabel.textAlignment = .center
        nickLabel.textColor = .black

        let infoLabel = UILabel()
        infoLabel.text = "男 20岁 天津"
        infoLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.regular)
        infoLabel.textAlignment = .center
        infoLabel.textColor = .gray

        blankView.addSubview(imgView)
        blankView.addSubview(nickLabel)
        blankView.addSubview(infoLabel)
        nickLabel.snp.makeConstraints { make in
            make.top.equalTo(imgView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(30)
        }
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(nickLabel.snp.bottom)
            make.left.right.equalToSuperview()
            make.height.equalTo(20)
        }

        let oneLineView = DottedLineView()
        oneLineView.backgroundColor = .white

        let twoLineView = DottedLineView()
        twoLineView.backgroundColor = .white

        let lineWidth = self.view.frame.size.width / 3
        blankView.addSubview(oneLineView)
        blankView.addSubview(twoLineView)
        oneLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(lineWidth)
            make.width.equalTo(2)
            make.height.equalTo(28)
            make.top.equalTo(infoLabel.snp.bottom).offset(40)
        }
        twoLineView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(lineWidth * 2)
            make.width.equalTo(2)
            make.height.equalTo(28)
            make.top.equalTo(infoLabel.snp.bottom).offset(40)
        }

        let weightLabel = UILabel()
        weightLabel.text = "体重"
        weightLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        weightLabel.textAlignment = .center
        weightLabel.textColor = .gray

        let heightLabel = UILabel()
        heightLabel.text = "身高"
        heightLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        heightLabel.textAlignment = .center
        heightLabel.textColor = .gray

        let BMILabel = UILabel()
        BMILabel.text = "BMI"
        BMILabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        BMILabel.textAlignment = .center
        BMILabel.textColor = .gray

        blankView.addSubview(weightLabel)
        blankView.addSubview(heightLabel)
        blankView.addSubview(BMILabel)
        weightLabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(infoLabel.snp.bottom).offset(45)
            make.right.equalTo(oneLineView.snp.left).offset(-30)
        }
        heightLabel.snp.makeConstraints { make in
            make.height.equalTo(30)
            make.top.equalTo(infoLabel.snp.bottom).offset(45)
            make.left.equalTo(oneLineView.snp.right)
            make.right.equalTo(twoLineView.snp.left)
        }
        BMILabel.snp.makeConstraints { make in
            make.width.equalTo(50)
            make.height.equalTo(30)
            make.top.equalTo(infoLabel.snp.bottom).offset(45)
            make.left.equalTo(twoLineView.snp.right).offset(30)
        }

        let weightDescLabel = UILabel()
        weightDescLabel.text = "60"
        weightDescLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        weightDescLabel.textAlignment = .center
        weightDescLabel.textColor = .gray

        let heightDescLabel = UILabel()
        heightDescLabel.text = "170"
        heightDescLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        heightDescLabel.textAlignment = .center
        heightDescLabel.textColor = .gray

        let BMIDescLabel = UILabel()
        BMIDescLabel.text = "20.8"
        BMIDescLabel.font = UIFont.systemFont(ofSize: 15, weight: UIFont.Weight.medium)
        BMIDescLabel.textAlignment = .center
        BMIDescLabel.textColor = .gray

        blankView.addSubview(weightDescLabel)
        blankView.addSubview(heightDescLabel)
        blankView.addSubview(BMIDescLabel)
        weightDescLabel.snp.makeConstraints { make in
            make.centerX.equalTo(weightLabel.snp.centerX)
            make.bottom.equalTo(weightLabel.snp.top)
            make.width.equalTo(weightLabel.snp.width)
            make.height.equalTo(25)
        }
        heightDescLabel.snp.makeConstraints { make in
            make.centerX.equalTo(heightLabel.snp.centerX)
            make.bottom.equalTo(heightLabel.snp.top)
            make.width.equalTo(heightLabel.snp.width)
            make.height.equalTo(25)
        }
        BMIDescLabel.snp.makeConstraints { make in
            make.centerX.equalTo(BMILabel.snp.centerX)
            make.bottom.equalTo(BMILabel.snp.top)
            make.width.equalTo(BMILabel.snp.width)
            make.height.equalTo(25)
        }
        

        return blankView
    }

}

