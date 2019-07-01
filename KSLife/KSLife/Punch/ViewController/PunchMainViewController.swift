//
//  PunchMainViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class PunchMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    private let titleViewH: CGFloat = screenH * 0.06
    
    private lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: statusH + navigationBarH, width: screenW, height: titleViewH)
        let titles = ["打卡", "分析"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles, with: .flexibleType)
        titleView.delegate = self
        return titleView
        }()
    
    private lazy var pageContentView: PageContentView = {[weak self] in
        
        let contentH = screenH - statusH - navigationBarH - titleViewH - getTabbarHeight()
        let contentFrame = CGRect(x: 0, y: statusH + navigationBarH + titleViewH, width: screenW, height: contentH)
        
        var childVCs = [UIViewController]()
        childVCs.append(PunchViewController())
        childVCs.append(AnalysisViewController())
        
        let contentView = PageContentView(frame: contentFrame, childVCs: childVCs, parentVC: self, isScroll: false)
        contentView.delegate = self
        return contentView
        }()
}

extension PunchMainViewController: PageTitleViewDelegate, PageContentViewDelegate {
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

extension PunchMainViewController {
    func setUpUI() {
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
    }
    
    func setUpNav(_ animated: Bool) {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
        
        let rightBtn = NavButton(frame: CGRect(x: 0, y: 5, width: 100, height: 30), backgroundColor: mainColor, titleColor: UIColor.white, title: "饮食记录")
        rightBtn.cardRadius = 5
        rightBtn.addTarget(self, action: #selector(restore), for: .touchUpInside)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    @objc func restore() {
        let vc = FoodRecordViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
}

