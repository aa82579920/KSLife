//
//  FoodPreserveViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class FoodPreserveViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpUI()
        remakeConstraints()
        self.navigationController!.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    private let imageH: CGFloat = screenH * 0.2
    private let titleViewH: CGFloat = screenH * 0.06
    
    private lazy var cycleView: CycleView = {
       let view = CycleView(frame: CGRect(x: 0, y: statusH, width: screenW, height: imageH))
       return view
    }()
    
    private lazy var pageTitleView: PageTitleView = {[weak self] in
        let titleFrame = CGRect(x: 0, y: statusH + imageH, width: screenW, height: titleViewH)
        let titles = ["推荐", "关注", "发现"]
        let titleView = PageTitleView(frame: titleFrame, titles: titles, with: .flexibleType)
        titleView.delegate = self
        return titleView
    }()
    
    private lazy var pageContentView: PageContentView = {[weak self] in
        
        let contentH = screenH - statusH - titleViewH  - imageH
        let contentFrame = CGRect(x: 0, y: statusH + imageH + titleViewH, width: screenW, height: contentH)
        
        var childVCs = [MessageViewController]()
        childVCs.append(MessageViewController())
        childVCs.append(MessageViewController())
        childVCs.append(MessageViewController())
        
        let contentView = PageContentView(frame: contentFrame, childVCs: childVCs, parentVC: self)
        contentView.delegate = self
        return contentView
        }()
    
    private lazy var inputBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "input"), for: .normal)
        btn.addTarget(self, action: #selector(input), for: .touchUpInside)
        return btn
    }()
    
    deinit {
        self.navigationController!.delegate = nil
    }
}

extension FoodPreserveViewController: PageTitleViewDelegate, PageContentViewDelegate {
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
    
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        pageContentView.setCurrentIndex(currentIndex: index)
    }
}

extension FoodPreserveViewController: UINavigationControllerDelegate {
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        let isShowHomePage = viewController.isKind(of: FoodPreserveViewController.self)
        self.navigationController?.setNavigationBarHidden(isShowHomePage, animated: true)
    }
}

extension FoodPreserveViewController {
    func setUpUI() {
        view.addSubview(cycleView)
        view.addSubview(pageTitleView)
        view.addSubview(pageContentView)
        view.addSubview(inputBtn)
    }
    
    func setUpNav(_ animated: Bool) {
      
    }
    
    func remakeConstraints() {
        inputBtn.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(50)
            make.width.equalTo(50)
            make.right.equalTo(view).offset(-30)
            make.bottom.equalTo(view).offset(-30)
        }
        
    }
    
    @objc func input() {
        let vc = MsgWriteViewController()
        vc.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

