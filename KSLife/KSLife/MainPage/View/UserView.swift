//
//  UserView.swift
//  KSLife
//
//  Created by uareagay on 2019/4/28.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit

class UserView: UIView {


    @IBOutlet weak var helloLabel: UILabel!
    
    @IBOutlet weak var locationImgBtn: UIButton!
    
    @IBOutlet weak var locationBtn: UIButton!
    
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var messageBtn: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        helloLabel.text = "ashjcfh"


    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
