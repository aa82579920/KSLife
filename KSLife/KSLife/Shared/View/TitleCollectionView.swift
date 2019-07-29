//
//  TitleCollectionView.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/28.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

protocol TitleCollectionViewDelegate: class {
    func titleCollectionView(titleView: TitleCollectionView, selectedIndex index: Int)
}

class TitleCollectionView: UIView {

    private let normalColor: (CGFloat, CGFloat, CGFloat) = (153, 153, 153)
    private let selectedColor: (CGFloat, CGFloat, CGFloat) = (0, 155, 255)
    private let scrollLineH: CGFloat = 2
    private var fontSize: CGFloat = 16
    
    private var titles: [String] 
    
    private var currentIndex: Int = 0
    weak var delegate: TitleCollectionViewDelegate?
    
    private var selectedIndex: Int = 0
    
    private lazy var collectionView: UICollectionView = {[weak self] in
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .zero
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = .white
        collectionView.bounces = false
        collectionView.isPagingEnabled = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(TitleCellectionViewCell.self, forCellWithReuseIdentifier: "TitleCellID")
        
        return collectionView
        }()
    
    private lazy var scrollLine: UIView = {
        let line = UIView()
        line.backgroundColor = mainColor
        return line
    }()

    init(frame: CGRect, titles: [String], fontSize: CGFloat = 16) {
        self.titles = titles
        self.fontSize = fontSize
        super.init(frame: frame)
        setupUI()
        collectionView.selectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        self.backgroundColor = .white
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension TitleCollectionView {
    func setupUI() {
        addSubview(collectionView)
        collectionView.frame = bounds
    }
}

extension TitleCollectionView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TitleCellID", for: indexPath) as! TitleCellectionViewCell
        cell.label.text = titles[indexPath.item]
        cell.font = fontSize
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.item == selectedIndex {
            return
        }
        collectionView.deselectItem(at: IndexPath(item: selectedIndex, section: 0), animated: true)
        selectedIndex = indexPath.item
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: false)
        collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .centeredHorizontally)
        
        delegate?.titleCollectionView(titleView: self, selectedIndex: selectedIndex)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let w = screenW / CGFloat(titles.count)
        let fitW = getNormalStrW(str: titles[indexPath.item], strFont: fontSize, h: frame.height) + 30
        return CGSize(width: fitW < w ? w : fitW, height: frame.height)
    }
    
}

//外部可用方法
extension TitleCollectionView {
    func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        
        collectionView.deselectItem(at: IndexPath(item: sourceIndex, section: 0), animated: true)
        collectionView.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at: .centeredHorizontally, animated: false)
        collectionView.selectItem(at: IndexPath(item: targetIndex, section: 0), animated: true, scrollPosition: .centeredHorizontally)
        delegate?.titleCollectionView(titleView: self, selectedIndex: selectedIndex)
        //记录最新index
        selectedIndex = targetIndex
    }
    
    private func getNormalStrW(str: String?, strFont: CGFloat, h: CGFloat) -> CGFloat {
        let w = CGFloat.greatestFiniteMagnitude
        if str != nil {
            let strSize = (str! as NSString).boundingRect(with: CGSize(width: w, height: h), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: strFont)], context: nil).size
            return strSize.width
        }
        return CGSize.zero.width
    }
}


