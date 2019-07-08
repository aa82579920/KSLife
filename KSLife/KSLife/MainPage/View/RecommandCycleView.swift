//
//  RecommandCycleView.swift
//  KSLife
//
//  Created by 毛线 on 2019/7/8.
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
    
    var names: [String] = []
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cycleCellID, for: indexPath)
        let imageView = UIImageView()
        imageView.sd_setImage(with: URL(string: imgUrls![indexPath.row % imgUrls!.count]), placeholderImage: UIImage(named: "noImg"))
        cell.contentView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) -> Void in
            make.edges.equalTo(cell.contentView)
        }
        let label = UILabel()
        label.backgroundColor = UIColor(hex6: 0x787D7B, alpha: 0.5)
        label.text = names[indexPath.row % names.count]
        label.textColor = .white
        label.textAlignment = .center
        cell.contentView.addSubview(label)
        label.snp.makeConstraints { (make) -> Void in
            make.centerY.equalTo(cell.contentView)
            make.height.equalTo(cell.contentView).multipliedBy(0.2)
            make.width.equalTo(cell.contentView)
        }
        return cell
    }
}
