//
//  LectureDetailViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/25.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class LectureDetailViewController: UIViewController {

    var lecture: LectureDetail? {
        didSet {
            contents = ["\(lecture?.price ?? 0)鲜花", lecture?.title ?? "", lecture?.label ?? ""]
            rightBtn.isSelected = lecture?.status == 2 ? true : false
            print(lecture?.url)
            CourseInfo.newContent = self.stringFix(oldString: lecture?.contentImage ?? "")
            CourseInfo.title = lecture?.title ?? ""
            CourseInfo.url = lecture?.url ?? ""
            CourseInfo.duration = lecture?.duration ?? 0
            tablewView.reloadData()
        }
    }
    
    private let titles = ["课程费用", "课程简介", "适合人群"]
    private var contents = ["", "", ""]
    private let itemH: CGFloat = 200
    
    let rightBtn = NavButton(frame: CGRect(x: 0, y: 5, width: 100, height: 30), backgroundColor: mainColor, titleColor: UIColor.white, title: "收藏课程")
    
    private lazy var tablewView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.sectionFooterHeight = 5
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = self.button
        tableView.showsVerticalScrollIndicator = false
        return tableView
        }()
    
    private lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: screenW, height: 50))
        button.setTitle("开始学习", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = mainColor
        return button
    }()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tablewView)
        button.addTarget(self, action: #selector(startToLearn), for: .touchUpInside)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    // MARK: - 处理Url字符串
    func stringFix(oldString: String) -> [String] {
        let substringArray: [Substring] = oldString.split(separator: ",")
        let stringArrray: [String] = substringArray.compactMap{"\($0)"}
        var newStringArray: [String] = []
        if stringArrray.count == 1 {
            let startIndex = stringArrray[0].index(stringArrray[0].startIndex, offsetBy: 2)
            let endIndex = stringArrray[0].index(stringArrray[0].endIndex, offsetBy: -2)
            let newString = String(stringArrray[0][startIndex..<endIndex])
            newStringArray.append(newString)
            return newStringArray
        }
        var i = 0
        for item in stringArrray {
            if i == 0 {
                let startIndex = item.index(item.startIndex, offsetBy: 2)
                let endIndex = item.index(item.endIndex, offsetBy: -1)
                let newString = String(item[startIndex..<endIndex])
                newStringArray.append(newString)
            }else if i == stringArrray.count-1 {
                let startIndex = item.index(item.startIndex, offsetBy: 1)
                let endIndex = item.index(item.endIndex, offsetBy: 0)
                let newString = String(item[startIndex..<endIndex])
                newStringArray.append(newString)
            } else {
                let startIndex = item.index(item.startIndex, offsetBy: 1)
                let endIndex = item.index(item.endIndex, offsetBy: -1)
                let newString = String(item[startIndex..<endIndex])
                newStringArray.append(newString)
            }
            i += 1
        }
        return newStringArray
    }
}

extension LectureDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        switch indexPath.section {
        case 0:
            cell = LectureMsgTableViewCell(lecture: lecture)
        case 1:
            cell = LectureSimpleTableViewCell(title: titles[indexPath.row], content: contents[indexPath.row])
        case 2:
            cell.backgroundColor = .clear
            cell.contentView.addSubview(button)
            button.snp.makeConstraints { (make) -> Void in
                make.edges.equalToSuperview()
            }
        default:
            cell = UITableViewCell()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 120
        case 1:
            return 80
        default:
            return 50
        }
    }
}

extension LectureDetailViewController {
    @objc func storeLecture(sender: UIButton) {
        let ops = sender.isSelected ? 2 : 1
        collectLecture(lid: lecture!.lid, ops: ops, success: {
            sender.isSelected = !sender.isSelected
        })
    }
    
    @objc func startToLearn() {
        CourseInfo.index = -1
        let playVC = CoursePlayerController()
        playVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(playVC, animated: true)
        
    }
    
}

extension LectureDetailViewController {
    func setUpNav(_ animated: Bool){
        self.title = "课程详情"
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
        
        rightBtn.setTitle("取消收藏", for: .selected)
        rightBtn.cardRadius = 5
        rightBtn.addTarget(self, action: #selector(storeLecture), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
}

extension LectureDetailViewController {
    func collectLecture(lid: Int, ops: Int, success: @escaping () -> Void) {
        SolaSessionManager.solaSession(type: .post, url: DoctorAPIs.collectLecture, parameters: ["lid": "\(lid)", "ops": "\(ops)"], success: { dict in
            guard let status = dict["status"] as? Int else {
                return
            }
            if status == 200 {
                success()
            } else {
                if let msg = dict["msg"] as? String {
                    self.tipWithLabel(msg: "康食：" + msg)
                }
            }
            
        }, failure: { _ in
            
        })
    }
}
