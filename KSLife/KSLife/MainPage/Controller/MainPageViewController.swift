//
//  MainPageViewController.swift
//  KSLife
//
//  Created by uareagay on 2019/4/26.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import MJRefresh
import Alamofire
import SwiftyJSON
import SDWebImage
// 康食主页
class MainPageViewController: UIViewController {
    
    fileprivate var tableView: UITableView!
    fileprivate var collectionView: UICollectionView!
    var msgTimer : Timer?
    var articles = HomeArticles()
    private var recomandDishs: [SimpleDish] = []
    
    fileprivate let modules: [(name: String, img: UIImage?)] = [("能量摄入", UIImage(named: "nengliangsheru")),
                                                                ("能量燃烧", UIImage(named: "nengliangranshao")),
                                                                ("睡眠", UIImage(named: "shuimian")),
                                                                ("心率", UIImage(named: "xinlv")),
                                                                ("血压", UIImage(named: "xueya")),
                                                                ("心理紧张", UIImage(named: "xinlijinzhang")),
                                                                ("饮水量", UIImage(named: "yinshuiliang")),
                                                                ("蓝牙", UIImage(named: "blune"))]
    
    fileprivate let userView = Bundle.main.loadNibNamed("UserView", owner: nil, options: nil)?.first as! UserView
    
    fileprivate let locationModules = ["北京", "天津", "河北", "山西", "内蒙古", "辽宁", "吉林", "黑龙江", "上海", "江苏", "浙江", "安徽", "福建", "江西", "山东", "河南", "湖北", "湖南", "广东", "广西", "海南", "重庆", "四川", "贵州", "云南", "西藏", "陕西", "甘肃", "青海", "宁夏", "新疆", "台湾", "香港", "澳门"]
    
    private lazy var cycleView: RecommandCycleView = {
        let view = RecommandCycleView(frame: CGRect(x: 0, y: 0, width: screenW, height: 160))
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private lazy var recomandVC: RecomandDishViewController = {
        let vc = RecomandDishViewController()
        vc.hidesBottomBarWhenPushed = true
        return vc
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //        setController()
        self.setController()
        self.setArticles()
        getRecomRecipes(uid: UserInfo.shared.user.uid, success: { list in
            self.recomandDishs = list
            var urls = [String]()
            var names = [String]()
            for dish in list {
                urls.append(dish.icon)
                names.append(dish.name)
            }
            self.cycleView.imgUrls = urls
            self.cycleView.names = names
            self.tableView.reloadData()
            self.recomandVC.dishs = list
        })
        addMsgTimer()
    }
    // 初始化信息
    func setController() {
        self.tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        tableView.register(UINib(nibName: "RecommendTableViewCell", bundle: nil), forCellReuseIdentifier: "RecommendTableViewCell")
        
        self.view.addSubview(tableView)
        
        // 横向布局
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: self.view.bounds.width/4, height: 80)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 10)
        
        self.collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: 170), collectionViewLayout: layout)
        //collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = .white
        collectionView.register(ModuleCollectionViewCell.self, forCellWithReuseIdentifier: "ModuleCollectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        self.userView.messageBtn.addTarget(self, action: #selector(clickMessage), for: .touchUpInside)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(jumpPersonalPageVC(_:)))
        userView.imgView.isUserInteractionEnabled = true
        userView.imgView.addGestureRecognizer(tapGesture)
        
        // 设置头像
        userView.imgView.sd_setImage(with: URL(string: "\(UserInfo.shared.user.photo)"))
        userView.locationBtn.addTarget(self, action: #selector(presentPickerView(_:)), for: .touchUpInside)
        userView.locationImgBtn.addTarget(self, action: #selector(presentPickerView(_:)), for: .touchUpInside)
    }
    // 主编推荐请求
    func setArticles() {
        let loginUrl = "http://kangshilife.com/EGuider/home//getArticles?uid=\(UserInfo.shared.user.uid)"
        Alamofire.request(loginUrl, method: .post).responseJSON { response in
            switch response.result.isSuccess {
            case true:
                //把得到的JSON数据转为数组
                if let value = response.result.value {
                    let json = JSON(value)
                    
                    
                    var counts = json["data"].count
                    for i in 0..<counts {
                        var newData = HomeArticlesData()
                        newData.id = json["data"][i]["id"].int!
                        newData.imageUrl = json["data"][i]["imageUrl"].string!
                        newData.title = json["data"][i]["title"].string!
                        newData.catalogue = json["data"][i]["catalogue"].string!
                        newData.switchUrl = json["data"][i]["switchUrl"].string!
                        newData.createTime = json["data"][i]["createTime"].string!
                        newData.favor = json["data"][i]["favor"].int!
                        newData.comment = json["data"][i]["comment"].int!
                        
                        self.articles.data.append(newData)
                    }
                    ArticlesInfoCell.articles = self.articles
                    self.tableView.reloadData()
                }
            case false:
                print(response.result.error)
            }
        }
    }
}

extension MainPageViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 2:
            return 1
        case 3:
            return articles.data.count == 0 ? 1 : articles.data.count
        default:
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        return (Bundle.main.loadNibNamed("RecommendTableViewCell", owner: self, options: nil)?.first!) as! UITableViewCell.Type
        var cell = UITableViewCell()
        cell.selectionStyle = .none
        switch indexPath.section {
        case 2:
            //            let view = CycleView(frame: .zero)
            let label = UILabel()
            label.text = "根据您一周的饮食记录，推荐食材及菜肴"
            label.textAlignment = .center
            label.font = .systemFont(ofSize: 11)
            label.textColor = .lightGray
            cell.contentView.addSubview(label)
            label.snp.makeConstraints { make in
                make.width.top.equalToSuperview()
                make.height.equalTo(25)
            }
            cell.contentView.addSubview(cycleView)
            cycleView.snp.makeConstraints { make in
                make.width.bottom.equalToSuperview()
                make.top.equalTo(label.snp.bottom)
            }
        case 3:
            if articles.data.count == 0 {
                cell = FoldTableViewCell(with: .none, name: "暂无安排")
            } else {
                ArticlesInfoCell.index = indexPath.row
                cell = tableView.dequeueReusableCell(withIdentifier: "RecommendTableViewCell") as! RecommendTableViewCell
            }
            cell.selectionStyle = .none
        default:
            break
        }
        return cell
    }
}

extension MainPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 {
            return 200
        } else {
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 3 {
            let vc = ArticleViewController()
            vc.article = articles.data[indexPath.row]
            vc.hidesBottomBarWhenPushed = true
            self.navigationController?.pushViewController(vc, animated: true)
        } else if indexPath.section == 2 {
            self.navigationController?.pushViewController(recomandVC, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 170
        } else if section == 1 {
            return 80
        } else {
            return 40
        }
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 3 {
            return 80
        } else {
            return 15
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
    
    @objc func clickMessage() {
        let messageVC = MyNewsPageViewController()
        messageVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(messageVC, animated: true)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard section > 1 else {
            if section == 0 {
                return self.collectionView
            }
            return self.userView
        }
        let blankView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 40))
        blankView.backgroundColor = .white
        
        let imgView = UIImageView(frame: CGRect(x: self.view.frame.size.width / 2 - 65 / 2, y: 13, width: 65, height: 14))
        if section == 2 {
            imgView.image = UIImage(named: "zxsp")
        } else {
            imgView.image = UIImage(named: "zbtj")
        }
        blankView.addSubview(imgView)
        
        let leftLineView = UIView(frame: CGRect(x: imgView.frame.origin.x - 80, y: 18.5, width: 70, height: 3))
        leftLineView.backgroundColor = .black
        let rightLineView = UIView(frame: CGRect(x: imgView.frame.origin.x + 65 + 10, y: 18.5, width: 70, height: 3))
        rightLineView.backgroundColor = .black
        blankView.addSubview(leftLineView)
        blankView.addSubview(rightLineView)
        
        //        let bottomLineView = UIView(frame: CGRect(x: 0, y: 39.5, width: self.view.frame.width, height: 0.5))
        //        bottomLineView.backgroundColor = .lightGray
        //        blankView.addSubview(bottomLineView)
        
        return blankView
    }
    
}

extension MainPageViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.modules.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModuleCollectionViewCell", for: indexPath) as? ModuleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let data = self.modules[indexPath.item]
        cell.titleLabel.text = data.name
        cell.imageView.image = data.img
        return cell
        
    }
    
}

extension MainPageViewController: UICollectionViewDelegate {
    
}

extension MainPageViewController {
    
    // 进入个人资料
    @objc func jumpPersonalPageVC(_ sender: UITapGestureRecognizer) {
        let personalPageVC = PersonalPageViewController()
        personalPageVC.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(personalPageVC, animated: true)
    }
    
    // 展示 UIPickerView
    @objc func presentPickerView(_ sender: UIButton) {
        if let rootView = UIApplication.shared.keyWindow {
            
            // Container View
            let emptyView = UIView(frame: rootView.bounds)
            emptyView.backgroundColor = .clear
            let cancelGesture = UITapGestureRecognizer(target: self, action: #selector(cancelPickerView(_:)))
            emptyView.isUserInteractionEnabled = true
            emptyView.addGestureRecognizer(cancelGesture)
            
            // UIPickerView
            let pickerView = UIPickerView(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 250))
            pickerView.backgroundColor = .lightGray
            pickerView.delegate = self
            pickerView.dataSource = self
            emptyView.addSubview(pickerView)
            
            
            
            // UIToolBar
            let toolBar = UIToolbar(frame: CGRect(x: 0, y: UIScreen.main.bounds.size.height, width: UIScreen.main.bounds.size.width, height: 44))
            let cancelItem = UIBarButtonItem(title: "  取消", style: .done, target: self, action: #selector(toolBarCancelAction(_:)))
            let doneItem = UIBarButtonItem(title: "确定  ", style: .done, target: self, action: #selector(toolBarDoneAction(_:)))
            let flexItem = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
            toolBar.items = [cancelItem, flexItem, doneItem]
            emptyView.addSubview(toolBar)
            
            UIView.animate(withDuration: 0.25, animations: {
                pickerView.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 250, width: UIScreen.main.bounds.size.width, height: 250)
                toolBar.frame = CGRect(x: 0, y: UIScreen.main.bounds.size.height - 250 - 44, width: UIScreen.main.bounds.size.width, height: 44)
            })
            
            rootView.addSubview(emptyView)
        }
    }
    
    // 取消 UIPickerView
    @objc func cancelPickerView(_ sender: UITapGestureRecognizer) {
        UIApplication.shared.keyWindow?.subviews.last?.removeFromSuperview()
    }
    
    @objc func toolBarCancelAction(_ button: UIBarButtonItem) {
        UIApplication.shared.keyWindow?.subviews.last?.removeFromSuperview()
    }
    
    @objc func toolBarDoneAction(_ button: UIBarButtonItem) {
        guard let emptyView = UIApplication.shared.keyWindow?.subviews.last else {
            return
        }
        guard let pickerView = emptyView.subviews.first as? UIPickerView else {
            return
        }
        
        let index = pickerView.selectedRow(inComponent: 0)
        
        self.userView.locationBtn.setTitle(self.locationModules[index], for: .normal)
        
        UIApplication.shared.keyWindow?.subviews.last?.removeFromSuperview()
    }
    
}

extension MainPageViewController: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.locationModules[row]
    }
    
    //    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    //
    //    }
    
}

extension MainPageViewController: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.locationModules.count
    }
    
}

extension MainPageViewController {
    
    private func addMsgTimer(){
        msgTimer = Timer(timeInterval: 10.0, target: self, selector: #selector(haveMsg), userInfo: nil, repeats: true)
        RunLoop.main.add(msgTimer!, forMode: RunLoop.Mode.common)
    }
    private func removeMsgTimer(){
        msgTimer?.invalidate()
        msgTimer = nil
    }
    
    @objc func haveMsg() {
        userView.msgTag.isHidden = getHomeInfo(uid: UserInfo.shared.user.uid) ? false : true
    }
    
    func getRecomRecipes(uid: String, success: @escaping ([SimpleDish]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: HomeAPIs.getRecomRecipes, parameters: ["uid": uid], success: { dict in
            guard let data = dict["data"] as? [String: Any] else {
                return
            }
            var dishs: [SimpleDish] = []
            for item in data.values {
                do {
                    let json = try JSONSerialization.data(withJSONObject: item, options: [])
                    let recomand = try JSONDecoder().decode(SimpleDish.self, from: json)
                    dishs.append(recomand)
                } catch {
                    print("sad")
                }
            }
            success(dishs)
        }, failure: { _ in
            
        })
        
        SolaSessionManager.solaSession(type: .post, url: HomeAPIs.getHomeInfo, parameters: ["uid": uid], success: { dict in
            guard let data = dict["data"] as? [String: Any], let reason = data["recomReason"] as? String else {
                return
            }
            self.recomandVC.recomReason = reason
        }, failure: { _ in
        })
    }
    
    func getHomeInfo(uid: String) -> Bool {
        var flag = false
        SolaSessionManager.solaSession(type: .post, url: HomeAPIs.getHomeInfo, parameters: ["uid": uid], success: { dict in
            guard let data = dict["data"] as? [String: Any], let messageFlag = data["messageFlag"] as? Bool else {
                return
            }
            flag = messageFlag
        }, failure: { _ in
        })
        return flag
    }
}
