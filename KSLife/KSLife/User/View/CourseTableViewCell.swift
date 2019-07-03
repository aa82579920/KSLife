//
//  CourseTableViewCell.swift
//  KSLife
//
//  Created by 王春杉 on 2019/5/25.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit
// 课程cell
class CourseTableViewCell: UITableViewCell {
    let headImageView = UIImageView()
    let nameLable = UILabel()
    let timeImageView = UIImageView()
    let timeLable = UILabel()
    let stateLable = UILabel()
    let doctorLable = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    convenience init(index: Int, type: Int) {
        self.init(style: .default, reuseIdentifier: "CourseTableViewCell")
        let padding: CGFloat = 20
        
        headImageView.frame = CGRect(x: padding, y: padding, width: 50, height: 50)
        headImageView.layer.masksToBounds = true
        headImageView.layer.cornerRadius = 10
        contentView.addSubview(headImageView)
        
        nameLable.frame = CGRect(x: headImageView.frame.maxX + padding, y: padding, width: Device.width*3/4, height: 25)
        nameLable.font = UIFont.systemFont(ofSize: 18)
        
        nameLable.textColor = .black
        contentView.addSubview(nameLable)
        
        timeImageView.frame = CGRect(x: nameLable.frame.minX, y: nameLable.frame.maxY + 10, width: 20, height: 20)
        timeImageView.image = UIImage(named: "duigoulan")
        timeImageView.layer.masksToBounds = true
        timeImageView.layer.cornerRadius = 10
        contentView.addSubview(timeImageView)
        
        timeLable.frame = CGRect(x: timeImageView.frame.maxX + 5, y: nameLable.frame.maxY + 10, width: Device.width/5, height: 20)
        timeLable.textColor = .gray
        timeLable.font = UIFont.systemFont(ofSize: 16)
        contentView.addSubview(timeLable)
        
        stateLable.frame = CGRect(x: timeLable.frame.maxX + 5, y: nameLable.frame.maxY + 10, width: Device.width/8, height: 20)
        stateLable.textColor = .gray
        stateLable.font = UIFont.systemFont(ofSize: 16)
        stateLable.text = "未完成"
        contentView.addSubview(stateLable)
        
        doctorLable.frame = CGRect(x: stateLable.frame.maxX + 5, y: nameLable.frame.maxY + 10, width: Device.width/5*2, height: 20)
        doctorLable.textColor = .gray
        doctorLable.font = UIFont.systemFont(ofSize: 16)
        doctorLable.text = "医生: \(CourseInfo.courseInfo.enroll[index].doctor!)"
        contentView.addSubview(doctorLable)
        
        if type == 0 {
            nameLable.text = "\(CourseInfo.courseInfo.enroll[index].title!)"
            headImageView.sd_setImage(with: URL(string: "\(CourseInfo.courseInfo.enroll[index].cover!)"))
            timeLable.text = calcuTime(currentTime: CourseInfo.courseInfo.enroll[index].duration!)
        }
    }
    func calcuTime(currentTime: Int) -> String {
        //一个小算法，来实现00：00这种格式的播放时间
        let all:Int = Int(currentTime)
        let m:Int=all % 60
        let f:Int=Int(all/60)
        var time:String=""
        if f<10{
            time="00:0\(f):"
        }else {
            time="00:\(f)"
        }
        if m<10{
            time+="0\(m)"
        }else {
            time+="\(m)"
        }
        return time
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
