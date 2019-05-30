//
//  CheckBoxView.swift
//  KSLife
//
//  Created by 毛线 on 2019/5/11.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class CheckBoxView: FormView {
    
    override init(frame: CGRect, questionStr: String, optionList: [String]) {
        super.init(frame: frame, questionStr: questionStr, optionList: optionList)
        normalImage = UIImage(named: "checkbox")!
        selectImage = UIImage(named: "checkboxOn")!
    }
    
    override func choose(sender: UIButton) {
        let tag = sender.tag
        sender.isSelected = true
        selectIndexs.append(tag)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
