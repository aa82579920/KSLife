//
//  DropDownMenu.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/30.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

protocol DropDownMenuDelegate {
    func setDropDownDelegate(sender: DropDownMenu)
}

class DropDownMenu: UIView {
    
    var deleget: DropDownMenuDelegate?
    
    private let tableViewCellID = "tableViewCellID"
    
    private var menuTableView =  UITableView()
    
    private var btnSender = UIButton()
    
    private var buttonFrame =  CGRect.zero
    private var titleList: [String] = []

    class func returnIndexByString(string: String, fromArray array: [String]) -> Int{
        let index = array.firstIndex(of: string).hashValue
        return index
    }
    
    func hideDropDownMenuWithBtnFrame(btnFrame: CGRect) {
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect(x: btnFrame.origin.x, y: btnFrame.origin.y-2, width: btnFrame.size.width, height: 0)
            self.menuTableView.frame = CGRect(x: 0, y: 0, width: btnFrame.size.width, height: 0)
        })
    }
    
    func showDropDownMenu(button: UIButton, withButtonFrame buttonFrame: CGRect, arrayOfTitle titleArr: [String]) {
        backgroundColor = UIColor(hex6: 0xdbdbdb)
        btnSender = button
        menuTableView = UITableView()
        self.buttonFrame = buttonFrame
        titleList = titleArr
        
        let btnRect = buttonFrame
        var height: CGFloat = 0
        if ( titleArr.count <= 4) {
            height = CGFloat(titleArr.count * 40)
        }else{
            height = 200
        }
        
        frame = CGRect(x: btnRect.origin.x, y: btnRect.origin.y, width: btnRect.size.width, height: 0)
        layer.masksToBounds = false
        layer.cornerRadius = 8
        layer.shadowRadius = 1
        layer.shadowOpacity = 0.5
        
        menuTableView = UITableView(frame: CGRect(x: 0, y: 0, width: btnRect.size.width, height: 0), style: .plain)
//        menuTableView.tableFooterView = UIView(frame: CGRect(x: 0, y: 0, width: btnRect.size.width, height: 0.001))
        menuTableView.delegate = self
        menuTableView.dataSource = self
        menuTableView.separatorStyle = .singleLine
        menuTableView.separatorColor = UIColor(hex6: 0xdbdbdb)
        menuTableView.separatorInset = UIEdgeInsets(top: 0, left: -20, bottom: 0, right: 0)
        menuTableView.backgroundColor = UIColor(hex6: 0xdbdbdb)
        menuTableView.showsVerticalScrollIndicator = false
        menuTableView.register(UITableViewCell.self, forCellReuseIdentifier: tableViewCellID)
        
        UIView.animate(withDuration: 0.25, animations: {
            self.frame = CGRect(x: btnRect.origin.x, y: btnRect.origin.y - height, width: btnRect.size.width, height: height)
            self.menuTableView.frame = CGRect(x: 0, y: 0, width: btnRect.size.width, height: height)
        })
        addSubview(menuTableView)
    }
    
}

extension DropDownMenu: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titleList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellID, for: indexPath)
            cell.textLabel?.font = UIFont.systemFont(ofSize: 15)
            cell.textLabel?.textAlignment = .center
        cell.textLabel?.text = titleList[indexPath.row]
        cell.textLabel?.textColor = .black
        cell.backgroundColor = UIColor(hex6: 0xdbdbdb)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        hideDropDownMenuWithBtnFrame(btnFrame: buttonFrame)
        
        let cell = tableView.cellForRow(at: indexPath)
        self.btnSender.setTitle(cell?.textLabel?.text, for: .normal)
        myDelegate()
    }
    
    func myDelegate() {
        self.deleget?.setDropDownDelegate(sender: self)
    }
}
