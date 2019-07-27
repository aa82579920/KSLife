//
//  ClassExtensions.swift
//  KSLife
//
//  Created by uareagay on 2019/4/22.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
import SwiftDate

extension UIImage {
    
    static func resizedImage(image: UIImage, scaledToSize newSize: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0);
        image.draw(in: CGRect(x: 0.0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return newImage.withRenderingMode(.alwaysOriginal)
    }
    
    static func resizedImage(image: UIImage, scaledToWidth newWidth: CGFloat) -> UIImage {
        let scaleRatio = newWidth / image.size.width
        let newHeight = image.size.height * scaleRatio
        let foo = UIImage.resizedImage(image: image, scaledToSize: CGSize(width: newWidth, height: newHeight))
        return foo
    }
    
    convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: .zero, size: size)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        guard let cgImage = image?.cgImage else { return nil }
        self.init(cgImage: cgImage)
    }
}

extension UIColor {
    
    public convenience init(hex6: UInt32, alpha: CGFloat = 1) {
        let divisor = CGFloat(255)
        let r = CGFloat((hex6 & 0xFF0000) >> 16) / divisor
        let g = CGFloat((hex6 & 0x00FF00) >>  8) / divisor
        let b = CGFloat( hex6 & 0x0000FF       ) / divisor
        self.init(red: r, green: g, blue: b, alpha: alpha)
    }
    
    convenience init(r: CGFloat, g: CGFloat, b: CGFloat) {
        self.init(red: r / 255.0, green: g / 255.0, blue: b / 255.0, alpha: 1.0)
    }
}



//自定义设置圆角
extension UIView {
    func addCorner(roundingCorners: UIRectCorner, cornerSize: CGSize) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: roundingCorners, cornerRadii: cornerSize)
        let cornerLayer = CAShapeLayer()
        cornerLayer.frame = bounds
        cornerLayer.path = path.cgPath
        layer.mask = cornerLayer
    }
}

extension UIButton {
    
    func setUpImageAndDownLableWithSpace(space: CGFloat){
        let imageSize = self.imageView!.frame.size;
        var titleSize = self.titleLabel!.frame.size;
        
        let labelWidth = self.titleLabel!.intrinsicContentSize.width;
        if (titleSize.width < labelWidth) {
            titleSize.width = labelWidth;
        }
        
        self.titleEdgeInsets = UIEdgeInsets(top: imageSize.height, left: -imageSize.width, bottom: -space, right: 0)
        
        self.imageEdgeInsets = UIEdgeInsets(top: -space, left: 0, bottom: 0, right: -titleSize.width)
    }
}

extension UIViewController {
    var isModal: Bool {
        if self.presentingViewController != nil {
            return true
        } else if self.navigationController?.presentingViewController?.presentedViewController == self.navigationController {
            return true
        } else if self.tabBarController?.presentingViewController is UITabBarController {
            return true
        }
        
        return false
    }
    
    func getNavbarHeight() -> CGFloat {
        return self.navigationController?.navigationBar.bounds.size.height ?? 0 + statusH
    }
    
    func getTabbarHeight() -> CGFloat {
        return self.tabBarController?.tabBar.bounds.size.height ?? 0
    }
    
    func tipWithMessage(msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        alert.view.backgroundColor = .lightGray
        self.present(alert, animated: true, completion: nil)
        self.perform(#selector(dismiss), with: alert, afterDelay: 2.0)
    }
    
    func tipWithLabel(msg: String, frame: CGRect = CGRect(x: screenW * 0.25, y: 500, width: screenW * 0.5, height: 30)) {
        let tiplabel = InsertLabel(frame: frame, textInsets: UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10))
        tiplabel.text = msg
        tiplabel.font = .systemFont(ofSize: 13)
        tiplabel.numberOfLines = 0
        tiplabel.backgroundColor = .lightGray
        tiplabel.layer.cornerRadius = 5
        tiplabel.layer.masksToBounds = true
        tiplabel.textAlignment = .center
        tiplabel.textColor = .white
        view.addSubview(tiplabel)
        tiplabel.layer.zPosition = .greatestFiniteMagnitude
        
        tiplabel.snp.makeConstraints { make in
            make.width.lessThanOrEqualTo(view).multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.top.equalTo(view).offset(screenH * 0.7)
            make.height.equalTo(30)
        }
        UIView.animate(withDuration: 3.0, animations: {
            tiplabel.alpha = CGFloat(0)
        }, completion: { _ in
            tiplabel.removeFromSuperview()
        })
    }
}

extension Date {
}

extension NSRegularExpression {
    convenience init(_ pattern: String) {
        do {
            try self.init(pattern: pattern)
        } catch {
            preconditionFailure("Illegal regular expression: \(pattern).")
        }
    }
    
    func matches(_ string: String) -> Bool {
        let range = NSRange(location: 0, length: string.utf16.count)
        return firstMatch(in: string, options: [], range: range) != nil
    }
    
    func matchesString(_ string: String) -> String {
        let range = NSRange(location: 0, length: string.utf16.count)
        let result = firstMatch(in: string, options: [], range: range)
        if let result = result {
            let star = result.range(at: 0).location
            let length = result.range(at: 0).length
            let index1 = string.index(string.startIndex, offsetBy: star)
            let index2 = string.index(string.startIndex, offsetBy: star + length)
            return String(string[index1..<index2])
        } else {
            return ""
        }
    }
    
}


extension String{
    /// MD5 加密字符串
    var MD5: String {
        let cStr = self.cString(using: .utf8);
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: 16)
        CC_MD5(cStr!,(CC_LONG)(strlen(cStr!)), buffer)
        let md5String = NSMutableString()
        for i in 0..<16 {
            md5String.appendFormat("%02x", buffer[i])
        }
        free(buffer)
        return md5String as String
    }
}

extension Date{
    static func getCurrentTime() -> String{
        let nowDate = NSDate()
        let interval = Int(nowDate.timeIntervalSince1970)
        return "\(interval)"
    }
    
    static func compareCurrntTime(timeStamp: TimeInterval) ->String{
        let zone = NSTimeZone.local
        let interval = zone.secondsFromGMT()
        
        let date = Date(timeIntervalSince1970: timeStamp)
        var timeInterval = date.addingTimeInterval(-TimeInterval(interval)).timeIntervalSinceNow
        timeInterval = -timeInterval
        var result: String

        if timeInterval < 60 {
            result = "刚刚"
        } else if Int(timeInterval/60) < 60 {
            result = String.init(format:"%@分",String(Int(timeInterval/60)))
        } else if Int((timeInterval/60)/60) < 24 {
            result = String.init(format:"%@时",String(Int((timeInterval/60)/60)))
        } else if Int((timeInterval/60)/60/24) < 30 {
            result = String.init(format:"%@天",String(Int((timeInterval/60)/60/24)))
        } else {
            let dateformatter = DateFormatter()
            dateformatter.dateFormat="一个月"
            result = dateformatter.string(from: date as Date)
        }
        return result
    }
}
