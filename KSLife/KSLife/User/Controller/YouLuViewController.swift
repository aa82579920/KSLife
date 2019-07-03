//
//  YouLuViewController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/17.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
struct Device {
    static let width = UIScreen.main.bounds.width
    static let height = UIScreen.main.bounds.height
}
// 友录页面
class YouLuViewController: UIViewController {
    
    //Section标题 及 索引标题
    fileprivate var sectionArray: [String] {
        var sectionArray = [String]()
        for index in 0..<26 {
            sectionArray.append(String(UnicodeScalar(index + 65)!))
        }
        return sectionArray
    }
    fileprivate var tableView = UITableView()
    fileprivate var sectionCount = 5
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "通讯录"
        self.view.backgroundColor = .white
        
        self.tableView = UITableView(frame: self.view.bounds, style: .plain)
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
    }
    // MARK: - 获取联系人姓名首字母(传入汉字字符串, 返回大写拼音首字母)
    func getFirstLetterFromString(aString: String) -> (String) {
        
        // 注意,这里一定要转换成可变字符串
        let mutableString = NSMutableString.init(string: aString)
        // 将中文转换成带声调的拼音
        CFStringTransform(mutableString as CFMutableString, nil, kCFStringTransformToLatin, false)
        // 去掉声调(用此方法大大提高遍历的速度)
        let pinyinString = mutableString.folding(options: String.CompareOptions.diacriticInsensitive, locale: NSLocale.current)
        // 将拼音首字母装换成大写
        let strPinYin = polyphoneStringHandle(nameString: aString, pinyinString: pinyinString).uppercased()
        // 截取大写首字母
        let firstString = strPinYin.substring(to: strPinYin.index(strPinYin.startIndex, offsetBy:1))
        // 判断姓名首位是否为大写字母
        let regexA = "^[A-Z]$"
        let predA = NSPredicate.init(format: "SELF MATCHES %@", regexA)
        return predA.evaluate(with: firstString) ? firstString : "#"
    }
    /// 多音字处理
    func polyphoneStringHandle(nameString:String, pinyinString:String) -> String {
        if nameString.hasPrefix("长") {return "chang"}
        if nameString.hasPrefix("沈") {return "shen"}
        if nameString.hasPrefix("厦") {return "xia"}
        if nameString.hasPrefix("地") {return "di"}
        if nameString.hasPrefix("重") {return "chong"}
        
        return pinyinString;
    }
}
extension YouLuViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionCount
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return YouLuTableViewCell(index: indexPath.row)
    }
    // 设置每个Section标题
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionArray[section]
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

