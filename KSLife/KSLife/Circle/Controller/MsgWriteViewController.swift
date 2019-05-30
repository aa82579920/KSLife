//
//  MsgWriteViewController.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/8.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class MsgWriteViewController: PhotoViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.white
        setUpUI()
        remakeConstraints()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setUpNavBtn()
    }
    
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
    
    private lazy var deleteBtn: UIButton = {
       let btn = UIButton()
        btn.setImage(UIImage(named: "scIcs"), for: .normal)
        btn.contentMode = .center
        btn.addTarget(self, action: #selector(deleteImg), for: .touchUpInside)
        btn.backgroundColor = .lightGray
        btn.isHidden = true
        return btn
    }()
    
    private lazy var photoImage: UIImageView = {
        let view = UIImageView()
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.contentMode = .center
        view.image = UIImage(named: "add")
        let ges = UITapGestureRecognizer(target: self, action: #selector(tapAvatar))
        view.addGestureRecognizer(ges)
        view.isUserInteractionEnabled = true
        return view
    }()
    
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
        let image = info[UIImagePickerController.InfoKey.editedImage]
        photoImage.image = image as! UIImage
        photoImage.contentMode = .scaleToFill
        deleteBtn.isHidden = false
    }
}

extension MsgWriteViewController {
    @objc func cancel() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deliver() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func deleteImg() {
        photoImage.contentMode = .center
        photoImage.image = UIImage(named: "add")
        deleteBtn.isHidden = true
    }
    
}

//TextField输入长度限制
extension MsgWriteViewController: UITextViewDelegate {
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
extension MsgWriteViewController {
    
    func setUpUI() {
        view.addSubview(tipLabel)
        view.addSubview(textView)
        view.addSubview(photoImage)
        view.addSubview(helpLabel)
        view.addSubview(placeholderLabel)
        photoImage.addSubview(deleteBtn)
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
        
        photoImage.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(textView.snp.bottom).offset(20)
            make.left.equalTo(tipLabel)
           make.width.equalTo(view).multipliedBy(0.3)
            make.height.equalTo(photoImage.snp.width).multipliedBy(2)
        }
        
        helpLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(photoImage.snp.bottom).offset(10)
            make.left.equalTo(tipLabel)
            make.right.equalTo(tipLabel)
            make.bottom.equalTo(view).offset(-30)
        }
        
        deleteBtn.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(photoImage)
            make.height.equalTo(photoImage).multipliedBy(0.2)
            make.bottom.equalTo(photoImage)
        }
        
    }
    
}
