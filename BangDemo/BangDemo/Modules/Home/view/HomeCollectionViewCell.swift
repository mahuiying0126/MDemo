//
//  HomeCollectionViewCell.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/11.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
class HomeCollectionViewCell: UICollectionViewCell {
    
    var homeImage : UIImageView?
    var homeTitle : UILabel?
    var homeCount : UILabel?
    var homePrice : UILabel?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = lineColor.cgColor
     
        setupCollectionView()
    }
    

    
    func setupCollectionView() {
        homeImage = UIImageView()
        
        self.addSubview(homeImage!)
        homeTitle = UILabel()
        homeTitle?.font = FONT(15)
        self.addSubview(homeTitle!)
        homeCount = UILabel()
        homeCount?.font = FONT(13)
        homeCount?.textAlignment = .right
        homePrice?.textColor = UIColor.gray
        self.addSubview(homeCount!)
        homePrice = UILabel()
        homePrice?.font = FONT(13)
        homePrice?.textColor = UIColor.gray
        self.addSubview(homePrice!)
        
        homeImage?.snp.makeConstraints({ (make) in
            make.top.equalTo(10)
            make.left.equalTo(10)
            make.right.equalTo(self.snp.right).offset(-10)
            make.height.equalTo(homeImage!.snp.width).multipliedBy(180.0/380)
        })
        
        homeTitle?.snp.makeConstraints({ (make) in
            make.left.equalTo(homeImage!)
            make.top.equalTo((homeImage?.snp.bottom)!).offset(10)
            make.right.equalTo(self).offset(-3)
            make.height.equalTo(20)
            
        })
        
        homePrice?.snp.makeConstraints({ (make) in
            make.left.equalTo(homeTitle!)
            make.bottom.equalTo(self).offset(-3)
            make.width.equalTo(self.snp.width).multipliedBy(0.3)
        })
        homeCount?.snp.makeConstraints({ (make) in
            make.left.equalTo((homePrice?.snp.right)!)
            make.right.equalTo(homeImage!)
            make.top.bottom.equalTo(homePrice!)
            
        })
        
    }
    
    /// 填充 cell 数据
    ///
    /// - Parameter model:  cell 的 mode
    func cellForModel(model:HomeCourseModel) {
        
        let url = URL(string: imageUrlString+(model.mobileLogo)!)!
        homeImage?.af_setImage(withURL: url,placeholderImage:UIImage(named:"加载中"))
        if  (model.currentPrice == nil)  {
           
            self.homePrice?.attributedText = NSMutableAttributedString().attributedString(imageName: "标签", textStr: "免费", fontSize: 13.0, color: UIColor.orange)
        }else{
            self.homePrice?.text = String.init(format: "¥ %.2f", Float(model.currentPrice!)!)
        }
        
        self.homeTitle?.text = model.courseName
        
        self.homeCount?.text = ("播放量:") + (model.playCount!) as String;
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
