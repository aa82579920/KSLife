//
//  DetailBlogViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/8.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import Alamofire

class DetailBlogViewController: UIViewController {
    
    private var tabBarH: CGFloat = 83
    
    var blog: Blog? {
        didSet {
            if let blog = blog {
                nameLabel.text = blog.userInfo.nickname
                timeLabel.text = blog.time
                detailLabel.text = blog.content
                for i in 0 ..< blog.images.count {
                    if let image = blog.images[i], image != "" {
                        let imageView = UIImageView()
                        imageView.sd_setImage(with: URL(string: image), placeholderImage: UIImage(named: "scenery"))
                        detailImages.append(imageView)
                    }
                }
                
                favButton.setTitle("\(blog.favor)个关注", for: .normal)
                reButton.setTitle("\(blog.comments?.count ?? 0)个回复", for: .normal)
                comments = blog.comments ?? []
                detailTableView.reloadData()
            }
        }
    }
    
    var comments: [Comment] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpUI()
        
        favButton.setUpImageAndDownLableWithSpace(space: 15)
        reButton.setUpImageAndDownLableWithSpace(space: 15)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyBoardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        tabBarH = (tabBarController?.tabBar.frame.height) ?? 0
        
        BlogAPIs.getComments(bid: self.blog!.id, success: { comments in
            self.comments = comments
            self.detailTableView.reloadData()
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setUpNav(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for image in detailImages {
            image.addCorner(roundingCorners: [.topRight, .topLeft, .bottomLeft, .bottomRight], cornerSize: CGSize(width: 10, height: 10))
        }
    }
    
    private let detailTableViewCellID = "detailTableViewCellID"
    
    private let itemH: CGFloat = 100
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.text = "王毛线|"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var timeLabel: UILabel = {
        let label = UILabel()
        label.text = "2019-05-01"
        label.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        label.textColor = UIColor.lightGray
        return label
    }()
    
    private lazy var detailLabel: UILabel = {
        let label = UILabel()
        label.text = "哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈"
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var detailImages: [UIImageView] = {
        let imageViews = [UIImageView]()
        for imageView in imageViews {
            imageView.image = UIImage(named: "scenery")
        }
        return imageViews
    }()
    
    private lazy var tableHeaderView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.white
        return view
    }()
    
    private lazy var footerLabel: UILabel = {
        let label = UILabel()
        label.text = "～亲，数据都加载完啦！～"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        return label
    }()
    
    private lazy var tableFooterView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    private lazy var detailTableView: UITableView = {[unowned self] in
        let tableView = UITableView(frame: self.view.bounds, style: .grouped)
        tableView.estimatedRowHeight = itemH
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .singleLine
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.register(CommentTableViewCell.self, forCellReuseIdentifier: detailTableViewCellID)
        return tableView
        }()
    
    
    private lazy var textField: UITextField = {
        let view = UITextField()
        view.borderStyle = .roundedRect
        view.placeholder = "发表回复"
        view.delegate = self
        return view
    }()
    
    private lazy var favButton: UIButton = {
        let btn = UIButton()
        btn.contentMode = .scaleAspectFit
        btn.setImage(UIImage(named: "guanzhu"), for: .normal)
        btn.setTitle("关注", for: .normal)
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
        btn.setTitle("2个回复", for: .normal)
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

extension DetailBlogViewController {
    @objc func fav() {
        favButton.isSelected = !favButton.isSelected
    }
}

extension DetailBlogViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count + 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath.row == 0) {
            let cell = UITableViewCell(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 20))
            cell.backgroundColor = UIColor.clear
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = detailTableView.dequeueReusableCell(withIdentifier: detailTableViewCellID, for: indexPath) as! CommentTableViewCell
            cell.backgroundColor = UIColor.white
            cell.selectionStyle = .none
            cell.comment = blog?.comments?[indexPath.row - 1]
            //        cell.layoutMargins = UIEdgeInsets.zero
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return tableHeaderView
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return tableFooterView
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 40
    }
    
}

//遵守UITextFieldDelegate
extension DetailBlogViewController: UITextFieldDelegate, UIScrollViewDelegate {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        textField.resignFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        textField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let text = textField.text
        BlogAPIs.postComment(bid: blog!.id, uid: UserInfo.shared.user.uid, comment: text ?? "", success: { msg in
            if msg == "OK" {
                textField.text = ""
                print(self.comments.count)
                self.tipWithMessage(msg: "评论成功")
                BlogAPIs.getComments(bid: self.blog!.id, success: { comments in
                    self.comments = comments
                    self.detailTableView.reloadData()
                })
            }
        })
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

extension DetailBlogViewController {
    
    func setUpNav(_ animated: Bool) {
        
        if isModal {
            let image = UIImage(named: "ic_back")
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(close))
        }
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(color: UIColor.white), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.tintColor = .black
    }
    
    @objc func close() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setUpUI(){
        replayView.addSubview(textField)
        replayView.addSubview(favButton)
        replayView.addSubview(reButton)
        
        tableHeaderView.addSubview(nameLabel)
        tableHeaderView.addSubview(timeLabel)
        tableHeaderView.addSubview(detailLabel)
        for view in detailImages {
            tableHeaderView.addSubview(view)
        }
        
        tableFooterView.addSubview(footerLabel)
        
        detailTableView.addSubview(tableHeaderView)
        detailTableView.addSubview(tableFooterView)
        
        view.addSubview(detailTableView)
        view.addSubview(replayView)
        
        remakeFooterConstraints()
        remakeHeaderViewConstraints()
        remakeReplayViewConstraints()
        remakeConstraints()
    }
    
    func remakeFooterConstraints() {
        footerLabel.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(tableFooterView)
            make.centerX.equalTo(tableFooterView)
        }
    }
    
    func remakeHeaderViewConstraints() {
        let margin: CGFloat = 20
        
        nameLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(tableHeaderView).offset(margin)
            make.left.equalTo(tableHeaderView).offset(margin)
        }
        
        timeLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(nameLabel)
            make.left.equalTo(nameLabel.snp.right).offset(margin)
        }
        
        detailLabel.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(nameLabel)
            make.right.equalTo(tableHeaderView).offset(-margin)
            make.top.equalTo(nameLabel.snp.bottom).offset(margin)
            if detailImages.count == 0 {
                make.bottom.equalTo(tableHeaderView).offset(-margin)
            }
        }
        
        if detailImages.count > 0 {
            detailImages[0].snp.makeConstraints { (make) -> Void in make.top.equalTo(detailLabel.snp.bottom).offset(margin)
            }
            detailImages[detailImages.count - 1].snp.makeConstraints { (make) -> Void in
                make.bottom.equalTo(tableHeaderView).offset(-margin)
            }
            for i in 0 ..< detailImages.count{
                
                detailImages[i].snp.makeConstraints { (make) -> Void in
                    var scale: CGFloat = 0
                    guard let image = detailImages[i].image else {
                        detailLabel.snp.makeConstraints { (make) -> Void in
                            make.bottom.equalTo(tableHeaderView).offset(-margin)
                        }
                        return
                    }
                    scale = image.size.height / image.size.width
                    
                    make.left.equalTo(nameLabel)
                    make.right.equalTo(tableHeaderView).offset(-margin)
                    make.height.equalTo(detailImages[i].snp.width).multipliedBy(scale)
                }
            }
        }
        
        if detailImages.count > 1 {
            for i in 1 ..< detailImages.count {
                detailImages[i].snp.makeConstraints { (make) -> Void in
                    make.top.equalTo(detailImages[i - 1].snp.bottom).offset(margin)
                    
                }
            }
        }
    }
    
    func remakeReplayViewConstraints() {
        let margin: CGFloat = 20
        let padding: CGFloat = 10
        
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
    
    func remakeConstraints() {
        tableHeaderView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
        }
        
        //        tableFooterView.snp.makeConstraints { (make) -> Void in
        //            make.width.equalTo(detailTableView)
        //        }
        
        detailTableView.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(view)
            make.top.equalTo(view)
            //            make.bottom.equalTo(view).offset(-(self.tabBarController?.tabBar.frame.height ?? 0))
        }
        
        replayView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(detailTableView.snp.bottom)
            make.height.equalTo(tabBarH)
            make.width.equalTo(view)
            make.bottom.equalTo(view)
        }
    }
}
