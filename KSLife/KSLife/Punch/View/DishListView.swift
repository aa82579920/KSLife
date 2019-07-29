//
//  DishListView.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/28.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import MJRefresh

class DishListView: UIView {
    
    private var groups: [SimpleDish] = []
    private var dishs: [SimpleDish] = []
    private var cateIds: [String] = []
    private var type: Int = 1
    private var page: Int = 0
    
    private var titles: [String] = []
    private var selectedIndex: Int = 0
    private var tableViews: [UITableView] = []
    private var pageTitleView: TitleCollectionView?
    private var pageContentView: PageContentView?
    
    private var fontSize: CGFloat = 16
    private let titleViewH: CGFloat = screenH * 0.06
    private let faviDishCellID = "faviDishCellID"

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
    }
    
    init(frame: CGRect, groups: [SimpleDish], fontSize: CGFloat = 16, type: Int) {
        self.titles = groups.map{ $0.groupName ?? "" }
        self.fontSize = fontSize
        self.cateIds = groups.map{ $0.groupId ?? ""}
        self.type = type
        super.init(frame: frame)
        
        pageTitleView = TitleCollectionView(frame: CGRect(x: 0, y: 0, width: frame.width, height: titleViewH), titles: titles, fontSize: fontSize)
        pageTitleView!.delegate = self
        addSubview(pageTitleView!)
        
        let contentH = frame.height - titleViewH
        let contentFrame = CGRect(x: 0, y: titleViewH, width: frame.width, height: contentH)
        for i in 0..<titles.count {
            let tableView = UITableView(frame: .zero, style: .grouped)
            tableView.rowHeight = 70
            tableView.delegate = self
            tableView.dataSource = self
            tableView.sectionHeaderHeight = 0
            tableView.separatorStyle = .singleLine
            tableView.showsVerticalScrollIndicator = false
            tableView.register(DayDishTableViewCell.self, forCellReuseIdentifier: faviDishCellID)
            let footer = MJRefreshAutoNormalFooter()
            footer.setRefreshingTarget(self, refreshingAction: #selector(getMore))
            footer.tag = i
            footer.setTitle("没有更多数据了", for: .noMoreData)
            tableView.mj_footer = footer
            tableViews.append(tableView)
        }
        
        pageContentView = PageContentView(frame: contentFrame, views: tableViews)
        pageContentView!.delegate = self
        addSubview(pageContentView!)
        
        RecordAPIs.getRecipeList(type: type, cateId: cateIds[0]) { (list) in
            self.dishs = list[1]
            self.tableViews[0].reloadData()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DishListView {
    @objc func getMore(sender: MJRefreshAutoNormalFooter) {
        page += 1
        let index = sender.tag
        RecordAPIs.getRecipeList(page: page, type: type, cateId: cateIds[index]) { list in
            if list[1].count <= 0 {
                self.tableViews[index].mj_footer.endRefreshingWithNoMoreData()
            }else{
                self.dishs += list[1]
                self.tableViews[index].reloadData()
            }
        }
        self.tableViews[index].mj_footer.endRefreshing()
    }
}

extension DishListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dishs.count == 0 ? 1 : dishs.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = dishs.count == 0 ? FoldTableViewCell(with: .none, name: "暂无数据") : DayDishTableViewCell(dish: dishs[indexPath.row])
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
        vc.dish = dishs[indexPath.row]
        RecordAPIs.getDishInfo(kgId: dishs[indexPath.row].kgID ?? "", success: { str in
            vc.element = str
        })
        self.getFirstViewController()?.navigationController?.pushViewController(vc, animated: true)

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return dishs.count == 0 ? 160 : 70
    }
}

extension DishListView: TitleCollectionViewDelegate, PageContentViewDelegate {
    func titleCollectionView(titleView: TitleCollectionView, selectedIndex index: Int) {
        pageContentView?.setCurrentIndex(currentIndex: index)
        RecordAPIs.getRecipeList(type: type, cateId: cateIds[index]) { list in
            self.dishs = list[1]
            self.tableViews[index].reloadData()
        }
    }
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        pageTitleView?.setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
        RecordAPIs.getRecipeList(type: type, cateId: cateIds[targetIndex]) { list in
            self.dishs = list[1]
            self.tableViews[targetIndex].reloadData()
        }
    }
    
    func getFirstViewController() -> UIViewController?{
        
        for view in sequence(first: self.superview, next: {$0?.superview}){
            
            if let responder = view?.next{
                
                if responder.isKind(of: UIViewController.self){
                    
                    return responder as? UIViewController
                }
            }
        }
        return nil
    }
}
