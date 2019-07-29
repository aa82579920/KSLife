//
//  ActionSheetViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/29.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

typealias AddBlock = (_ diet: String)->(Void)
class ActionSheetViewController: SwiftPopup {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
    }
    
    var block: AddBlock?
    
    private var weight: Int = 0
    
    private lazy var tableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: CGRect(x: 0, y: screenH * 0.3, width: screenW, height: screenH * 0.7), style: .plain)
        tableView.sectionHeaderHeight = 60
        tableView.sectionFooterHeight = 0
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private lazy var textField: UITextField = {[unowned self] in
        let field = UITextField()
        field.backgroundColor = .white
        field.borderStyle = .roundedRect
        field.textAlignment = .center
        field.delegate = self
        return field
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["自动输入", "手动输入"])
        control.tintColor = mainColor
        control.selectedSegmentIndex = 1
        control.addTarget(self, action: #selector(selectItem), for: .valueChanged)
        return control
    }()
    
    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = 0
        slider.maximumValue = 5
        slider.value = 1
        slider.isContinuous = false
        slider.minimumTrackTintColor = mainColor
        slider.maximumTrackTintColor = .lightGray
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.isUserInteractionEnabled = false
        return slider
    }()
    
    private lazy var dropDownMenu: DropDownMenu = {[unowned self] in
        let menu = DropDownMenu()
        menu.deleget = self
        menu.tag = 1000
        return menu
    }()
    
    private lazy var dropBtn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor(hex6: 0xdbdbdb)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("杯(小150g-水)", for: .normal)
        btn.addTarget(self, action: #selector(dropDown), for: .touchUpInside)
        btn.isUserInteractionEnabled = false
        return btn
    }()
    
    private lazy var btn: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = mainColor
        btn.setTitle("确定(g)", for: .normal)
        btn.addTarget(self, action: #selector(actionClose), for: .touchUpInside)
        return btn
    }()
    
    @objc func actionClose(_ sender: Any) {
        if let block = block {
            block("\(weight)")
        }
        dismiss()
    }
    
    @objc func selectItem(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            textField.backgroundColor = UIColor(hex6: 0xe6e6e6)
            textField.isUserInteractionEnabled = false
            dropBtn.backgroundColor = UIColor(hex6: 0xdbdbdb)
            dropBtn.isUserInteractionEnabled = true
            slider.isUserInteractionEnabled = true
        } else {
            textField.backgroundColor = .white
            textField.isUserInteractionEnabled = true
            dropBtn.backgroundColor = UIColor(hex6: 0xe6e6e6)
            dropBtn.isUserInteractionEnabled = false
            slider.isUserInteractionEnabled = false
        }
    }
    
    @objc func sliderValueChanged() {
        slider.value = round(slider.value)
        weight = Int(slider.value * 150)
        self.btn.setTitle("确定\(weight)(g)", for: .normal)
        
    }
    
    @objc func dropDown() {
        let arr = ["杯（小150g-水）","杯（中300g-水）","杯（大550g-水）","盘（小100g）","盘（中300g）","盘（大500g）","碗（小200g）","碗（中350g）","碗（大500g）", "个（小50g）", "个（中100g）", "个（大150g）"]
        setupDropDownMenu(dropDownMenu: dropDownMenu, titleArray: arr, button: dropBtn)
        
    }
    
    func setupDropDownMenu(dropDownMenu: DropDownMenu, titleArray: [String], button: UIButton) {
         let btnFrame = getBtnFrame(button)
        
        if (dropDownMenu.tag == 1000) {
            dropDownMenu.showDropDownMenu(button: dropBtn, withButtonFrame: btnFrame, arrayOfTitle: titleArray)
            self.view.addSubview(dropDownMenu)
            dropDownMenu.tag = 2000
        } else {
            dropDownMenu.hideDropDownMenuWithBtnFrame(btnFrame: btnFrame)
            dropDownMenu.tag = 1000
        }
    }
    
    func getBtnFrame(_ button: UIButton) -> CGRect{
        button.layoutIfNeeded()
        return button.superview!.convert(button.frame, to: self.view)
    }
}

extension ActionSheetViewController: UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, DropDownMenuDelegate{
    func setDropDownDelegate(str: String?) {
        let regex = NSRegularExpression("[0-9]+")
        let a = regex.matchesString(str ?? "")
        weight = Int(a) ?? 0
        self.btn.setTitle("确定\(weight)(g)", for: .normal)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if textField.isFirstResponder {
            textField.resignFirstResponder()
        } else {
            dismiss()
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let text = textField.text {
            self.btn.setTitle("确定\(text)(g)", for: .normal)
            weight = Int(text) ?? 0
        }
        return true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = UIColor.white
        cell.selectionStyle = .none
        
        let padding: CGFloat = 15
        
        switch indexPath.row {
        case 0:
            let label = UILabel()
            cell.contentView.addSubview(label)
            label.text = "常用计量估计\n米饭：大碗-250克，中碗-150克，小碗-100克，餐盒-250克，大盘-300克，小盘-200克\n饮品：玻璃杯-300ml\n汤汁：汤匙-45克，小勺-10克"
            label.textColor = mainColor
            label.numberOfLines = 0
            label.font = UIFont.systemFont(ofSize: 13)
            label.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(cell.contentView).offset(padding)
                make.top.equalTo(cell.contentView).offset(padding)
                make.bottom.equalTo(cell.contentView).offset(-padding)
                make.width.equalTo(screenW * 0.6)
            }
            let imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            imageView.image = UIImage(named: "introdcution")
            imageView.snp.makeConstraints { (make) -> Void in
                make.right.equalTo(cell.contentView).offset(-padding)
                make.height.equalTo(cell.contentView)
                make.width.equalTo(screenW * 0.2)
            }
        case 1:
            let imageView = UIImageView()
            cell.contentView.addSubview(imageView)
            imageView.image = UIImage(named: "scales")
            imageView.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(cell.contentView).offset(2 * padding)
                make.centerY.equalTo(cell.contentView)
                make.height.equalTo(cell.contentView).multipliedBy(0.5)
                make.width.equalTo(imageView.snp.height)
            }
            cell.contentView.addSubview(textField)
            textField.snp.makeConstraints { (make) -> Void in
                make.left.equalTo(imageView.snp.right).offset(padding)
                make.centerY.equalTo(imageView)
                make.right.equalTo(cell.contentView).offset(-50)
            }
        case 2:
            cell.contentView.addSubview(segmentedControl)
            segmentedControl.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(cell.contentView).multipliedBy(0.5)
                make.centerX.equalTo(cell.contentView)
                make.centerY.equalTo(cell.contentView)
            }
        case 3:
            cell.contentView.addSubview(slider)
            slider.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(cell.contentView).multipliedBy(0.8)
                make.centerX.equalTo(cell.contentView)
                make.bottom.equalTo(cell.contentView).offset(-5)
                make.height.equalTo(cell.contentView).multipliedBy(0.5)
            }
            for i in 0..<6 {
                let label = UILabel()
                label.text = "\(i)"
                cell.contentView.addSubview(label)
                label.snp.makeConstraints { (make) -> Void in
                    make.width.equalTo(20)
                    let offsetx = screenW * 0.8 * CGFloat(i) / CGFloat(5)
                    make.centerX.equalTo(slider.snp.left).offset(offsetx)
                    make.bottom.equalTo(slider.snp.top).offset(-5)
                }
            }
        case 4:
            cell.contentView.addSubview(dropBtn)
            let imageView = UIImageView()
            imageView.image = UIImage(named: "drop_down")
            dropBtn.addSubview(imageView)
            dropBtn.snp.makeConstraints { (make) -> Void in
                make.width.equalTo(cell.contentView).multipliedBy(0.8)
                make.centerX.equalTo(cell.contentView)
                make.centerY.equalTo(cell.contentView)
                make.height.equalTo(cell.contentView).multipliedBy(0.5)
            }
            imageView.snp.makeConstraints { (make) -> Void in
                make.right.equalTo(dropBtn).offset(-10)
                make.height.equalTo(dropBtn).multipliedBy(0.5)
                make.width.equalTo(imageView.snp.height)
                make.centerY.equalTo(dropBtn)
            }
        case 5:
            cell.contentView.addSubview(btn)
            btn.snp.makeConstraints { (make) -> Void in
                make.edges.equalToSuperview()
            }
        default:
            break
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return (indexPath.row == 0) ? screenH * 0.2 : screenH * 0.1
    }
}
