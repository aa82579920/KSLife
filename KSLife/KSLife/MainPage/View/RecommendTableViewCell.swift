//
//  RecommendTableViewCell.swift
//  KSLife
//
//  Created by uareagay on 2019/4/28.
//  Copyright © 2019 cn.edu.twt. All rights reserved.
//

import UIKit
// 用来初始化cell时传递信息
struct ArticlesInfoCell {
    static var articles: HomeArticles!
    static var index: Int!
}
// 主编推荐cell
class RecommendTableViewCell: UITableViewCell {

    @IBOutlet weak var imgView: UIImageView!
    @IBOutlet weak var titleLable: UILabel!
    @IBOutlet weak var popularLabel: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        titleLable.sizeToFit()
        let a = titleLable.sizeThatFits(CGSize(width: 0, height: CGFloat.greatestFiniteMagnitude))
        print(a)
        
        self.titleLable.text = ArticlesInfoCell.articles.data[ArticlesInfoCell.index].title
        self.imgView.sd_setImage(with: URL(string: "\(ArticlesInfoCell.articles.data[ArticlesInfoCell.index].imageUrl)"))
        self.popularLabel.text = "人气 \(ArticlesInfoCell.articles.data[ArticlesInfoCell.index].favor)"
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
