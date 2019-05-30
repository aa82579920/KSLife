//
//  DottedLineView.swift
//  KSLife
//
//  Created by uareagay on 2019/4/25.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class DottedLineView: UIView {

    static let lineLength: CGFloat = 4.0

    override func draw(_ rect: CGRect) {
        let currentContext = UIGraphicsGetCurrentContext()
        //currentContext?.setLineCap(CGLineCap.square)
        currentContext?.setStrokeColor(UIColor.gray.cgColor)
        currentContext?.setLineWidth(2.0)
        currentContext?.move(to: CGPoint(x: 0, y: 0))
        currentContext?.addLine(to: CGPoint(x: 0, y: DottedLineView.lineLength))
        currentContext?.move(to: CGPoint(x: 0, y: DottedLineView.lineLength*2))
        currentContext?.addLine(to: CGPoint(x: 0, y: DottedLineView.lineLength*3))
        currentContext?.move(to: CGPoint(x: 0, y: DottedLineView.lineLength*4))
        currentContext?.addLine(to: CGPoint(x: 0, y: DottedLineView.lineLength*5))
        currentContext?.move(to: CGPoint(x: 0, y: DottedLineView.lineLength*6))
        currentContext?.addLine(to: CGPoint(x: 0, y: DottedLineView.lineLength*7))
        //currentContext?.setLineDash(phase: 0, lengths: [3, 1])
        //currentContext?.drawPath(using: CGPathDrawingMode.stroke)
        currentContext?.strokePath()
    }


}
