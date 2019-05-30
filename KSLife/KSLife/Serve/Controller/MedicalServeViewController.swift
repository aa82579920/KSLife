//
//  MedicalServeViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class MedicalServeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpUI()
        remakeConstraints()
        self.navigationController!.delegate = self
    }
    
    private let doctorTableViewCellID = "doctorTableViewCellID"
    private let imageH: CGFloat = screenH * 0.4
    private let itemH: CGFloat = 100

    private lazy var cycleView: CycleView = {
        let view = CycleView(frame: CGRect(x: 0, y: 0, width: screenW, height: imageH))
        return view
    }()
    
    private lazy var searchField: UITextField = {[weak self] in
        let field = UITextField()
        field.backgroundColor = UIColor(hex6: 0xe6e6e6)
        field.borderStyle = .roundedRect
        field.font = UIFont.systemFont(ofSize: 16)
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
        field.leftViewMode = .always
        field.delegate = self
        
        let image = NSTextAttachment()
        image.image = UIImage(named: "search")
        image.bounds = CGRect(x: 0, y: -3, width: (field.font!.lineHeight), height: (field.font!.lineHeight))
        let imageStr = NSAttributedString(attachment: image)
        let string = NSAttributedString(string: " 请输入医生、医院", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        let allStr = NSMutableAttributedString()
        allStr.append(imageStr)
        allStr.append(string)
        field.attributedPlaceholder = allStr
        
        return field
    }()
    
    private lazy var searchBtn: UIButton = {
        let btn = NavButton(frame: CGRect.zero, title: "搜索")
        return btn
    }()
    
    private lazy var headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: statusH, width: screenW, height: screenH - statusH - getTabbarHeight()), style: .plain)
        tableView.estimatedRowHeight = itemH
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.backgroundColor = .white
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: screenW * 0.2, bottom: 0, right: 0)
        tableView.register(DoctorTableViewCell.self, forCellReuseIdentifier: doctorTableViewCellID)
        return tableView
        }()
    
    deinit {
        self.navigationController!.delegate = nil
    }
}

extension MedicalServeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: doctorTableViewCellID, for: indexPath)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return headerView
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DoctorViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension MedicalServeViewController: UITextFieldDelegate, UIScrollViewDelegate {
    
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
}

extension MedicalServeViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let isShowHomePage = viewController.isKind(of: MedicalServeViewController.self)
        self.navigationController?.setNavigationBarHidden(isShowHomePage, animated: true)
    }
}

extension MedicalServeViewController {
    func setUpUI() {
        view.addSubview(tableView)
        view.addSubview(headerView)
        headerView.addSubview(cycleView)
        headerView.addSubview(searchField)
        headerView.addSubview(searchBtn)
    }
    
    func remakeConstraints() {
        let padding: CGFloat = 10
        
        headerView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(screenW)
        }
        
        cycleView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(screenW)
            make.left.equalTo(headerView)
            make.top.equalTo(headerView)
            make.height.equalTo(imageH)
        }
        
        searchField.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(headerView).multipliedBy(0.75)
            make.left.equalTo(headerView).offset(padding)
            make.top.equalTo(cycleView.snp.bottom).offset(padding)
            make.bottom.equalTo(headerView).offset(-padding)
        }
        
        searchBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(searchField.snp.right).offset(padding)
            make.right.equalTo(headerView).offset(-padding)
            make.top.equalTo(searchField)
            make.bottom.equalTo(searchField)
        }
    }
}

