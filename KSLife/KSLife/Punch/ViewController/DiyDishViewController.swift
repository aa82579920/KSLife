//
//  DiyDishViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/29.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

class DiyDishViewController: PhotoViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
        setUpNav()
        remakeConstraints()
    }
    
    private var cellTitles = ["基本信息","菜肴名称","照片(可选)","地域选择","机构选择"]
    private let data = ["天津","云南","北京","上海","黑龙江","贵州"]
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.sectionHeaderHeight = 10
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableHeaderView = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0.0001))
        tableView.separatorStyle = .singleLine
//        tableView.isScrollEnabled = false
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
//        tableView.register(FoldTableViewCell.self, forCellReuseIdentifier: "foldCell")
        return tableView
    }()

    private lazy var cellField: UITextField = {
        let view = UITextField()
        view.placeholder = "如：番茄炒鸡蛋"
        view.font = UIFont.systemFont(ofSize: 13)
        return view
    }()
    
    private lazy var cellBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "photo"), for: .normal)
        btn.addTarget(self, action: #selector(tapAvatar), for: .touchUpInside)
        return btn
    }()
    
    private lazy var cellPickerView: UIPickerView = {[unowned self] in
        let view = UIPickerView()
        view.dataSource = self
        view.delegate = self
        view.backgroundColor = .white
        return view
    }()
    
    private lazy var textView: UITextView = {[unowned self] in
        let view = UITextView()
        view.delegate = self
        view.font = UIFont.systemFont(ofSize: 13)
        view.layer.borderColor = UIColor.lightGray.cgColor
        return view
        }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.isEnabled = false
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.lightGray
        label.text = "如：米饭100克..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.text = "该菜肴共0克"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        return label
    }()

    private lazy var button: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = .white
        btn.setTitle("+添加食材", for: .normal)
        btn.setTitleColor(.red, for: .normal)
        return btn
    }()
}

extension DiyDishViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row]
    }
}

extension DiyDishViewController: UITableViewDelegate, UITableViewDataSource, UITextViewDelegate, UITextFieldDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        cellField.resignFirstResponder()
        textView.resignFirstResponder()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 5
        default:
            return 1
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        
        let cellViews = [cellField, cellBtn, cellPickerView]
        
        switch indexPath.section {
        case 0:
            cell.textLabel?.text = cellTitles[indexPath.row]
            if indexPath.row == 1 || indexPath.row == 2 || indexPath.row == 3{
                cell.contentView.addSubview(cellViews[indexPath.row - 1])
                cellViews[indexPath.row - 1].snp.makeConstraints { (make) -> Void in
                    make.right.equalTo(cell.contentView).offset(-15)
                    make.height.equalTo(cell.contentView)
                }
            }
            if indexPath.row == 2 {
                cellViews[1].snp.makeConstraints { (make) -> Void in
                    make.width.equalTo(cellViews[1].snp.height)
                }
            }
//            if indexPath.row == 3 {
//                cellViews[2].snp.makeConstraints { (make) -> Void in
//                    make.width.equalTo(cellViews[1].snp.height)
//                }
//            }
        case 1:
            cell.contentView.addSubview(textView)
            textView.snp.makeConstraints { (make) -> Void in
                make.edges.equalToSuperview()
            }
            cell.contentView.addSubview(placeholderLabel)
            placeholderLabel.snp.makeConstraints { (make) -> Void in
                make.top.equalTo(textView).offset(8)
                make.left.equalTo(textView).offset(5)
                make.right.equalTo(textView)
            }
        case 2:
            cell.contentView.addSubview(label)
            label.sizeToFit()
            label.snp.makeConstraints { (make) -> Void in
                make.right.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView)
            }
            cell.backgroundColor = .clear
        case 3:
            cell.contentView.addSubview(button)
            button.snp.makeConstraints { (make) -> Void in
                make.edges.equalToSuperview()
            }
        default:
            break
        }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 1:
            return 100
        default:
            return 60
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in view.subviews {
            if (view.isKind(of: UITextView.self)) {
                view.resignFirstResponder()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text.count == 0) {
            placeholderLabel.text = "如：米饭100克..."
        } else {
            placeholderLabel.text = ""
        }
    }
}

extension DiyDishViewController {
    func setUpUI() {
        view.addSubview(tableView)
    }
    
    func setUpNav() {
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        let rightBtn = NavButton(frame: CGRect(x: 0, y: 5, width: 80, height: 30), title: "确定")
        rightBtn.cardRadius = 5
        rightBtn.addTarget(self, action: #selector(ensure), for: .touchUpInside)
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
        
        self.title = "添加自定套餐"
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    func remakeConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

extension DiyDishViewController {
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func ensure() {
        
    }
}
