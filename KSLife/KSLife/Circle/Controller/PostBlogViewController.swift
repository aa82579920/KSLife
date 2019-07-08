//
//  PostBlogViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/8.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

typealias BlogBlock = ()->(Void)

class PostBlogViewController: PhotoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpUI()
        remakeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavBtn()
    }
    
    var block: BlogBlock?
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.text = "发布养食圈动态每次赠送1鲜花（每日上限两次）"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = mainColor
        return label
    }()
    
    private lazy var placeholderLabel: UILabel = {
        let label = UILabel()
        label.isEnabled = false
        label.backgroundColor = UIColor.clear
        label.textColor = UIColor.lightGray
        label.text = "分享你的动态..."
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        return label
    }()
    
    private lazy var textView: UITextView = {[unowned self] in
        let view = UITextView()
        view.delegate = self
        view.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        return view
        }()
    
    private var photoImages: [UIImageView] = []
    private var deleteBtns: [UIButton] = []
    private var images: [UIImage] = [] {
        didSet {
            refreshImage()
        }
    }
    
    private var imageUrls: [String] = []
    
    private lazy var helpLabel: UILabel = {
        let label = UILabel()
        label.text = "评论内容200字以内，建议采用直板图，最多能上传3张图片（jpg/jpeg/gif）jpg/jpeg/gif，单张图片大小不得超过3M"
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        return label
    }()
    
    override func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        super.imagePickerController(picker, didFinishPickingMediaWithInfo: info)
        let image = info[UIImagePickerController.InfoKey.editedImage] as! UIImage
        images.append(image)
        upload(image: image, success: { url in
            print(url)
            self.imageUrls.append(url)
        })
    }
    
    func refreshImage() {
        for i in 0..<images.count {
            photoImages[i].isHidden = false
            photoImages[i].image = images[i]
            photoImages[i].contentMode = .scaleToFill
            deleteBtns[i].isHidden = false
        }
        
        if (images.count <= 2) {
            UIWindow.animate(withDuration: 0.2, animations: {
                let index = self.images.count
                self.photoImages[index].isHidden = false
                self.photoImages[index].contentMode = .center
                self.photoImages[index].image = UIImage(named: "add")
            })
        }
        
        if (images.count < 2) {
            for i in images.count+1..<3 {
                photoImages[i].isHidden = true
            }
        }
        
        for i in images.count..<3 {
            deleteBtns[i].isHidden = true
        }
    }
}

extension PostBlogViewController {
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deliver() {
        self.navigationController?.popViewController(animated: true)
        let text = textView.text!
        postBlog(uid: UserInfo.shared.user.uid, content: text, imageUrls: imageUrls)
        block!()
    }
    
    @objc func deleteImg(sender: UIButton) {
        images.remove(at: sender.tag)
        imageUrls.remove(at: sender.tag)
        //        photoImage.contentMode = .center
        //        photoImage.image = UIImage(named: "add")
        //        deleteBtn.isHidden = true
    }
    
}

//TextField输入长度限制
extension PostBlogViewController: UITextViewDelegate {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for view in view.subviews {
            if (view.isKind(of: UITextView.self)) {
                view.resignFirstResponder()
            }
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (textView.text.count == 0) {
            placeholderLabel.text = "分享你的动态..."
        } else {
            placeholderLabel.text = ""
        }
    }
    
    func textView(_ textView: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textView == self.textView) {
            if (range.length == 1 && string.count == 0){
                return true
            } else if (self.textView.text!.count >= 200) {
                self.textView.text = String(textView.text!.prefix(200))
                return false
            }
        }
        return true
    }
    
    func textViewShouldReturn(_ textView: UITextField) -> Bool {
        textView.resignFirstResponder()
        return true
    }
}

//Autolayout
extension PostBlogViewController {
    
    func setUpUI() {
        view.addSubview(tipLabel)
        view.addSubview(textView)
        view.addSubview(helpLabel)
        view.addSubview(placeholderLabel)
        addImageView()
    }
    
    func addImageView() {
        for i in 0..<3 {
            let image = UIImageView()
            image.layer.borderWidth = 1
            image.layer.borderColor = UIColor.lightGray.cgColor
            image.contentMode = .center
            image.image = UIImage(named: "add")
            let ges = UITapGestureRecognizer(target: self, action: #selector(tapAvatar))
            image.addGestureRecognizer(ges)
            image.isUserInteractionEnabled = true
            view.addSubview(image)
            photoImages.append(image)
            let btn = UIButton()
            btn.setImage(UIImage(named: "scIcs"), for: .normal)
            btn.tag = i
            btn.contentMode = .center
            btn.addTarget(self, action: #selector(deleteImg), for: .touchUpInside)
            btn.backgroundColor = .lightGray
            btn.isHidden = true
            view.addSubview(btn)
            deleteBtns.append(btn)
            image.addSubview(btn)
        }
        for i in 1..<3 {
            photoImages[i].isHidden = true
        }
    }
    
    func setUpNavBtn() {
        let leftBtn = NavButton(frame: CGRect(x: 0, y: 5, width: 80, height: 30), backgroundColor: UIColor.white, titleColor: UIColor.black, title: "取消")
        leftBtn.cardRadius = 5
        leftBtn.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        
        let rightBtn = NavButton(frame: CGRect(x: 0, y: 5, width: 80, height: 30), backgroundColor: mainColor, titleColor: UIColor.white, title: "发表")
        rightBtn.cardRadius = 5
        rightBtn.addTarget(self, action: #selector(deliver), for: .touchUpInside)
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: leftBtn)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: rightBtn)
    }
    
    func remakeConstraints() {
        let margin: CGFloat = 50
        
        tipLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(view).offset(statusH + navigationBarH)
            make.left.equalTo(view).offset(10)
            make.right.equalTo(view).offset(-10)
            make.height.equalTo(30)
        }
        
        placeholderLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textView).offset(8)
            make.left.equalTo(textView).offset(5)
            make.right.equalTo(textView)
        }
        
        textView.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(tipLabel.snp.bottom)
            make.left.equalTo(tipLabel)
            make.right.equalTo(tipLabel)
        }
        
        helpLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(photoImages[0].snp.bottom).offset(10)
            make.left.equalTo(tipLabel)
            make.right.equalTo(tipLabel)
            make.bottom.equalTo(view).offset(-30)
        }
        
        for i in 0..<3 {
            photoImages[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(textView.snp.bottom).offset(20)
                make.width.equalTo(view).multipliedBy(0.27)
                make.height.equalTo(photoImages[i].snp.width).multipliedBy(2)
            }
            
            deleteBtns[i].snp.makeConstraints { (make) -> Void in
                make.width.equalTo(photoImages[i])
                make.height.equalTo(photoImages[i]).multipliedBy(0.2)
                make.bottom.equalTo(photoImages[i])
            }
        }
        
        photoImages[0].snp.makeConstraints { (make) -> Void in
            make.left.equalTo(tipLabel)
        }
        
        photoImages[1].snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(tipLabel)
        }
        
        photoImages[2].snp.makeConstraints { (make) -> Void in
            make.right.equalTo(tipLabel)
        }
        
    }
    
}

extension PostBlogViewController {
    func postBlog(uid: String, content: String, cityId: Int? = nil, cityName: String? = nil, time: String? = nil, imageUrls: [String]?) {
        var para: [String: String] = ["uid": uid, "content": content, "time": Date.getCurrentTime()]
        let key = ["image0", "image1", "image2"]
        if let urls = imageUrls {
            for i in 0 ..< urls.count {
                para[key[i]] = urls[i]
            }
        }
        SolaSessionManager.solaSession(type: .post, url: BlogAPIs.postBlog, parameters: para, success: { dict in
            print(dict)
        }, failure: { _ in
            
        })
    }
    func upload(image: UIImage, success: @escaping (String) -> Void){
        SolaSessionManager.upload(dictionay: ["image": image], url: BlogAPIs.upload, method: .post, progressBlock: nil, success: { dict in
            guard let data = dict["data"] as? [String: Any], let url = data["url"] as? String else {
                return
            }
            success(url)
        }, failure: { error in
            print(error)
        })
    }
}
