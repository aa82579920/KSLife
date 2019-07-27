//
//  LectureMsgTableViewCell.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/26.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class LectureMsgTableViewCell: UITableViewCell {

    private var lecture: LectureDetail?
    
    private lazy var lectureImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    
    private lazy var labelOne: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 16)
        label.sizeToFit()
        return label
    }()
    
    private lazy var labelTwo: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 14)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    convenience init(lecture: LectureDetail?) {
        self.init(style: .default, reuseIdentifier: "hhhhhhhh")
        self.lecture = lecture
        setUpData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        let margin: CGFloat = 20
        let padding: CGFloat = 5
        contentView.addSubview(lectureImage)
        lectureImage.snp.makeConstraints { make in
            make.top.equalTo(contentView).offset(margin)
            make.left.equalTo(contentView).offset(margin)
            make.bottom.equalTo(contentView).offset(-margin)
            make.height.equalTo(80)
            make.width.equalTo(lectureImage.snp.height)
        }
        
        contentView.addSubview(labelOne)
        labelOne.snp.makeConstraints { make in
            make.left.equalTo(lectureImage.snp.right).offset(margin)
            make.top.equalTo(lectureImage).offset(padding)
        }
        contentView.addSubview(labelTwo)
        labelTwo.snp.makeConstraints { make in
            make.bottom.equalTo(lectureImage)
            make.left.equalTo(labelOne)
        }
    }
    
    func setUpData() {
        if let lecture = lecture {
            labelOne.text = lecture.title
            labelTwo.text = "\(lecture.viewnum)人查看"
            lectureImage.sd_setImage(with: URL(string: lecture.cover), placeholderImage: UIImage(named: "noImg"))
        }
        
    }
}

class LectureSimpleTableViewCell: UITableViewCell {
    private lazy var labelOne: UILabel = {
        let label = UILabel()
        label.textColor = mainColor
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.sizeToFit()
        return label
    }()
    
    private lazy var labelTwo: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .right
        label.font = UIFont.systemFont(ofSize: 15)
        label.numberOfLines = 0
        label.sizeToFit()
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpUI()
    }
    
    convenience init(title: String, content: String) {
        self.init(style: .default, reuseIdentifier: title)
        labelOne.text = title
        labelTwo.text = content
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpUI() {
        let margin: CGFloat = 20
        let padding: CGFloat = 10
        
        contentView.addSubview(labelOne)
        labelOne.snp.makeConstraints { make in
            make.left.equalTo(contentView).offset(margin)
            make.top.equalTo(contentView).offset(padding)
        }
        contentView.addSubview(labelTwo)
        labelTwo.snp.makeConstraints { make in
            make.bottom.equalTo(contentView).offset(-margin)
            make.left.equalTo(labelOne)
        }
    }
}
