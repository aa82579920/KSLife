//
//  AddDishViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/23.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class AddDishViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        contentH = screenH - statusH - navigationBarH - titleViewH - searchViewH
        contentFrame = CGRect(x: 0, y: statusH + navigationBarH + titleViewH + searchViewH, width: screenW, height: contentH)

        view.addSubview(searchField)
        view.addSubview(pageTitleView)
        setUpNav()
        
        getRecipeNames(success: {
            self.subViewTwo = DishListView(frame: self.contentFrame, groups: self.dishGroups, fontSize: 14, type: 1)
            self.subViewThree = DishListView(frame: self.contentFrame, groups: self.materialGroups, fontSize: 14, type: 0)
            self.setUpUI()
        })
        
        getHistory(uid: UserInfo.shared.user.uid, page: 0, success: { list in
            self.simpleDishs = list
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        searchField.resignFirstResponder()
    }
    
    private var dishGroups: [SimpleDish] = []
    private var materialGroups: [SimpleDish] = []
    private var simpleDishs: [SimpleDish] = [] {
        didSet {
            subViewOne.reloadData()
        }
    }
    
    private let titleViewH: CGFloat = screenH * 0.06
    private let searchViewH: CGFloat = 40
    private var contentH: CGFloat = 0
    private var contentFrame: CGRect = .zero
    
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
    
    private lazy var pageTitleView: TitleCollectionView = {
        [weak self] in
        let titles = ["最爱","菜肴","食材", "自定套餐","自定菜肴","自定食品"]
        let view = TitleCollectionView(frame: CGRect(x: 0, y: statusH + navigationBarH + searchViewH, width: screenW, height: titleViewH), titles: titles)
        view.delegate = self
        return view
    }()
    
    private var pageContentView: PageContentView?
//        = { [weak self] in
//        let views = [subViewOne,subViewTwo,subViewThree,subViewFour,subViewFive,subViewSix]
//        let view = PageContentView(frame: contentFrame, views: views)
//        view.delegate = self
//        return view
//        }()
    
    private let faviDishCellID = "faviDishCellID"
    private lazy var subViewOne: UITableView = {[unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.rowHeight = 70
        tableView.delegate = self
        tableView.dataSource = self
        tableView.sectionHeaderHeight = 0
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.register(DayDishTableViewCell.self, forCellReuseIdentifier: faviDishCellID)
        return tableView
        }()
    
    private var subViewTwo: DishListView?
    //        = {[unowned self] in
    //        let view = DishListView(frame: contentFrame, groups: [], fontSize: 14)
    //        view.backgroundColor = .white
    //        return view
    //        }()
    //    private var subViewTwo: DishListView!
    
    private var subViewThree: DishListView?
    //        = {[unowned self] in
    //        let view = DishListView(frame: contentFrame, groups: [], fontSize: 14)
    //        view.backgroundColor = .white
    //        return view
    //        }()
    //     private var subViewThree: DishListView!
    
    private lazy var subViewFour: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var subViewFive: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var subViewSix: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var addBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add_diy"), for: .normal)
        btn.addTarget(self, action: #selector(addDiy), for: .touchUpInside)
        return btn
    }()
    
    private lazy var addBtnTwo: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add_diy"), for: .normal)
        btn.addTarget(self, action: #selector(addDiy), for: .touchUpInside)
        return btn
    }()
    
    private lazy var addBtnThree: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "add_diy"), for: .normal)
        btn.addTarget(self, action: #selector(addDiyFood), for: .touchUpInside)
        return btn
    }()
}

extension AddDishViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return simpleDishs.count == 0 ? 1 : simpleDishs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
        cell = simpleDishs.count == 0 ? FoldTableViewCell(with: .none, name: "暂无数据") : DayDishTableViewCell(dish: simpleDishs[indexPath.row])
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.001
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DishDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        var dish: SimpleDish?
        
        dish = simpleDishs[indexPath.row]
        
        vc.dish = dish
        RecordAPIs.getDishInfo(kgId: dish!.kgID ?? "", success: { str in
            vc.element = str
        })
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return simpleDishs.count == 0 ? 160 : 70
    }
}

extension AddDishViewController: UITextFieldDelegate, PageTitleViewDelegate, PageContentViewDelegate, TitleCollectionViewDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        let vc = SearchDishViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
        textField.resignFirstResponder()
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        searchField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        searchField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        searchField.resignFirstResponder()
        return true
    }
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView?.setCurrentIndex(currentIndex: index)
    }
    
    func titleCollectionView(titleView: TitleCollectionView, selectedIndex index: Int) {
        pageContentView?.setCurrentIndex(currentIndex: index)
    }
}

extension AddDishViewController {
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addDiy(){
        DoctorAPIs.getRemainFlower(success: { num in
            if num < 100 {
                self.tipWithLabel(msg: "鲜花数量少于100， 不允许添加")
            } else {
                let vc = DiyDishViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
    
    @objc func addDiyFood() {
        DoctorAPIs.getRemainFlower(success: { num in
            if num < 10 {
                self.tipWithLabel(msg: "鲜花数量少于10， 不允许添加")
            } else {
                let vc = DiyFoodViewController()
                vc.hidesBottomBarWhenPushed = true
                self.navigationController?.pushViewController(vc, animated: true)
            }
        })
    }
}

extension AddDishViewController {
    func setUpUI() {
        pageContentView = PageContentView(frame: contentFrame, views: [subViewOne, subViewTwo!, subViewThree!, subViewFour, subViewFive, subViewSix])
        pageContentView?.delegate = self
        view.addSubview(pageContentView!)
        let subViews = [subViewFour, subViewFive, subViewSix]
        let btns = [addBtn, addBtnTwo, addBtnThree]
        for i in 0..<3 {
            subViews[i].addSubview(btns[i])
            btns[i].snp.makeConstraints { make in
                make.height.equalTo(50)
                make.width.equalTo(50)
                make.right.equalTo(subViews[i]).offset(-30)
                make.bottom.equalTo(subViews[i]).offset(-30)
            }
        }
    }
    
    func setUpNav() {
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        
        self.title = "添加菜品"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
}

extension AddDishViewController {
    func getHistory(uid: String, page: Int = 0, success: @escaping ([SimpleDish]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.getUserHistoryRecords, parameters: ["uid": uid, "page": "\(0)"], success: { dict in
            guard let data = dict["data"] as? [String: Any], let recipeList = data["recipeList"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: recipeList, options: [])
                let recipe = try JSONDecoder().decode([SimpleDish].self, from: json)
                success(recipe)
            } catch {
                print("sad")
            }
        }, failure: { _ in
            
        })
    }
    
    func searchFoods(str: String) {
        SolaSessionManager.solaSession(type: .post, url: RecordAPIs.searchFoods, parameters: ["keyword": str], success: { dict in
            guard let data = dict["data"] as? [String: Any] else {
                return
            }
        }, failure: { _ in
            
        })
    }
    
    func getRecipeNames(success: @escaping () -> Void) {
        let group = DispatchGroup()
        group.enter()
        RecordAPIs.getRecipeList(uid: UserInfo.shared.user.uid, type: 0, cateId: nil) { list in
            self.materialGroups = list[0]
            group.leave()
        }
        group.enter()
        RecordAPIs.getRecipeList(uid: UserInfo.shared.user.uid, type: 1, cateId: nil) { list in
            self.dishGroups = list[0]
            group.leave()
        }
        group.notify(queue: DispatchQueue.main) {
            success()
        }
    }
}

