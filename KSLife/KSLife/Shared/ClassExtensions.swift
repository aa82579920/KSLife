//
//  ClassExtensions.swift
//  KSLife
//
//  Created by uareagay on 2019/4/22.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

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
        self.perform(#selector(dismiss), with: alert, afterDelay: 3.0)
    }

    func tipWithLabel(msg: String, frame: CGRect = CGRect(x: screenW * 0.25, y: 500, width: screenW * 0.5, height: 30)) {
       let tiplabel = UILabel(frame: frame)
        tiplabel.text = msg
        tiplabel.font = .systemFont(ofSize: 12)
        tiplabel.numberOfLines = 0
        tiplabel.backgroundColor = .lightGray
        tiplabel.layer.cornerRadius = 5
        tiplabel.layer.masksToBounds = true
        tiplabel.textAlignment = .center
        tiplabel.textColor = .white
        self.view.addSubview(tiplabel)
        
        UIView.animate(withDuration: 3.0, animations: {
            tiplabel.alpha = CGFloat(0)
        }, completion: { _ in
            tiplabel.removeFromSuperview()
        })
    }
}

extension Date {
    func getDay() -> Int{
        let calendar = Calendar.current
        let com = calendar.dateComponents([.year,.month,.day], from: self)
        return com.day ?? 0
    }
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
}
