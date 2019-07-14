//
//  InsetLabel.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/1.
//  Copyright © 2019 王春杉. All rights reserved.
//

//import UIKit
//
//class InsertLabel: UILabel {
//
//    var textInsets: UIEdgeInsets = .zero
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//    }
//
//    convenience init(frame: CGRect, textInsets: UIEdgeInsets) {
//        self.init(frame: frame)
//        self.textInsets = textInsets
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
//        var rect = super.textRect(forBounds: bounds.inset(by: textInsets), limitedToNumberOfLines: numberOfLines)
//        rect.origin.x -= textInsets.left
//        rect.origin.y -= textInsets.top
//        rect.size.width += (textInsets.left + textInsets.right)
//        rect.size.height += (textInsets.top + textInsets.bottom)
//        return rect
//    }
//
//    override func drawText(in rect: CGRect) {
//        super.drawText(in: rect.inset(by: textInsets))
//    }
//
//}
