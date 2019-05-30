//
//  LibraryLibraryPageContentView.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/10/25.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

private enum PageContentType {
    case vcContent
    case viewContent
}

protocol PageContentViewDelegate: class {
    func pageContentView(contentView: PageContentView, progress: CGFloat, sourceIndex: Int, targetIndex: Int)
}

class PageContentView: UIView {
    private let ContentCellID = "ContentCellID"
    
    private var childVCs: [UIViewController] = []
    private var childViews: [UIView] = []
    private weak var parentVC: UIViewController?
    private var contentType: PageContentType = .vcContent
    private var starOffsetX: CGFloat = 0
    private var isFobidScroll: Bool = false
    weak var delegate: PageContentViewDelegate?
    
    private lazy var collectionView: UICollectionView = {[weak self] in
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = (self?.bounds.size)!
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = false
        collectionView.isPagingEnabled = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: ContentCellID)
        
        return collectionView
        }()
    
    init(frame: CGRect, childVCs: [UIViewController], parentVC: UIViewController?) {
        self.childVCs = childVCs
        self.parentVC = parentVC
        self.contentType = .vcContent
        super.init(frame: frame)
        
        setupUI()
    }
    
    init(frame: CGRect, views: [UIView]) {
        self.childViews = views
         self.contentType = .viewContent
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension PageContentView {
    private func setupUI() {
        switch contentType {
        case .vcContent:
            for childVC in childVCs {
                parentVC?.addChild(childVC)
            }
        default:
            break
        }
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

extension PageContentView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return contentType == PageContentType.vcContent ? childVCs.count : childViews.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ContentCellID, for: indexPath)
        
        for view in cell.contentView.subviews {
            view.removeFromSuperview()
        }
        
        switch contentType {
        case .vcContent:
            let childVC = childVCs[indexPath.item]
            childVC.view.frame = cell.contentView.bounds
            cell.contentView.addSubview(childVC.view)
        default:
            let childView = childViews[indexPath.item]
            childView.frame = cell.contentView.bounds
            cell.contentView.addSubview(childView)
        }
        return cell
    }
}

extension PageContentView: UICollectionViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isFobidScroll = false
        starOffsetX = scrollView.contentOffset.x
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        var progress: CGFloat = 0
        var sourceIndex: Int = 0
        var targetIndex: Int = 0
        
        //判断是否点击事件
        if isFobidScroll { return }
        
        //判断左滑还是右滑
        let currentOffsetX = scrollView.contentOffset.x
        let scrollViewW = scrollView.frame.width
        let count = contentType == .vcContent ? childVCs.count : childViews.count
        if currentOffsetX > starOffsetX {//左滑
            progress = currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW)
            
            sourceIndex = Int(currentOffsetX / scrollViewW)
            targetIndex = sourceIndex + 1
            
            if targetIndex >= count {
                targetIndex = count - 1
            }
            
            if currentOffsetX - starOffsetX == scrollViewW {
                progress = 1
                targetIndex = sourceIndex
            }
        } else {
            progress = 1 - (currentOffsetX / scrollViewW - floor(currentOffsetX / scrollViewW))
            
            targetIndex = Int(currentOffsetX / scrollViewW)
            sourceIndex = targetIndex + 1
            if sourceIndex >= count {
                sourceIndex = count - 1
            }
            
        }
        
        //将数据传递给titleView
        delegate?.pageContentView(contentView: self, progress: progress, sourceIndex: sourceIndex, targetIndex: targetIndex)
    }
}

extension PageContentView {
    func setCurrentIndex(currentIndex: Int) {
        //禁止执行代理
        isFobidScroll = true
        
        //滚动位置
        let offsetX = CGFloat(currentIndex) * collectionView.frame.width
        collectionView.setContentOffset(CGPoint(x: offsetX, y: 0), animated: false)
    }
}
