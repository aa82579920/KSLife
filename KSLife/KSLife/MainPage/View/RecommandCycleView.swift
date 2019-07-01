//
//  RecommandCycleView.swift
//  KSLife
//
//  Created by 毛线 on 2019/6/25.
//  Copyright © 2019 王春杉. All rights reserved.
//

import UIKit

class RecommandCycleView: CycleView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cycleCellID, for: indexPath)
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: imgUrls![indexPath.row % imgUrls!.count]), placeholderImage: UIImage(named: "scenery"))
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(cell.contentView)
        }
        let label = UILabel()
        label.backgroundColor = UIColor(hex6: 0x787D7B, alpha: 0.5)
        label.text = "两周内日打卡三道菜以上满七天可以获个性化食谱"
        label.textColor = .white
        label.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(cell.contentView)
            make.height.equalTo(cell.contentView).multipliedBy(0.2)
            make.width.equalTo(cell.contentView)
        }
        return cell
    }
}
