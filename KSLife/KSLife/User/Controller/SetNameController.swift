//
//  SetNameController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/7/2.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
import  Alamofire
import SwiftyJSON
class SetNameController: UIViewController {
    var textField: UITextField!
    var button: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "设置昵称"
        self.view.backgroundColor = UIColor.white
        
        textField = UITextField(frame: CGRect(x: 20, y: navigationBarH + statusH + 10, width: Device.width-40, height: 30))
        //设置边框样式为圆角矩形
        textField.borderStyle = UITextField.BorderStyle.roundedRect
        textField.placeholder = "请输入昵称"
        textField.textAlignment = .left //水平左对齐
        textField.contentVerticalAlignment = .center  //垂直居中对齐
        textField.returnKeyType = .done
        textField.delegate = self
        self.view.addSubview(textField)
        
        button = UIButton(frame: CGRect(x: Device.width/2-20, y: textField.frame.maxY+5, width: 40, height: 30))
        //设置圆角
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 5.0
        button.backgroundColor = UIColor.blue
        button.tintColor = .white
        button.setTitle("确定", for: .normal)
        button.addTarget(self, action: #selector(queding), for: .touchUpInside)
        self.view.addSubview(button)
    }
    @objc func queding() {
        if textField.text != nil {
            let url = "http://kangshilife.com/EGuider/user/updateProfile?nickname=\(textField.text!)"
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
extension SetNameController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //收起键盘
        textField.resignFirstResponder()
        return true
    }
}
