//
//  DetailTopToolView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/23.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit


@objc protocol topButtonClickDelegate {
    func collectionAndDownClick(buttonTag:Int)
    func threeSegmentBtn(segmentIndex: Int)
}


class DetailTopToolView: UIView {

    var collectionBtn : UIButton?
    weak var topViewButtonDelegate : topButtonClickDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = lineColor
        setBaseViewLayout()
    }
    
    
    
    func setBaseViewLayout()  {
        let btnNormalIcons :Array = ["离线下载","收藏","分享"]
        let btnSelectedIcons :Array = ["离线下载","已收藏","分享"]
        
        for i in 0 ..< btnNormalIcons.count{
            
            let btn = UIButton().buttonTitle(title: btnNormalIcons[i], image: btnNormalIcons[i], selectImage: btnSelectedIcons[i], backGroundColor: Whit, Frame: CGRect.init(x: Screen_width / 3 * CGFloat(i) , y: 0, width: Screen_width/3 - CGFloat(1)  , height: 40))
            btn.tag = i
            btn.setTitleColor(UIColor.gray, for: .normal)
            btn.setTitleColor(navColor, for: .selected)
            btn.titleLabel?.font = FONT(15)
            btn.titleEdgeInsets = UIEdgeInsets.init(top: 0, left: 5, bottom: 0, right: 0)
            btn.addTarget(self, action: #selector(detailThreeBtnClick(sender:)), for: .touchUpInside)
            self.addSubview(btn)
            if i == 1 {

                collectionBtn = btn
                
            }
        }
       let segmentBackView = UIView.init(frame: CGRect.init(x: 0, y: 50, width: Screen_width, height: 40))
        segmentBackView.backgroundColor = Whit
        self.addSubview(segmentBackView)
        
        let threeSegmentBtn = UISegmentedControl.init(frame: CGRect.init(x: 20 * Ratio_width, y: 5, width: Screen_width - 40*Ratio_width, height: 30))
        segmentBackView .addSubview(threeSegmentBtn)
        threeSegmentBtn .insertSegment(withTitle: "课程介绍", at: 0, animated: true)
        threeSegmentBtn.insertSegment(withTitle: "课程章节", at: 1, animated: true)
        threeSegmentBtn.insertSegment(withTitle: "讨论区", at: 2, animated: true)
        threeSegmentBtn.selectedSegmentIndex = 0
        threeSegmentBtn.tintColor = navColor
        threeSegmentBtn .addTarget(self, action: #selector(threeSegmentBtnClick(sender:)), for: .valueChanged)
        
    }
    
    
    func detailThreeBtnClick(sender: UIButton)  {
        if self.topViewButtonDelegate != nil   {
            self.topViewButtonDelegate?.collectionAndDownClick(buttonTag: sender.tag)
        }
    }
    
    func threeSegmentBtnClick(sender:UISegmentedControl) {
        if self.topViewButtonDelegate != nil {
            self.topViewButtonDelegate?.threeSegmentBtn(segmentIndex: sender.selectedSegmentIndex)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
