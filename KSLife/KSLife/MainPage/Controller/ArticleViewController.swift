//
//  ArticleViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/3.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {
    
    
    var article: HomeArticlesData? {
        didSet {
            if let article = article {
                imageView.sd_setImage(with: URL(string: article.switchUrl))
                self.title = article.title
                favButton.isSelected = article.flag == 1 ? true : false
                favButton.setTitle("\(article.favor)", for: .normal)
                favButton.setTitle("\(article.favor + 1)", for: .selected)
                reButton.setTitle("\(article.comment)", for: .normal)
                BlogAPIs.getComments(bid: article.id, type: 1, success: { list in
                    self.comments = list
                })
                tableView.reloadData()
            }
        }
    }
    
    private var comments: [Comment] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(tableView)
        view.addSubview(replayView)
        
        replayView.addSubview(textField)
        replayView.addSubview(favButton)
        replayView.addSubview(reButton)
        remakeConstraints()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNav(animated)
    }
    private let commentTableViewCellID = "commentTableViewCellID"
    
    private lazy var tableView: UITableView = {
        [unowned self] in
        let tableView = UITableView(frame: .zero, style: .plain)
        tableView.estimatedRowHeight = 90
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: commentTableViewCellID)
        return tableView
        }()
    
    private lazy var imageView: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "发表200字以内回复"
        view.delegate = self
        return view
    }()
    
    private lazy var favButton: UIButton = {
        let btn = UIButton()
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "guanzhu"), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        btn.setImage(UIImage(named: "guanzhuOn"), for: .selected)
        btn.addTarget(self, action: #selector(fav), for: .touchUpInside)
        return btn
    }()
    
    private lazy var reButton: UIButton = {
        let btn = UIButton()
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "dangans"), for: .normal)
        btn.setTitleColor(UIColor.gray, for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        return btn
    }()
    
    
    private lazy var replayView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
}

extension ArticleViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if indexPath.section == 0 {
            cell.contentView.addSubview(imageView)
            imageView.snp.makeConstraints {make in
                var scale: CGFloat = 0
                guard let image = imageView.image else {
                    return
                }
                scale = image.size.height / image.size.width
                make.edges.equalTo(cell.contentView)
                make.height.equalTo(imageView.snp.width).multipliedBy(scale)
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: commentTableViewCellID, for: indexPath) as! CommentTableViewCell
            cell.comment = comments[indexPath.row]
            cell.backgroundColor = UIColor.white
            cell.selectionStyle = .none
            return cell
        }
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return comments.count + 1
    }
}

extension ArticleViewController {
    @objc func fav(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        favorArticle(id: article!.id)
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func remakeConstraints() {
        let margin: CGFloat = 20
        let padding: CGFloat = 10
        tableView.snp.makeConstraints {make in
            make.width.equalTo(view)
            make.top.equalTo(view)
            make.bottom.equalTo(view).offset(-(self.tabBarController?.tabBar.frame.height ?? 0))
        }
        
        replayView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(tableView.snp.bottom)
            make.width.equalTo(view)
            make.bottom.equalTo(view)
        }
        
        textField.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(replayView).offset(margin)
            make.width.equalTo(replayView).multipliedBy(0.6)
            make.bottom.equalTo(replayView).offset(-padding)
            make.top.equalTo(replayView).offset(padding)
        }
        
        favButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(textField.snp.right).offset(padding)
            make.bottom.equalTo(textField).offset(-padding)
            make.top.equalTo(textField).offset(padding)
        }
        
        reButton.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(favButton.snp.right)
            make.width.equalTo(favButton)
            make.bottom.equalTo(textField).offset(-padding)
            make.top.equalTo(textField).offset(padding)
            make.right.equalTo(replayView).offset(-padding)
        }
    }
    
    func setUpNav(_ animated: Bool){
        self.title = article?.title
        
        let image = UIImage(named: "ic_back")
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
}

extension ArticleViewController: UITextFieldDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let text = textField.text {
            BlogAPIs.postComment(bid: article!.id, uid: UserInfo.shared.user.uid, comment: text, success: { msg in
                if msg == "OK" {
                    textField.text = ""
                    print(self.comments.count)
                    self.tipWithMessage(msg: "评论成功")
                    BlogAPIs.getComments(bid: self.article!.id, success: { comments in
                        self.comments = comments
                        self.tableView.reloadData()
                    })
                }
                
            })
        }
        textField.resignFirstResponder()
        return true
    }
    
    @objc func keyBoardWillShow(notifi:NSNotification)
    {
        
        let keyBoardBounds = (notifi.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        let duration =  (notifi.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]as! NSNumber).doubleValue
        
        let deltaY = keyBoardBounds.size.height
        
        let animations:(() -> Void) = {
            
            self.replayView.transform = CGAffineTransform(translationX: 0,y: -deltaY)
        }
        
        if duration > 0 {
            let options = UIView.AnimationOptions(rawValue: UInt((notifi.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
    @objc func keyBoardWillHide(notifi:NSNotification)
    {
        
        let duration =  (notifi.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey]as! NSNumber).doubleValue
        
        
        let animations:(() -> Void) = {
            self.replayView.transform = CGAffineTransform.identity
            self.view.layoutIfNeeded()
        }
        
        if duration > 0 {
            let options = UIView.AnimationOptions(rawValue: UInt((notifi.userInfo?[UIResponder.keyboardAnimationCurveUserInfoKey] as! NSNumber).intValue << 16))
            
            UIView.animate(withDuration: duration, delay: 0, options:options, animations: animations, completion: nil)
        }else{
            animations()
        }
        
    }
}

extension ArticleViewController {
    func favorArticle(id: Int) {
        SolaSessionManager.solaSession(type: .post, url: BlogAPIs.getBlog, parameters: ["id": "\(id)"], success: { dict in
            guard let status = dict["status"] as? Int else {
                return
            }
            if status != 200 {
                if let msg = dict["msg"] as? String {
                    self.tipWithLabel(msg: "康食：" + msg)
                }
                return
            }
            self.favButton.isSelected = true
        }, failure: { _ in
            
        })
    }
}
