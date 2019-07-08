//
//  SendFlowerView.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/8.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
typealias FloBlock = (_ num: Int)->(Void)
class SendFlowerView: PopBaseView {
    private var titleLabel = UILabel()
    private let titleHeight: CGFloat = 50
    private var textField = UITextField()
    private var textStr = "请输入朵数"
    var num = 52
    var restNum = 99 {
        didSet {
            sureBtn.setTitle("确定(剩余\(restNum))朵", for: .normal)
        }
    }
    
    var block: FloBlock?
    var sureBtn = UIButton()
    
    override func addAnimate() {
        UIApplication.shared.keyWindow?.addSubview(self.initPopBackGroundView())
        self.isHidden = false
        
        sureBtn = UIButton(type: .custom)
        sureBtn.addTarget(self, action: #selector(sureSend), for: .touchUpInside)
        UIView.animate(withDuration:TimeInterval(defaultTime), animations: {
            self.WhiteView.frame = self.whiteViewEndFrame
        }) { (_) in
            self.cancelBtn.frame.origin.y = self.WhiteView.frame.maxY +  20
            self.cancelBtn.isHidden = false
            self.addWhiteVieSubView1()
        }
    }
    
    func addWhiteVieSubView1(){
        titleLabel = UILabel(frame: CGRect.init(x: 0, y: 0, width: WhiteView.frame.width, height: titleHeight))
        titleLabel.text = "选择送花\(restNum)朵"
        titleLabel.textAlignment = .center
        titleLabel.font = .systemFont(ofSize: 15, weight: .bold)
        titleLabel.textColor = .black
        WhiteView.addSubview(titleLabel)
        
        textField = UITextField(frame: CGRect.init(x: 20, y: titleHeight, width: WhiteView.frame.width - 40, height: WhiteView.frame.height * 0.3))
        textField.text = "\(restNum)"
        textField.placeholder = textStr
        textField.layer.masksToBounds = true
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5
        textField.backgroundColor = .white
        textField.alpha = 0.5
        textField.delegate = self
        textField.returnKeyType = .done
        textField.font = .systemFont(ofSize: 15)
        textField.addTarget(self, action: #selector(changNum), for: .editingChanged)
        WhiteView.addSubview(textField)
        
        sureBtn.frame = CGRect(x: 20, y: WhiteView.frame.height - 55, width: (WhiteView.frame.width - 40), height: 40)
        sureBtn.layer.masksToBounds = true
        sureBtn.layer.cornerRadius = 5
        sureBtn.backgroundColor = mainColor
        sureBtn.titleLabel?.font = .systemFont(ofSize: 14)
        sureBtn.setTitle("确定(剩余\(restNum))朵", for: .normal)
        sureBtn.setTitleColor(.white, for: .normal)
        WhiteView.addSubview(sureBtn)
    }
    
    override func tapBtnAndcancelBtnClick() {
        super.tapBtnAndcancelBtnClick()
        textField.text = "\(restNum)"
    }
    
    @objc func changNum(_ sender: UITextField) {
        if let str = sender.text {
            num = Int(str) ?? 0
            titleLabel.text = "选择送花\(num)朵"
            sureBtn.setTitle("确定(剩余\(restNum - num))朵", for: .normal)
        }
    }
    
    @objc func sureSend() {
        block!(num)
    }
}

extension SendFlowerView: UITextFieldDelegate{
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true);
        textField.resignFirstResponder;
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return validateNumber(str: string)
    }
    
    func validateNumber(str: String) -> Bool {
        var res = true
        if str == "" {
            return true
        }
        
        for i in str {
            if i < "0" || i > "9" {
                return false
            }
        }
        
        if (Int(textField.text!) ?? 0) * 10 + Int(str)! > restNum {
            res = false
        }
        
        return res
    }
    
    //监听return 按钮被点击
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.endEditing(true);
            textView.resignFirstResponder;
            return false;
        }
        return true;
    }
}
