//
//  AboutViewController.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/22.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
class AboutViewController: UIViewController {
    let headImageView = UIImageView()
    let kangshiLable = UILabel()
    let banbenLable = UILabel()
    let last1Lable = UILabel()
    let last2Lable = UILabel()
    let last3Lable = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "关于康食"
        self.view.backgroundColor = .white
        
        headImageView.frame = CGRect(x: Device.width/2-40, y: 130, width: 80, height: 80)
        headImageView.image = UIImage(named: "touxiang")
        view.addSubview(headImageView)
        
        kangshiLable.frame = CGRect(x: Device.width/2-100, y: headImageView.frame.maxY + 50, width: 200, height: 40)
        kangshiLable.text = "康食kangshi"
        kangshiLable.font = UIFont.systemFont(ofSize: 30)
        kangshiLable.textColor = .black
        kangshiLable.textAlignment = .center
        view.addSubview(kangshiLable)
        
        banbenLable.frame = CGRect(x: Device.width/2-40, y: kangshiLable.frame.maxY+20, width: 80, height: 20)
        banbenLable.textAlignment = .center
        banbenLable.text = "版本：3.0"
        banbenLable.textColor = .gray
        banbenLable.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(banbenLable)
        
        last3Lable.frame = CGRect(x: Device.width/2-100, y: Device.height-50, width: 200, height: 20)
        last3Lable.textAlignment = .center
        last3Lable.text = "All Rights Reserved"
        last3Lable.textColor = .gray
        last3Lable.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(last3Lable)
        
        last2Lable.frame = CGRect(x: Device.width/2-200, y: Device.height-70, width: 400, height: 20)
        last2Lable.textAlignment = .center
        last2Lable.text = "Tianjin University & Tianjin Third Central Hospital"
        last2Lable.textColor = .gray
        last2Lable.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(last2Lable)
        
        last1Lable.frame = CGRect(x: Device.width/2-100, y: Device.height-90, width: 200, height: 20)
        last1Lable.textAlignment = .center
        last1Lable.text = "Copyright @ 2018-2019"
        last1Lable.textColor = .gray
        last1Lable.font = UIFont.systemFont(ofSize: 15)
        view.addSubview(last1Lable)
    }
}
