//
//  ScoreView.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/12.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class ScoreView: UIView {

    private lazy var titileLabel: UILabel = {
        let label = UILabel()
        label.text = "*今日膳食得分*"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.black
        return label
    }()
    
    private lazy var queryBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(named: "query"), for: .normal)
        btn.addTarget(self, action: #selector(clickQuery), for: .touchUpInside)
        return btn
    }()
    
    private var popView: PopView?
    
    private lazy var tipLabel: UILabel = {
        let label = UILabel()
        label.text = "每天录入不少于三条 奖励1鲜花，每日限一次奖励"
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = mainColor
        return label
    }()
    
    private lazy var scoreLabel: UILabel = {
        let label = UILabel()
        label.text = "0.0"
        label.font = UIFont.systemFont(ofSize: 40)
        label.textColor = UIColor.red
        return label
    }()
    
    var addDishBtn: UIButton = {
        let button = UIButton()
        button.setBackgroundImage(UIImage(named: "adding"), for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        addSubview(titileLabel)
        addSubview(queryBtn)
        addSubview(tipLabel)
        addSubview(scoreLabel)
        addSubview(addDishBtn)
        remakeConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func clickQuery() {
        let point = CGPoint(x: queryBtn.center.x, y: queryBtn.frame.origin.y + queryBtn.frame.height)
        popView = PopView(origin: point, width: 180, height: 100, color: mainColor, superView: self)
        popView?.popView()
    }
    
    func remakeConstraints() {
        let padding: CGFloat = 10
        titileLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(self).offset(padding*2)
        }
        queryBtn.snp.makeConstraints { (make) -> Void in
            make.left.equalTo(titileLabel.snp.right).offset(padding)
            make.top.equalTo(titileLabel)
            make.bottom.equalTo(titileLabel)
            make.width.equalTo(queryBtn.snp.height)
        }
        tipLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(titileLabel.snp.bottom).offset(padding)
        }
        scoreLabel.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(tipLabel.snp.bottom).offset(padding)
        }
        addDishBtn.snp.makeConstraints { (make) -> Void in
            make.centerX.equalTo(self)
            make.top.equalTo(scoreLabel.snp.bottom).offset(padding)
            make.height.equalTo(50)
            make.width.equalTo(60)
        }
    }

}
