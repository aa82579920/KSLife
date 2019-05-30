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
        setUpUI()
        setUpNav()
//        remakeConstraints()
    }
    
    private let titleViewH: CGFloat = screenH * 0.06
    private let searchViewH: CGFloat = 40
    
    private lazy var searchField: UITextField = {[weak self] in
        let field = UITextField(frame: CGRect(x: 15, y: statusH + navigationBarH, width: screenW - 30, height: searchViewH))
        field.backgroundColor = UIColor(hex6: 0xe6e6e6)
        field.borderStyle = .roundedRect
        field.layer.cornerRadius = 15
        field.font = UIFont.systemFont(ofSize: 16)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.delegate = self
        
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
    
    private lazy var pageTitleView: PageTitleView = {[weak self] in
        let titles = ["最爱","菜肴","自定套餐","自定菜肴","自定食品"]
        let view = PageTitleView(frame: CGRect(x: 0, y: statusH + navigationBarH + searchViewH, width: screenW, height: titleViewH), titles: titles, with: .flexibleType)
        view.delegate = self
        return view
    }()

    private lazy var pageContentView: PageContentView = { [weak self] in
        let contentH = screenH - statusH - navigationBarH - titleViewH - searchViewH
        let contentFrame = CGRect(x: 0, y: statusH + navigationBarH + titleViewH + searchViewH, width: screenW, height: contentH)
        let views = [subViewOne,subViewTwo,subViewThree,subViewFour,subViewFive]
        let view = PageContentView(frame: contentFrame, views: views)
        view.delegate = self
        return view
    }()
    
    private lazy var subTableViews: [UITableView] = []
    
    private lazy var pageTitleViewSec: PageTitleView = {[weak self] in
        let titles = ["家常菜","川菜","湘菜","湘菜","粤菜","江浙沪菜","家常菜"]
        let view = PageTitleView(frame: CGRect(x: 0, y: 0, width: screenW, height: titleViewH), titles: titles, with: .fixedType)
        view.delegate = self
        return view
        }()
    
    private lazy var pageContentViewSec: PageContentView = { [weak self] in
        let contentH = screenH - statusH - navigationBarH - 2 * titleViewH - searchViewH
        let contentFrame = CGRect(x: 0, y: titleViewH, width: screenW, height: contentH)
        for i in 0..<7 {
            let tableView = UITableView(frame: .zero, style: .grouped)
            tableView.rowHeight = 70
            tableView.delegate = self
            tableView.dataSource = self
            tableView.sectionHeaderHeight = 0
            tableView.separatorStyle = .singleLine
            tableView.showsVerticalScrollIndicator = false
            tableView.register(DayDishTableViewCell.self, forCellReuseIdentifier: faviDishCellID)
            subTableViews.append(tableView)
        }
        let views = subTableViews
        let view = PageContentView(frame: contentFrame, views: views)
        view.delegate = self
        return view
        }()
    
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
    
    private lazy var subViewTwo: UIView = {[unowned self] in
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(pageTitleViewSec)
        view.addSubview(pageContentViewSec)
        return view
        }()
    
    private lazy var subViewThree: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = DayDishTableViewCell(with: .simple)
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
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension AddDishViewController: UITextFieldDelegate, PageTitleViewDelegate, PageContentViewDelegate{
    
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
        if contentView == pageContentView {
            pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        } else {
            pageTitleViewSec.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        }
    }
    
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        if titleView == pageTitleView {
            pageContentView.setCurrentIndex(currentIndex: index)
        } else {
            pageContentViewSec.setCurrentIndex(currentIndex: index)
        }
        
    }
}

extension AddDishViewController {
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func addDiy(){
        let vc = DiyDishViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addDiyFood() {
        let vc = DiyFoodViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddDishViewController {
    func setUpUI() {
        view.addSubview(searchField)
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
        let subViews = [subViewThree, subViewFour, subViewFive]
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
    
//    func remakeConstraints() {
//        let padding: CGFloat = 15
//        let margin: CGFloat = 20
//
//        searchField.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(view).offset(padding)
//            make.left.equalTo(view).offset(padding)
//            make.right.equalTo(view).offset(-padding)
//        }
//
//        pageTitleView.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(searchField.snp.bottom).offset(margin)
//            make.left.equalTo(view)
//            make.right.equalTo(view)
//            make.height.equalTo(titleViewH)
//        }
//
//        pageContentView.snp.makeConstraints { (make) -> Void in
//            make.top.equalTo(pageTitleView.snp.bottom)
//            make.left.equalTo(view)
//            make.right.equalTo(view)
//            make.bottom.equalTo(view)
//        }
//    }
    
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
