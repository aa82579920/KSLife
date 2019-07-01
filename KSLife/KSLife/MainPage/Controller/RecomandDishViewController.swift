//
//  RecomandDishViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/5.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class RecomandDishViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
        view.backgroundColor = .white
    }
    
    var dishs: [SimpleDish] = []
    
    private let titleViewH: CGFloat = screenH * 0.06
    
    private lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: statusH + navigationBarH, width: screenW, height: titleViewH)
        let titles = ["蛋白质推荐", "膳食纤维推荐", "维生素推荐"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles, with: .flexibleType)
        titleView.delegate = self
        return titleView
        }()
    
    private lazy var pageContentView: PageContentView = {[weak self] in
        
        let contentH = screenH - statusH - navigationBarH - titleViewH
        let contentFrame = CGRect(x: 0, y: statusH + navigationBarH + titleViewH, width: screenW, height: contentH)
        
        var childViews = [UIView]()
        for i in 0..<3 {
            var childVCs = [DishDetailViewController(), DishDetailViewController()]
            let view = UIView(frame: contentFrame)
            let secPageTitleView = PageTitleView(frame: CGRect(x: 0, y: 0, width: screenW, height: titleViewH), titles: ["食材", "菜肴"], with: .flexibleType)
            secPageTitleView.backgroundColor = .white
            view.addSubview(secPageTitleView)
            let secContentView = PageContentView(frame: CGRect(x: 0, y: titleViewH, width: screenW, height: contentH - titleViewH), childVCs: childVCs, parentVC: self, isScroll: true)
            view.addSubview(secContentView)
            childViews.append(view)
        }
        
        let contentView = PageContentView(frame: contentFrame, views: childViews, isScroll: false)
        contentView.backgroundColor = .white
        contentView.delegate = self
        return contentView
        }()
}

extension RecomandDishViewController: PageTitleViewDelegate, PageContentViewDelegate {
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}
