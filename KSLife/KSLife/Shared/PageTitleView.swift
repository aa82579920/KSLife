//
//  PageTitleView.swift
//  WePeiYang
//
//  Created by 毛线 on 2018/10/25.
//  Copyright © 2018 twtstudio. All rights reserved.
//

import UIKit

enum PageTitleType {
    case flexibleType
    case fixedType
}

protocol PageTitleViewDelegate: class {
    func pageTitleView(titleView: PageTitleView, selectedIndex index: Int)
}

class PageTitleView: UIView {
    private let normalColor: (CGFloat, CGFloat, CGFloat) = (153, 153, 153)
    private let selectedColor: (CGFloat, CGFloat, CGFloat) = (0, 155, 255)
    private let scrollLineH: CGFloat = 2
    
     private var titleType: PageTitleType = .flexibleType
    
    private var titles: [String]
    private var currentIndex: Int = 0
    weak var delegate: PageTitleViewDelegate?
    
    private lazy var titleLabel = [UILabel]()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.scrollsToTop = false
        scrollView.bounces = false
        //设置scrollView内边距
        //        scrollView.contentInsetAdjustmentBehavior = .never
        scrollView.contentInset = .zero
        return scrollView
    }()
    
    private lazy var scrollLine: UIView = {
        let line = UIView()
        line.backgroundColor = mainColor
        return line
    }()
    
    init(frame: CGRect, titles: [String], with type: PageTitleType) {
        self.titles = titles
        self.titleType = type
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PageTitleView {
    private func setupUI() {
        addSubview(scrollView)
        scrollView.frame = bounds
        setupTitleLabels()
        setupButtomMenuAndScrollLine()
    }
    
    private func setupTitleLabels() {
        
        let labelW: CGFloat = (titleType == .flexibleType) ? frame.width / CGFloat(titles.count) : 80
        let labelH: CGFloat = frame.height - scrollLineH
        let labelY: CGFloat = 0
        
        for (index, title) in titles.enumerated() {
            let label = UILabel()
            
            label.text = title
            label.tag = index
            label.font = UIFont.systemFont(ofSize: 16)
            label.textColor = UIColor(r: normalColor.0, g: normalColor.1, b: normalColor.2)
            label.textAlignment = .center
            
            let labelX: CGFloat = labelW * CGFloat(index)
            label.frame = CGRect(x: labelX, y: labelY, width: labelW, height: labelH)
            
            scrollView.addSubview(label)
            titleLabel.append(label)
            
            //给label添加手势
            label.isUserInteractionEnabled = true
            let tapGes = UITapGestureRecognizer(target: self, action: #selector(self.titleLabelClick))
            label.addGestureRecognizer(tapGes)
        }
    }
    
    private func setupButtomMenuAndScrollLine() {
        //添加底线
        let buttomLine = UIView()
        buttomLine.backgroundColor = UIColor.gray
        let lineH: CGFloat = 0.5
        buttomLine.frame = CGRect(x: 0, y: frame.height - lineH, width: frame.width, height: lineH)
        addSubview(buttomLine)
        
        //添加scrollLine
        guard let firstLabel = titleLabel.first else { return }
        firstLabel.textColor = mainColor
        
        scrollView.addSubview(scrollLine)
        scrollLine.frame = CGRect(x: firstLabel.frame.origin.x, y: frame.height - scrollLineH, width: firstLabel.frame.width, height: scrollLineH)
    }
    
}

//监听label
extension PageTitleView {
    @objc private func titleLabelClick(tapGes: UITapGestureRecognizer) {
        //label改变颜色
        guard let currentLabel = tapGes.view as? UILabel else { return }
        let oldLabel = titleLabel[currentIndex]
        
        oldLabel.textColor = UIColor(r: normalColor.0, g: normalColor.1, b: normalColor.2)
        currentLabel.textColor = UIColor(r: selectedColor.0, g: selectedColor.1, b: selectedColor.2)
        
        currentIndex = currentLabel.tag
        
//        let maxOffsetX = CGFloat(titles.count * 80) - screenW
//        let offsetX = CGFloat(currentLabel.tag * 80) - (screenW - 160)
//        if(offsetX < 0 && offsetX > -maxOffsetX) {
//            scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
//        }
        
//        let offsetX = (CGFloat(titles.count * 80) - screenW) / CGFloat(titles.count - 1) * CGFloat(currentLabel.tag - oldLabel.tag)
//
//        scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
        
        //滚动条
        let scrollLineX = CGFloat(currentLabel.tag) * scrollLine.frame.width
        UIView.animate(withDuration: 0.15) {
            self.scrollLine.frame.origin.x = scrollLineX
        }
        
        //通知代理
        delegate?.pageTitleView(titleView: self, selectedIndex: currentIndex)
    }
}

//外部可用方法
extension PageTitleView {
    @objc func setTitleWithProgress(progress: CGFloat, sourceIndex: Int, targetIndex: Int) {
        let sourceLabel = titleLabel[sourceIndex]
        let targetLabel = titleLabel[targetIndex]
        
//        let offsetX = targetLabel.frame.minX - (screenW - targetLabel.bounds.width) * 0.5
//        if (offsetX > 0 && targetLabel.frame.maxX < screenW) {
//            scrollView.contentOffset = CGPoint(x: offsetX, y: 0)
//        }
        
        //处理滑块
        let moveAllX = targetLabel.frame.origin.x - sourceLabel.frame.origin.x
        let moveX = moveAllX * progress
        scrollLine.frame.origin.x = sourceLabel.frame.origin.x + moveX
        
        //颜色渐变
        let colorDelta = (selectedColor.0 - normalColor.0, selectedColor.1 - normalColor.1, selectedColor.2 - normalColor.2)
        sourceLabel.textColor = UIColor(r: selectedColor.0 - colorDelta.0 * progress, g: selectedColor.1 - colorDelta.1 * progress, b: selectedColor.2 - colorDelta.2 * progress)
        targetLabel.textColor = UIColor(r: normalColor.0 + colorDelta.0 * progress, g: normalColor.1 + colorDelta.1 * progress, b: normalColor.2 + colorDelta.2 * progress)
        
        //记录最新index
        currentIndex = targetIndex
    }
}


