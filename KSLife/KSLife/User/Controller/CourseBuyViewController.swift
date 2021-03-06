//
//  CourseBuyViewController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/25.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
class CourseBuyViewController: UIViewController {
    
    var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    func setTableView() {
        tableView = UITableView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height), style: .plain)
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension CourseBuyViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return CourseInfo.courseInfo.enroll.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return CourseTableViewCell(index: indexPath.row, type: 0)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        CourseInfo.index = indexPath.row
        let playVC = CoursePlayerController()
        playVC.hidesBottomBarWhenPushed = true // 嵌套Navigatiion时隐藏tabBar
        self.navigationController?.pushViewController(playVC, animated: true)
    }
}
