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
    var noticeArray : NSMutableArray?
    var noticeNum : Int?
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Whit
        setSubView()
        self.time .fire()
        self.noticeNum = 0
    }
    
    func setSubView() {
        self.silenceCarouselView = SilenceCarouselView()
        self.addSubview(self.silenceCarouselView!)
        self.noticeLabel = UILabel()
        self.noticeLabel?.isUserInteractionEnabled = true
        self.addSubview(self.noticeLabel!)
        let gesture = UITapGestureRecognizer.init(target: self, action: #selector(noticClickEvent))
        self.noticeLabel! .addGestureRecognizer(gesture)
        let  line = UIView()
        line.backgroundColor = lineColor
        self.addSubview(line);
        
        self.silenceCarouselView?.snp.makeConstraints({ (make) in
            make.left.top.right.equalTo(self)
            make.height.equalTo(Screen_width * 0.5)
        })
        
        self.noticeLabel?.snp.makeConstraints({ (make) in
            make.left.right.equalTo(self).offset(12);
            make.top.equalTo((self.silenceCarouselView?.snp.bottom)!)
            make.height.equalTo(25)
        })
        line.snp.makeConstraints { (make) in
            make.left.right.bottom.equalTo(self);
            make.top.equalTo((self.noticeLabel?.snp.bottom)!)
        }
    }
    
    public func BannerIcons( _ bannerArray : NSMutableArray){
        let imageArr = NSMutableArray()
        for model in bannerArray {
            let model = model as! HomeBannerModel
            let imageStr = imageUrlString + ((model.imagesUrl)!)
            imageArr.add(imageStr)
        }
        
        self.silenceCarouselView?.setupimageArray(imageArr as [AnyObject])
    }
    
    
    public func setupNoticeArray(_ array : NSMutableArray){
        self.noticeArray = array
        if array.count != 0 {
            let model : HomeNoticeModel = self.noticeArray?.firstObject as! HomeNoticeModel
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
