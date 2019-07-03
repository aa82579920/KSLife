//
//  FoodPreserveViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import Alamofire

class FoodPreserveViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        tabBarH = self.getTabbarHeight()
        setUpUI()
        remakeConstraints()
        self.navigationController!.delegate = self
//        Alamofire.request("http://47.92.141.153/EGuider/blog/getAllBlogs", method: .post, parameters:["page": "0"], headers: [:]).responseJSON { response in
//            switch response.result {
//            case .success:
//                print(response.result.value)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
        getBlogs(uid: UserInfo.shared.user.uid, type: 100, page: 0, success: { list in
            self.childVCs[0].blogs = list
        })
        getBlogs(uid: UserInfo.shared.user.uid, type: 101, page: 0, success: { list in
            self.childVCs[1].blogs = list
        })
        getBlogs(uid: UserInfo.shared.user.uid, type: 102, page: 0, success: { list in
            self.childVCs[2].blogs = list
        })
        getBanner(uid: UserInfo.shared.user.uid, success: { list in
            self.cycleView.imgUrls = list
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    
    private var tabBarH: CGFloat = 83
    private var blogs: [Blog] = []
    
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
    
    private var childVCs = [BlogViewController]()
    
    private lazy var pageContentView: PageContentView = {[weak self] in
        
        let contentH = screenH - statusH - titleViewH  - imageH - tabBarH
        let contentFrame = CGRect(x: 0, y: statusH + imageH + titleViewH, width: screenW, height: contentH)
        
        childVCs.append(BlogViewController())
        childVCs.append(BlogViewController())
        childVCs.append(BlogViewController())
        
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
        self.navigationController?.delegate = nil
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
        let vc = PostBlogViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.block = {
            self.childVCs[0].msgTableView.reloadData()
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

// Mark: -NetWork
extension FoodPreserveViewController {
    
    func getBlogs(uid: String,  type: Int, page: Int, success: @escaping ([Blog]) -> Void) {
//        let disGroup = DispatchGroup()
        SolaSessionManager.solaSession(type: .post, url: BlogAPIs.getBlogs, parameters: ["uid": uid, "page": "\(page)", "type": "\(type)"], success: { dict in
            guard let data = dict["data"] as? [Any] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: data, options: [])
                let tBlog = try JSONDecoder().decode([Blog].self, from: json)
                success(tBlog)
            } catch {
                print("cant show blog")
            }
        }, failure: { error in
            print(error)
        })
    }
    
    func getBlog(bid: Int, success: @escaping (Blog) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: BlogAPIs.getBlog, parameters: ["bid": "\(bid)"], success: { dict in
            guard let data = dict["data"] as? [String: Any], let blog = data["blog"] else {
                return
            }
            do {
                let json = try JSONSerialization.data(withJSONObject: blog, options: [])
                let tBlog = try JSONDecoder().decode(Blog.self, from: json)
                success(tBlog)
            } catch {
                print("cant show blog")
            }
        }, failure: { _ in
            
        })
    }
    
    func getBanner(uid: String, success: @escaping ([String]) -> Void) {
        SolaSessionManager.solaSession(type: .post, url: BlogAPIs.getBanner, parameters: ["uid": "\(uid)"], success: { dict in
            guard let data = dict["data"] as? [[String: Any]] else {
                return
            }
            var list: [String] = []
            for img in data {
                if let url = img["imageUrl"] as? String {
                     list.append(url)
                }
            }
            success(list)
        }, failure: { _ in
            
        })
    }
}
