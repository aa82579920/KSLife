//
//  CourseTopNewsView.swift
//  KSLife
//
//  Created by 王春杉 on 2019/7/2.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
//图片轮播组件代理协议
protocol SliderGalleryControllerDelegate{
    //获取数据源
    func galleryDataSource()->[String]
    //获取内部scrollerView的宽高尺寸
    func galleryScrollerViewSize()->CGSize
}

class CourseTopNewsView: UIViewController, UIScrollViewDelegate {
    // 代理对象
    var delegate: SliderGalleryControllerDelegate!
    
    // 当前图片的索引
    var currentIndex = 0
    // 数据源
    var dataSource: [String]?
    //用于轮播的左中右三个image（不管几张图片都是这三个imageView交替使用）
    var leftImageView , middleImageView , rightImageView: UIImageView?
    //放置imageView的滚动视图
    var scrollerView : UIScrollView?
    //scrollView的宽和高
    var scrollerViewWidth : CGFloat?
    var scrollerViewHeight : CGFloat?
    //页控制器（小圆点）
    var pageControl : UIPageControl?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //获取并设置scrollerView尺寸
        let size : CGSize = self.delegate.galleryScrollerViewSize()
        self.scrollerViewWidth = size.width
        self.scrollerViewHeight = size.height
        
        //获取数据
        self.dataSource =  self.delegate.galleryDataSource()
        //设置scrollerView
        self.configureScrollerView()
        //设置imageView
        self.configureImageView()
        //设置页控制器
        self.configurePageController()
        
        self.view.backgroundColor = UIColor.black
    }
    
    //设置scrollerView
    func configureScrollerView(){
        self.scrollerView = UIScrollView(frame: CGRect(x: 0,y: 0,
                                                       width: self.scrollerViewWidth!,
                                                       height: self.scrollerViewHeight!))
        self.scrollerView?.backgroundColor = UIColor.red
        self.scrollerView?.delegate = self

        self.scrollerView?.contentSize = CGSize(width: self.scrollerViewWidth! * 3,
                                                height: self.scrollerViewHeight!)
        //滚动视图内容区域从零开始
        self.scrollerView?.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
        self.scrollerView?.isPagingEnabled = true
        self.scrollerView?.bounces = false
        self.view.addSubview(self.scrollerView!)
        
    }
    //设置imageView
    func configureImageView(){
        self.leftImageView = UIImageView(frame: CGRect(x: self.scrollerViewWidth!/6, y: 0,
                                                       width: self.scrollerViewWidth!/3*2,
                                                       height: self.scrollerViewHeight!))
        self.middleImageView = UIImageView(frame: CGRect(x: self.scrollerViewWidth!+self.scrollerViewWidth!/6, y: 0,
                                                         width: self.scrollerViewWidth!/3*2,
                                                         height: self.scrollerViewHeight! ))
        self.rightImageView = UIImageView(frame: CGRect(x: 2*self.scrollerViewWidth!+self.scrollerViewWidth!/6, y: 0,
                                                        width: self.scrollerViewWidth!/3*2,
                                                        height: self.scrollerViewHeight!))
        self.scrollerView?.showsHorizontalScrollIndicator = false
        
        //设置初始时左中右三个imageView的图片（分别时数据源中最后一张，第一张，第二张图片）
        if(self.dataSource?.count != 0){
            resetImageViewSource()
        }
        
        self.scrollerView?.addSubview(self.leftImageView!)
        self.scrollerView?.addSubview(self.middleImageView!)
        self.scrollerView?.addSubview(self.rightImageView!)
    }
    
    //设置页控制器
    func configurePageController() {
        self.pageControl = UIPageControl(frame: CGRect(x: self.scrollerViewWidth!/2-60,
                                                       y: self.scrollerViewHeight! - 20, width: 120, height: 20))
        self.pageControl?.numberOfPages = (self.dataSource?.count)!
        self.pageControl?.isUserInteractionEnabled = false
        self.view.addSubview(self.pageControl!)
    }
    
    //每当滚动后重新设置各个imageView的图片
    func resetImageViewSource() {
        //当前显示的是第一张图片
        if self.currentIndex == 0 {
            self.leftImageView?.sd_setImage(with: URL(string: self.dataSource!.last!))
            self.middleImageView?.sd_setImage(with: URL(string: self.dataSource!.first!))
            let rightImageIndex = (self.dataSource?.count)!>1 ? 1 : 0 //保护
            self.leftImageView?.sd_setImage(with: URL(string: self.dataSource![rightImageIndex]))
            
        }
            //当前显示的是最后一张图片
        else if self.currentIndex == (self.dataSource?.count)! - 1 {
            self.leftImageView?.sd_setImage(with: URL(string: self.dataSource![self.currentIndex-1]))
            self.middleImageView?.sd_setImage(with: URL(string: self.dataSource!.last!))
            self.leftImageView?.sd_setImage(with: URL(string: self.dataSource!.first!))
            
        }
            //其他情况
        else{
            self.leftImageView?.sd_setImage(with: URL(string: self.dataSource![self.currentIndex-1]))
            self.middleImageView?.sd_setImage(with: URL(string: self.dataSource![self.currentIndex]))
            self.leftImageView?.sd_setImage(with: URL(string: self.dataSource![self.currentIndex+1]))
        }
    }
    //scrollView滚动完毕后触发
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //获取当前偏移量
        let offset = scrollView.contentOffset.x
        
        if(self.dataSource?.count != 0){
            
            //如果向左滑动（显示下一张）
            if(offset >= self.scrollerViewWidth!*2){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                //视图索引+1
                self.currentIndex = self.currentIndex + 1
                
                if self.currentIndex == self.dataSource?.count {
                    self.currentIndex = 0
                }
            }
            
            //如果向右滑动（显示上一张）
            if(offset <= 0){
                //还原偏移量
                scrollView.contentOffset = CGPoint(x: self.scrollerViewWidth!, y: 0)
                //视图索引-1
                self.currentIndex = self.currentIndex - 1
                
                if self.currentIndex == -1 {
                    self.currentIndex = (self.dataSource?.count)! - 1
                }
            }
            
            //重新设置各个imageView的图片
            resetImageViewSource()
            //设置页控制器当前页码
            self.pageControl?.currentPage = self.currentIndex
        }
    }
}
