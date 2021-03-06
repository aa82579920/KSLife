//
//  SetIntroController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/7/2.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
class SetIntroController: UIViewController {
    var textField: UITextField!
    private lazy var button: UIButton = {
        let btn = NavButton(frame: CGRect(x: Device.width/2-30, y: textField.frame.maxY+5, width: 60, height: 30), title: "确认")
        btn.addTarget(self, action: #selector(queding), for: .touchUpInside)
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置签名"
        self.view.backgroundColor = UIColor.white
        
        textField = UITextField(frame: CGRect(x: 20, y: navigationBarH + statusH + 10, width: Device.width-40, height: 30))
        //设置边框样式为圆角矩形
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "请输入个性签名"
        textField.textAlignment = .left //水平左对齐
        textField.contentVerticalAlignment = .center  //垂直居中对齐
        textField.returnKeyType = .done
        textField.delegate = self
        self.view.addSubview(textField)
        
        
        self.view.addSubview(button)
    }
    @objc func queding() {
        if textField.text != nil {
            let url = "http://kangshilife.com/EGuider/user/updateProfile?self_intro=\(textField.text!)"
            print(url)
            Alamofire.request(url, method: .post).responseJSON { response in
                switch response.result.isSuccess {
                case true:
                    //把得到的JSON数据转为数组
                    if let value = response.result.value {
                        let json = JSON(value)
                        
                    }
                case false:
                    print(response.result.error)
                }
                
            }
        }
        
    }
}
extension SetIntroController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
}
