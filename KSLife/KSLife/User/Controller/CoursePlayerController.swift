//
//  CoursePlayerController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/7/2.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import AVFoundation
class CoursePlayerController: UIViewController, UIScrollViewDelegate {
    //获取 AppDelegate 对象
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
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
    
    var yuYinBtn: UIButton! // 语音按钮
    var mainLable: UILabel!
    var secondLable: UILabel!
    var playSlider: UISlider! // 进度条
    var currentTime: UILabel!
    var totalTime: UILabel!
    
    // 播放器相关
    var playerItem: AVPlayerItem!
    var player: AVPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dataSource = CourseInfo.courseInfo.enroll[CourseInfo.index].newContent
        self.title = "课程详情"
        self.view.backgroundColor = UIColor.white
        
        //获取并设置scrollerView尺寸
        self.scrollerViewWidth = Device.height
        self.scrollerViewHeight = Device.width*2/3
        
        //设置scrollerView
        self.configureScrollerView()
        //设置imageView
        self.configureImageView()
        //设置页控制器
        self.configurePageController()
        // 设置底部UI
        self.setBottomUI()
    }
    //设置scrollerView
    func configureScrollerView(){
        self.scrollerView = UIScrollView(frame: CGRect(x: 0,y: 40,
                                                       width: self.scrollerViewWidth!,
                                                       height: self.scrollerViewHeight!))
        self.scrollerView?.backgroundColor = UIColor.white
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
        self.pageControl = UIPageControl(frame: CGRect(x: self.scrollerViewWidth!/2-200,
                                                       y: self.scrollerViewHeight! + 20, width: 120, height: 20))
        self.pageControl?.pageIndicatorTintColor = .gray
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
    // MARK: - 设置底部UI
    func setBottomUI() {
        yuYinBtn = UIButton(frame: CGRect(x: 20, y: (scrollerView?.frame.maxY)! + 20, width: 70, height: 70))
        yuYinBtn.setBackgroundImage(UIImage(named: "yuyin"), for: .normal)
        yuYinBtn.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        self.view.addSubview(yuYinBtn)
        
        mainLable = UILabel(frame: CGRect(x: yuYinBtn.frame.maxX + 20, y: (scrollerView?.frame.maxY)!+5, width: scrollerViewWidth!*3/4, height: 30))
        mainLable.text = CourseInfo.courseInfo.enroll[CourseInfo.index].title
        mainLable.textColor = .gray
        mainLable.font = UIFont.systemFont(ofSize: 20)
        self.view.addSubview(mainLable)
        
        secondLable = UILabel(frame: CGRect(x: mainLable.frame.minX, y: mainLable.frame.maxY+3, width: scrollerViewWidth!*3/4, height: 25))
        secondLable.textColor = .gray
        secondLable.font = UIFont.systemFont(ofSize: 15)
        secondLable.text = "介绍估算自己每餐吃的食物的重量的简单方法，方便用户记录自己的饮食数据。"
        self.view.addSubview(secondLable)
        
        // 初始化播放器
        let musicUrl = URL(string: CourseInfo.courseInfo.enroll[CourseInfo.index].url)
        playerItem = AVPlayerItem(url: musicUrl!)
        player = AVPlayer(playerItem: playerItem)
        
        // 设置进度条相关属性
        let duration: CMTime = playerItem.asset.duration
        let second: Float64 = CMTimeGetSeconds(duration)
        playSlider = UISlider(frame: CGRect(x: secondLable.frame.minX, y: secondLable.frame.maxY+3, width: scrollerViewWidth!-yuYinBtn.frame.maxX-40, height: 10))
        playSlider.addTarget(self, action: #selector(playbackSliderValueChanged), for: .valueChanged)
        self.view.addSubview(playSlider)
        
        currentTime = UILabel(frame: CGRect(x: playSlider.frame.minX, y: playSlider.frame.maxY+2, width: 50, height: 15))
        currentTime.font = UIFont.systemFont(ofSize: 15)
        currentTime.text = "00:00"
        self.view.addSubview(currentTime)
        
        totalTime = UILabel(frame: CGRect(x: playSlider.frame.maxX-30, y: playSlider.frame.maxY+2, width: 50, height: 15))
        totalTime.font = UIFont.systemFont(ofSize: 15)
        totalTime.text = self.getTime(currentTime: CourseInfo.courseInfo.enroll[CourseInfo.index].duration)
        self.view.addSubview(totalTime)
        
        playSlider.minimumValue = 0
        playSlider.maximumValue = Float(second)
        playSlider.isContinuous = false
        
        //播放过程中动态改变进度条值和时间标签
        player!.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1),
                                        queue: DispatchQueue.main) { (CMTime) -> Void in
                                            if self.player!.currentItem?.status == .readyToPlay {
                                                //更新进度条进度值
                                                let currentTime = CMTimeGetSeconds(self.player!.currentTime())
                                                self.playSlider!.value = Float(currentTime)
                                                //更新播放时间
                                                self.currentTime!.text=self.getTime(currentTime: Int(currentTime))
                                            }
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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //该页面显示时强制横屏显示
        appDelegate.interfaceOrientations = [.landscapeLeft, .landscapeRight]
        //页面显示时添加歌曲播放结束通知监听
        NotificationCenter.default.addObserver(self, selector: #selector(finishedPlaying),
                                               name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: playerItem)
    }
    //歌曲播放完毕
    @objc func finishedPlaying(myNotification:NSNotification) {
        print("播放完毕!")
        let stopedPlayerItem = myNotification.object as! AVPlayerItem
        stopedPlayerItem.seek(to: CMTime.zero, completionHandler: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        //页面消失时取消歌曲播放结束通知监听
        NotificationCenter.default.removeObserver(self)
        player!.pause()
        //页面退出时还原强制竖屏状态
        appDelegate.interfaceOrientations = .portrait
        
        
    }
    //播放按钮点击
    @objc func playButtonTapped() {
        //根据rate属性判断当天是否在播放
        if player?.rate == 0 {
            player!.play()
        } else {
            player!.pause()
        }
    }
    //拖动进度条改变值时触发
    @objc func playbackSliderValueChanged() {
        let seconds : Int64 = Int64(playSlider.value)
        let targetTime:CMTime = CMTimeMake(value: seconds, timescale: 1)
        //播放器定位到对应的位置
        player!.seek(to: targetTime)
        //如果当前时暂停状态，则自动播放
        if player!.rate == 0
        {
            player?.play()
        }
    }
    func getTime(currentTime: Int) -> String {
        //一个小算法，来实现00：00这种格式的播放时间
        let all:Int=Int(currentTime)
        let m:Int=all % 60
        let f:Int=Int(all/60)
        var time:String=""
        if f<10{
            time="0\(f):"
        }else {
            time="\(f)"
        }
        if m<10{
            time+="0\(m)"
        }else {
            time+="\(m)"
        }
        return time
    }
}
