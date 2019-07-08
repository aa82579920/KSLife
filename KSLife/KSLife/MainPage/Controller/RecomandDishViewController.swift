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
        
        view.addSubview(label)
        view.addSubview(titleCollectionView)
        view.addSubview(pageContentView)
        view.backgroundColor = .white
        
        for dish in dishs {
            switch dish.groupName {
            case "蛋白质食材":
                allChildVCs[0].dish = dish
                allChildVCs[0].element = dish.name
            case "蛋白菜肴":
                allChildVCs[1].dish = dish
            case "纤维食材":
                allChildVCs[2].dish = dish
                allChildVCs[2].element = dish.name
            case "纤维菜肴":
                allChildVCs[3].dish = dish
            case "维生素食材":
                allChildVCs[4].dish = dish
                allChildVCs[4].element = dish.name
            case "维生素菜肴":
                allChildVCs[5].dish = dish
            case "脂肪食材":
                allChildVCs[6].dish = dish
                allChildVCs[6].element = dish.name
            case "脂肪菜肴":
                allChildVCs[7].dish = dish
            case "碳水食材":
                allChildVCs[8].dish = dish
                allChildVCs[8].element = dish.name
            case "碳水菜肴":
                allChildVCs[9].dish = dish
            default:
                break
            }
        }
        for item in allChildVCs {
            RecordAPIs.getDishInfo(kgId: item.dish!.kgID, success: { str in
                item.element = str
            })
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    var dishs: [SimpleDish] = []
    
    var recomReason: String = "" {
        didSet {
            label.text = recomReason
        }
    }
    
    private var selectedIndex: Int = 0
    
    private var allChildVCs: [DishDetailViewController] = []
    
    private let titleViewH: CGFloat = screenH * 0.06
    
    private lazy var secPageTitleViews = [PageTitleView]()
    private lazy var secContentViews = [PageContentView]()
    
    private let titles = ["蛋白质推荐", "膳食纤维推荐", "维生素推荐", "脂肪推荐", "碳水化合物推荐"]
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: statusH + navigationBarH, width: screenW, height: titleViewH))
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        label.textColor = .lightGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var titleCollectionView: UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenW / 3, height: titleViewH)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: statusH + navigationBarH + titleViewH, width: screenW, height: titleViewH), collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TitleCellectionViewCell.self, forCellWithReuseIdentifier: "TitleCellID")
        
        return collectionView
        }()
    
    
    private lazy var pageContentView: PageContentView = {[weak self] in
        
        let contentH = screenH - statusH - navigationBarH - 2 * titleViewH
        let contentFrame = CGRect(x: 0, y: statusH + navigationBarH + 2 * titleViewH, width: screenW, height: contentH)
        
        var childViews = [UIView]()
        for i in 0..<5 {
            var childVCs = [DishDetailViewController(), DishDetailViewController()]
            for item in childVCs {
                item.isShowBtn = false
                allChildVCs.append(item)
            }
            let view = UIView(frame: contentFrame)
            let secPageTitleView = PageTitleView(frame: CGRect(x: 0, y: 0, width: screenW, height: titleViewH), titles: ["食材", "菜肴"], with: .flexibleType)
            secPageTitleView.backgroundColor = .white
            secPageTitleView.delegate = self
            secPageTitleViews.append(secPageTitleView)
            view.addSubview(secPageTitleView)
            let secContentView = PageContentView(frame: CGRect(x: 0, y: titleViewH, width: screenW, height: contentH - titleViewH), childVCs: childVCs, parentVC: self, isScroll: true)
            secContentView.delegate = self
            secContentViews.append(secContentView)
            view.addSubview(secContentView)
            childViews.append(view)
        }
        
        let contentView = PageContentView(frame: contentFrame, views: childViews, isScroll: false)
        contentView.backgroundColor = .white
        return contentView
        }()
}

extension RecomandDishViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCellID", for: indexPath) as! TitleCellectionViewCell
        cell.label.text = titles[indexPath.item]
        cell.isSelected = selectedIndex == indexPath.item ? true : false
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == selectedIndex {
            return
        }
        pageContentView.setCurrentIndex(currentIndex: indexPath.row)
        collectionView.deselectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true)
        selectedIndex = indexPath.item
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
    }
    
}

extension RecomandDishViewController: PageTitleViewDelegate, PageContentViewDelegate {
    
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        for (i, item) in secContentViews.enumerated() {
            if item == contentView {
                secPageTitleViews[i].setTitleWithProgress(progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
            }
        }
    }
    
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int) {
        for (i, item) in secPageTitleViews.enumerated() {
            if item == titleView {
                secContentViews[i].setCurrentIndex(currentIndex: index)
            }
        }
    }
}

extension RecomandDishViewController {
    func setUpNav(_ animated: Bool){
        self.title = "您的专享营养方案"
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
}

class TitleCellectionViewCell: UICollectionViewCell {
    
    lazy var label: UILabel = {
        let label = UILabel()
        label.textColor = mainColor
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .white
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override var isSelected: Bool {
        didSet {
            label.textColor = oldValue ? mainColor : .lightGray
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
