//
//  HomeHeadCollectionReusableView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/17.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
class HomeHeadCollectionReusableView: UICollectionReusableView {
    //三个圆点的闭包回调
    var moreBtnBlock:(()->())?

    var recommadIcon :UIImageView?
    var recommandLabel : UILabel?
    var moreBtn : UIButton?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.recommadIcon = UIImageView()
        self .addSubview(self.recommadIcon!)
        self.recommandLabel = UILabel()
        self.addSubview(self.recommandLabel!)
        self.recommandLabel?.font = FONT(18)
        self.moreBtn = UIButton()
        self.addSubview(self.moreBtn!)
        self.moreBtn?.setImage(UIImage.init(named: "三个点"), for: UIControlState.normal)
        self.moreBtn?.addTarget(self, action: #selector(moreBtnClick), for: .touchUpInside)
        setupSubView()
    }
    
    func setupSubView(){
        
       self.recommadIcon?.snp.makeConstraints({ (make) in
        make.left.equalTo(self.snp.left).offset(15)
        make.top.equalTo(self)
        make.height.equalTo(25)
        make.width.equalTo(20)
       })
        
        self.recommandLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self.recommadIcon!.snp.right).offset(5)
            make.top.equalTo(self).offset(15)
            make.width.equalTo(150)
            make.height.equalTo(20)
        })
        
        self.moreBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(self).offset(15)
            make.right.equalTo(self.snp.right).offset(-20)
            make.width.height.equalTo(25)
            
        })
    }
    
    func moreBtnClick(){
        if self.moreBtnBlock != nil {
            self.moreBtnBlock!()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
