//
//  FormView.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/11.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class FormView: UIView {
    
    var selectIndexs:[Int] = []
    var questionStr: String = ""
    var optionList: [String] = []
    
    var normalImage: UIImage = UIImage(named: "radio")!{
        didSet {
            for btn in btns {
                btn.setImage(normalImage, for: .normal)
            }
        }
    }

    var selectImage: UIImage = UIImage(named: "radioOn")!{
        didSet {
            for btn in btns {
                btn.setImage(selectImage, for: .selected)
            }
        }
    }
    
    private lazy var btns: [UIButton] = []
    private lazy var labels: [UILabel] = []
    private lazy var questionLabel: UILabel = {
        let label = UILabel()
        label.text = questionStr
        label.font = UIFont.systemFont(ofSize: 13)
        label.textColor = UIColor.gray
        return label
    }()
    
    private lazy var lastBtn = UIButton()
    
    init(frame: CGRect, questionStr: String, optionList: [String]) {
        super.init(frame: frame)
        self.questionStr = questionStr
        self.optionList = optionList
        
        setUpUI()
        remakeConstraints()
    }
    
    func setUpUI() {
        let num = optionList.count
        for i in 0..<num{
            let button = UIButton()
            button.setImage(normalImage, for: .normal)
            button.setImage(selectImage, for: .selected)
            button.addTarget(self, action: #selector(choose), for: .touchUpInside)
            btns.append(button)
            addSubview(button)
            
            let label = UILabel()
            label.text = optionList[i]
            label.font = UIFont.systemFont(ofSize: 13)
            labels.append(label)
            addSubview(label)
        }
        addSubview(questionLabel)
    }
    
    func remakeConstraints() {
        let margin: CGFloat = 15
        let padding: CGFloat = 10
        let num = optionList.count
        
        questionLabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(self).offset(margin)
            make.left.equalTo(self).offset(margin)
        }
        
        for i in 0..<num {
            btns[i].snp.makeConstraints { (make) -> Void in
                make.left.equalTo(self).offset(2 * margin)
            }
            
            labels[i].snp.makeConstraints { (make) -> Void in
                make.left.equalTo(btns[i].snp.right).offset(5)
                make.centerY.equalTo(btns[i])
            }
        }
        
        for i in 1..<num {
            btns[i].snp.makeConstraints { (make) -> Void in
                make.top.equalTo(btns[i - 1].snp.bottom).offset(padding)
            }
        }
        
        btns[0].snp.makeConstraints { (make) -> Void in
            make.top.equalTo(questionLabel.snp.bottom).offset(margin)
        }
        
        btns[num - 1].snp.makeConstraints { (make) -> Void in
            make.bottom.equalTo(self).offset(-margin)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension FormView {
    @objc func choose(sender: UIButton){
        let tag = sender.tag
        sender.isSelected = true
        lastBtn.isSelected = false
        lastBtn = sender
        selectIndexs.append(tag)
    }
}
