//
//  DetailTopBaseView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/23.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

@objc protocol DetailTopBaseViewDelegate {
    func topBaseViewBackVsPlay(tage: Int)
}

class DetailTopBaseView: UIView {

    var backGroundImage : UIImageView?
    var playButton : UIButton?
    var goBackBtn : UIButton?
    var shadeView : UIView?
    weak var topDelegate : DetailTopBaseViewDelegate!
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColorFromRGB(0xf7f7f7)
        setBaseViewLayout()
    }
    
    func setBaseViewLayout()  {
        backGroundImage = UIImageView()
        self.addSubview(backGroundImage!)
        shadeView = UIView()
        shadeView?.backgroundColor = ColorFromRGB(0, 0, 0, 0.6)
        self.addSubview(shadeView!)
        goBackBtn = UIButton()
        goBackBtn?.tag = 1
        goBackBtn?.addTarget(self, action: #selector(goBackVsPlayView(sender:)), for: .touchUpInside)
        goBackBtn?.setImage(UIImage.init(named: "返回"), for: .normal)
        shadeView?.addSubview(goBackBtn!)
        playButton = UIButton()
        playButton?.addTarget(self, action: #selector(goBackVsPlayView(sender:)), for: .touchUpInside)
        playButton?.tag = 2
        playButton?.setImage(UIImage.init(named: "播放按钮"), for: .normal)
        shadeView?.addSubview(playButton!)
        
        backGroundImage?.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(self);
            
        })
        shadeView?.snp.makeConstraints({ (make) in
            make.left.right.top.bottom.equalTo(self)
        })
        
        goBackBtn?.snp.makeConstraints({ (make) in
            make.left.equalTo(12)
            make.top.equalTo(24)
            make.width.height.equalTo(25)
        })
        
        playButton?.snp.makeConstraints({ (make) in
            make.center.equalTo(self)
            make.width.height.equalTo(self).multipliedBy(0.5)
        })
        
        
    }
    
    func setImageUrl(imageUrl:String)  {
        
        self.backGroundImage?.af_setImage(withURL: URL.init(string: imageUrl)!,placeholderImage:UIImage.init(named: "加载中"))
    }
    
    @objc  func goBackVsPlayView(sender:UIButton)  {
        
        if self.topDelegate != nil{
            self.topDelegate?.topBaseViewBackVsPlay(tage: sender.tag)
        }
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
