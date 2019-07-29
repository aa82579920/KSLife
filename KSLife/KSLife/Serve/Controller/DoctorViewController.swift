//
//  DoctorViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class DoctorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
        sendFlowerView.block = { num in
            self.sureSend()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNav(animated)
    }
    
    var doctor: Doctor? {
        didSet {
            if let doctor = doctor {
                getDoctorMsg(uid: doctor.uid, success: { msg in
                    self.doctorMsg = msg
                    self.activitys = msg.activity ?? []
                })
                getCircle(uid: doctor.uid , success: { circle in
                    self.circleList = circle
                })
                getSurveyList(uid: doctor.uid, success: { survey in
                    self.surveyList = survey
                })
                
                getLectureList(uid: doctor.uid) { courses in
                    self.lectureList = courses
                }
                
                self.tableView.reloadData()
            }
        }
    }
    
    var doctorMsg: DoctorMsg?
    private var activitys: [Activity] = []
    private var surveyList: [Survey] = []
    private var circleList: [Circle] = []
    private var lectureList: [Lecture] = []
    
    private var shouldLoadSections: [Int] = []
    
    
    private let sectionName = ["医师近期安排", "咨询", "医友圈", "调查问卷", "全部课程"]
    private let itemH: CGFloat = 100
    
    private let circleTableViewCellID = "circleTableViewCellID"
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.estimatedRowHeight = itemH
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionFooterHeight  = 10
        tableView.sectionHeaderHeight = 0
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(CircleTableViewCell.self, forCellReuseIdentifier: circleTableViewCellID)
        tableView.register(DetailMsgTableViewCell.self, forCellReuseIdentifier: "detailMsgTableViewCell")
        return tableView
        }()
    
    private var sendFlowerView: SendFlowerView = {
        let view = SendFlowerView()
        view.whiteViewEndFrame = CGRect(x: 20, y: screenH * 0.3, width: screenW - 40, height: screenH * 0.2)
        return view
    }()
}

extension DoctorViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0, 1, 3:
            return 1
        case let section where section > 1 && section < 2 + sectionName.count:
            let n = section - 2
            if shouldLoadSections.contains(n) {
                switch section {
                case 2:
                    return activitys.count == 0 ? 2 : activitys.count + 1
                case 4:
                    return circleList.count == 0 ? 2 : circleList.count + 1
                case 5:
                    return surveyList.count == 0 ? 2 : surveyList.count + 1
                case 6:
                    return lectureList.count == 0 ? 2 : lectureList.count + 1
                default:
                    return 2
                }
            } else {
                return 1
            }
        default:
            return 0
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 7
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        
        switch indexPath.section {
        case 0:
            let imageView = UIImageView()
            imageView.sd_setImage(with: URL(string: doctor?.poster ?? ""), placeholderImage: UIImage(named: "noImg"))
            cell.contentView.addSubview(imageView)
            imageView.snp.makeConstraints { (make) -> Void in
                make.height.equalTo(screenH * 0.4)
                make.width.equalTo(screenW)
                make.top.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView).priority(.low)
            }
        case 1:
            let cell = DetailMsgTableViewCell()
            cell.button.addTarget(self, action: #selector(sendFlo), for: .touchUpInside)
            cell.doctor = self.doctor
            cell.selectionStyle = .none
            return cell
        case let section where section > 1 && section < 2 + sectionName.count:
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
                    switch indexPath.section {
                    case 2:
                        cell = (activitys.count == 0) ? FoldTableViewCell(with: .none, name: "暂无安排") : ActivityTableViewCell(activity: activitys[indexPath.row - 1])
                    case 4:
                        cell = (circleList.count == 0) ? FoldTableViewCell(with: .none, name: "暂无动态") : CircleTableViewCell(name: doctor?.name ?? "", circle: circleList[indexPath.row - 1])
                    case 5:
                        cell = (surveyList.count == 0) ? FoldTableViewCell(with: .none, name: "暂无问卷") : FormTableViewCell(name: surveyList[indexPath.row - 1].title)
                    case 6:
                        cell = (lectureList.count == 0) ? FoldTableViewCell(with: .none, name: "亲，没找到相关数据") : LectureTableViewCell(lecture: lectureList[indexPath.row - 1])
                    default:
                        break
                    }
                }
            }
        default:
            cell = UITableViewCell()
        }
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if (indexPath.section == 5 && indexPath.row != 0) {
            let vc = FormViewController()
            getQuestions(sid: "\(surveyList[indexPath.row - 1].sid)", success: { qs in
                vc.questions = qs
                vc.sid = self.surveyList[indexPath.row - 1].sid
            })
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if (indexPath.section == 6 && indexPath.row != 0) {
            let vc = LectureDetailViewController()
            getLectureDetail(lid: lectureList[indexPath.row - 1].lid, success: { lecture in
                vc.lecture = lecture
            })
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        switch indexPath.section {
        case 0, 1:
            tableView.deselectRow(at: indexPath, animated: true)
        case 3:
            if doctorMsg?.follow == 2 {
                let vc = MessageViewController()
                vc.hidesBottomBarWhenPushed = true
                vc.recUid = doctor?.uid
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                self.tipWithLabel(msg: "请预约医生并等待审核通过")
            }
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
                //                tableView.scrollToRow(at: IndexPath(row: 0, section: indexPath.section), at: .top, animated: true)
            } else {
                
            }
        }
    }
}

extension DoctorViewController {
    
    func setUpUI(){
        view.addSubview(tableView)
    }
    
    func setUpNav(_ animated: Bool) {
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        
        self.title = "医生详情"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
        
        var title = "预约"
        var color = UIColor(hex6: 0xCB4042)
        switch doctor?.follow {
        case 0:
            title = "预约"
            color = UIColor(hex6: 0xCB4042)
        case 1:
            title = "待签约"
            color = UIColor(hex6: 0xf0ad4e)
        case 2:
            title = "已签约"
            color = mainColor
        default:
            break
        }
        let rightBtn = NavButton(frame: CGRect(x: 0, y: 5, width: 80, height: 30), backgroundColor: color, titleColor: UIColor.white, title: title)
        rightBtn.addTarget(self, action: #selector(followDoc), for: .touchUpInside)
        rightBtn.cardRadius = 5
        rightBtn.setTitle( "待签约"
            , for: .selected)
        rightBtn.backgroundColor = rightBtn.isSelected ? UIColor(hex6: 0xf0ad4e) : color
        rightBtn.addTarget(self, action: #selector(followDoc), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func sendFlo() {
        DoctorAPIs.getRemainFlower(success: { num in
            if num == 0 {
                self.tipWithLabel(msg: "余额不足，当前鲜花数为0，请充值后再送花！", frame: CGRect(x: screenW * 0.1, y: screenH * 0.75, width: screenW * 0.8, height: 30))
            } else {
                self.sendFlowerView.restNum = num
                self.sendFlowerView.addAnimate()
            }
        })
    }
    
    func sureSend() {
        sendLike(doctorId: doctor!.uid, likeNum: sendFlowerView.num)
        self.sendFlowerView.tapBtnAndcancelBtnClick()
    }
    
    @objc func followDoc(_ sender: UIButton) {
        if doctor?.follow == 1 {
            self.tipWithLabel(msg: "康食：审核中，审核后再操作")
        } else if (doctor?.follow == 0) {
            follow(uid: doctor!.uid, ops: 1, success: {
                self.tipWithLabel(msg: "预约成功")
                sender.isSelected = true
            })
        }
    }
}

extension DoctorViewController {
    func getDoctorMsg(uid: String, success: @escaping (DoctorMsg) -> Void) {
        SolaSessionManager.solaSession(url: DoctorAPIs.getDoctorDetail, parameters: ["uid": uid], success: { dict in
            guard let data = dict["data"] as? [String: Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: [])
                let doctorMsg = try JSONDecoder().decode(DoctorMsg.self, from: json)
                success(doctorMsg)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
    
    func getCircle(uid: String, success: @escaping ([Circle]) -> Void) {
        SolaSessionManager.solaSession(url: DoctorAPIs.getCircle, parameters: ["uid": uid], success: { dict in
            guard let data = dict["data"] as? [String: Any], let circle = data["circle"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: circle, options: [])
                let circleList = try JSONDecoder().decode([Circle].self, from: json)
                success(circleList)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
    
    func getSurveyList(uid: String, success: @escaping ([Survey]) -> Void) {
        SolaSessionManager.solaSession(url: SurveyAPIs.getSurveyList, parameters: ["uid": uid], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: [])
                let surveyList = try JSONDecoder().decode([Survey].self, from: json)
                success(surveyList)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
    
    func getQuestions(sid: String, success: @escaping ([Question]) -> Void) {
        SolaSessionManager.solaSession(url: SurveyAPIs.getQuestion, parameters: ["sid": sid], success: { dict in
            guard let data = dict["data"] as? [String: Any], let item = data["question"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: item, options: [])
                let questions = try JSONDecoder().decode([Question].self, from: json)
                success(questions)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
    
    func getLectureList(uid: String, page: Int = 0, success: @escaping ([Lecture]) -> Void) {
        SolaSessionManager.solaSession(url: DoctorAPIs.getLectureList, parameters: ["uid": uid, "page": "\(page)"], success: { dict in
            guard let data = dict["data"] as? [String: Any], let item = data["items"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: item, options: [])
                let courses = try JSONDecoder().decode([Lecture].self, from: json)
                success(courses)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
    
    func getLectureDetail(lid: Int, success: @escaping (LectureDetail) -> Void) {
        SolaSessionManager.solaSession(url: DoctorAPIs.getLectureDetail, parameters: ["lid": "\(lid)"], success: { dict in
            guard let data = dict["data"] as? Any else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: [])
                let courses = try JSONDecoder().decode(LectureDetail.self, from: json)
                success(courses)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
    
    func sendLike(doctorId: String, likeNum: Int) {
        SolaSessionManager.solaSession(type: .post, url: DoctorAPIs.sendLike, parameters: ["uid": doctorId, "like_num": "\(likeNum)"], success: { dict in
            guard let data = dict["data"] as? [String: Any], let likeNum = data["like_num"] as? Int else {
                return
            }
            self.tipWithLabel(msg: "送花成功")
        }, failure: { _ in
            
        })
    }
    
    func follow(uid: String, ops: Int,success: @escaping () -> Void) {
        SolaSessionManager.solaSession(type: .post, url: DoctorAPIs.follow, parameters: ["uid": uid, "ops": "\(ops)"], success: { dict in
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


