//
//  HomeHeadView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/19.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit


@objc protocol noticDelegate  {
    
    func clickNoticIndex(model:HomeNoticeModel)
}


class HomeHeadView: UIView {

    var silenceCarouselView:SilenceCarouselView?
    var noticeLabel : UILabel?
    weak var noticdelegate : noticDelegate?
    var noticeArray : Array<Any>?
    var noticeNum : Int?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Whit
        msubView()
        self.time .fire()
        self.noticeNum = 0
    }
    
    private func msubView() {
        silenceCarouselView = SilenceCarouselView()
        self.addSubview(silenceCarouselView!)
        noticeLabel = UILabel()
        noticeLabel?.isUserInteractionEnabled = true
        self.addSubview(noticeLabel!)
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(noticClickEvent))
        noticeLabel! .addGestureRecognizer(gesture)
        let  line = UIView()
        line.backgroundColor = lineColor
        self.addSubview(line);
        
        silenceCarouselView?.snp.makeConstraints({ (make) in
            make.left.top.equalTo(self)
            make.right.equalTo(self.snp.right)
            make.height.equalTo(Screen_width * 0.5)
        })
        
        noticeLabel?.snp.makeConstraints({ (make) in
            make.left.equalTo(self).offset(12)
            make.right.equalTo(self).offset(-5)
            make.top.equalTo(silenceCarouselView!.snp.bottom)
            make.height.equalTo(25)
        })
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self);
            make.top.equalTo(noticeLabel!.snp.bottom)
        }
    }
    
     /// 首页 banner 页面数据接口
     ///
     /// - Parameter bannerArray:  banner 数据
     func BannerIcons( _ bannerArray : Array<Any>){
        var imageArr = Array<Any>()
        for model in bannerArray {
            let model = model as! HomeBannerModel
            let imageStr = imageUrlString + ((model.imagesUrl)!)
            imageArr.append(imageStr)
        }
        
        self.silenceCarouselView?.setupimageArray(imageArr)
    }
    
    
    /// 首页公告页面接口
    ///
    /// - Parameter array: 公告数据
    func setupNoticeArray(_ array : Array<Any>){
        self.noticeArray = array
        if array.count != 0 {
            
            let model : HomeNoticeModel = self.noticeArray?.first as! HomeNoticeModel
            self.noticeLabel?.attributedText = NSMutableAttributedString().attributedString(imageName: "radio", textStr: model.title!, fontSize: 15.0, color: UIColor.black)
        }
    }
    
    
    lazy var time :Timer = {
        
        let tempTime = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(scrollViewAutoScroll) , userInfo: nil, repeats: true)
        
        return tempTime
    }()
    
    func scrollViewAutoScroll(){
        
        if (self.noticeArray != nil) {
            if self.noticeNum! < (self.noticeArray?.count)! {
                let model : HomeNoticeModel = self.noticeArray![self.noticeNum!] as! HomeNoticeModel
                self.noticeLabel?.attributedText = NSMutableAttributedString().attributedString(imageName: "radio", textStr: model.title!, fontSize: 15.0, color: UIColor.black)

                self.noticeNum? += 1
            }
            if (self.noticeNum! > (self.noticeArray?.count)! - 1)
            {
                self.noticeNum = 0
            }
        }
    
    }
    
    func noticClickEvent()  {
        if (self.noticeArray != nil) {
            if self.noticeNum! < (self.noticeArray?.count)! {
               let model : HomeNoticeModel = self.noticeArray![self.noticeNum!] as! HomeNoticeModel
                
                noticdelegate?.clickNoticIndex(model: model)
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
