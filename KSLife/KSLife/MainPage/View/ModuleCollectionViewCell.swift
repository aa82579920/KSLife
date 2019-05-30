//
//  ModuleCollectionViewCell.swift
//  KSLife
//
//  Created by uareagay on 2019/4/27.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class ModuleCollectionViewCell: UICollectionViewCell {
    var imageView: UIImageView!
    var titleLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
        imageView = UIImageView()
        titleLabel = UILabel()

        let imageWidth: CGFloat = 40
        imageView.frame = CGRect(x: (self.frame.width-imageWidth)/2, y: 5, width: imageWidth, height: imageWidth)
        titleLabel.frame = CGRect(x: 0, y: imageWidth + 10, width: frame.width, height: 20)
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: UIFont.Weight.regular)
        titleLabel.textColor = .gray
        titleLabel.textAlignment = .center
        self.addSubview(imageView)
        self.addSubview(titleLabel)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
