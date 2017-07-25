//
//  CoursePackageCollectionViewCell.swift
//  BangDemo
//
//  Created by yizhilu on 2017/7/18.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class CoursePackageCollectionViewCell: UICollectionViewCell {
    
    /** *课程包button */
    var packageItem : UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        packageItem = UIButton()
        self.contentView.addSubview(packageItem!)
        packageItem?.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(self.contentView)
        })
        packageItem?.setImage(MIMAGE("course-n-i"), for: .normal)
        packageItem?.setImage(MIMAGE("course-s-i"), for: .selected)
        packageItem?.setTitleColor(UIColor.darkGray, for: .normal)
        packageItem?.setTitleColor(navColor, for: .selected)
        packageItem?.titleLabel?.numberOfLines = 2
        packageItem?.titleLabel?.font = FONT(15)
        packageItem?.titleLabel?.textAlignment = .left
        packageItem?.setBackgroundImage(MIMAGE("course-n-b"), for: .normal)
        packageItem?.setBackgroundImage(MIMAGE("course-s-b"), for: .selected)
        packageItem?.titleEdgeInsets = .init(top: 0, left: 15, bottom: 0, right: 0)
        packageItem?.imageEdgeInsets = .init(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func cellModel(model : DetailCoursePackageModel)  {
        self.packageItem?.isSelected = model.isSelect
        self.packageItem?.setTitle(model.name, for: .normal)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
