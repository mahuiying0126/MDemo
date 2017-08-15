//
//  TeacherHeaderView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/3.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class TeacherHeaderView: UIView {

    var courseName : UILabel?
    var currentPrice : UILabel?
    var sourcePrice : UILabel?
    var purchaseBtn : UIButton?
    var downUpBtn : UIButton?
    
    var detailWebView : UIWebView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = Whit
        self.setUpUIView()
    }
    func setTeacherHeadModel(_ model:DetailCourseModel){
        courseName?.text = model.name!
        let currentText = String.init(format: "¥ %@", model.currentprice!)
        currentPrice?.attributedText = NSMutableAttributedString().markStyleAttributeString(currentText,lineStyle:.styleNone, markFont: 14.0, markMakeRange: NSRange.init(location: 0, length: 1), markColor: .black, textFont: 18.0, textMakeRange: NSRange.init(location: 2, length: currentText.characters.count - 2), textColor: UIColorFromRGB(0x007AFF))
        
        let sourceText = String.init(format: "¥ %@", model.sourceprice!)
        
        sourcePrice?.attributedText = NSMutableAttributedString().markStyleAttributeString(sourceText,lineStyle:.styleSingle, markFont: 14.0, markMakeRange: NSMakeRange(0, 1), markColor: .black, textFont: 18.0, textMakeRange: NSRange.init(location: 2, length: sourceText.characters.count - 2), textColor: UIColorFromRGB(0x7F7F7F))
        
        
        
        if (model.isOK || Double(model.currentprice!)! <= 0.0) {
            purchaseBtn?.isEnabled = false
            purchaseBtn?.setTitle("", for: .normal)
            purchaseBtn?.setBackgroundImage(UIImage.init(named: "免费"), for: .normal)
        }else{
            
            purchaseBtn?.isEnabled = true
            if model.isOK {
                purchaseBtn?.setTitle("立刻观看", for: .normal)
                purchaseBtn?.setBackgroundImage(UIImage.init(named: "立即观看"), for: .normal)
            }else{
                purchaseBtn?.setTitle("立即购买", for: .normal)
                purchaseBtn?.setBackgroundImage(UIImage.init(named: "立即购买"), for: .normal)
            }
            
        }
        let courseIdString = String.init(format: "%@/%@.json", coursecontent(),model.courseID!)
        let url  = NSURL.init(string: courseIdString)! as URL
        let request  = NSURLRequest.init(url: url) 
        detailWebView?.loadRequest(request as URLRequest)
    }
    func setUpUIView()  {
        courseName = UILabel()
        courseName?.font = FONT(15)
        self.addSubview(courseName!)
        currentPrice = UILabel()
        self.addSubview(currentPrice!)
        sourcePrice = UILabel()
        self.addSubview(sourcePrice!)
        purchaseBtn = UIButton()
        self.addSubview(purchaseBtn!)
        let line = UIView()
        line.backgroundColor = lineColor
        self.addSubview(line)
        let descrp = UILabel()
        descrp.text = "介绍"
        self.addSubview(descrp)
        downUpBtn = UIButton()
        downUpBtn?.setImage(MIMAGE("open"), for: .normal)
        downUpBtn?.setImage(MIMAGE("close"), for: .selected)
        self.addSubview(downUpBtn!)
        detailWebView = UIWebView()
        self.addSubview(detailWebView!)
        detailWebView?.backgroundColor = Whit
        detailWebView?.scrollView.isScrollEnabled = false
        detailWebView?.isUserInteractionEnabled = false
        detailWebView?.isOpaque = false
        
        courseName?.snp.makeConstraints({ (make) in
            make.left.top.equalTo(self).offset(12)
            make.right.equalTo(self.snp.right).offset(-15)
            make.height.equalTo(21)
        })
        currentPrice?.snp.makeConstraints({ (make) in
            make.left.equalTo(courseName!)
            make.top.equalTo(courseName!.snp.bottom).offset(12)
            make.height.equalTo(21)
            
        })
        sourcePrice?.snp.makeConstraints({ (make) in
            make.left.equalTo(currentPrice!.snp.right).offset(10)
            make.top.height.equalTo(currentPrice!)
            
        })
        
        let line1 = UIView()
        line1.backgroundColor = UIColorFromRGB(0x7F7F7F)
        sourcePrice?.addSubview(line1)
        line1.snp.makeConstraints { (make) in
            make.center.equalTo(sourcePrice!)
            make.height.equalTo(1)
            make.width.equalTo(sourcePrice!)
        }
        
        purchaseBtn?.snp.makeConstraints({ (make) in
            make.top.equalTo(courseName!.snp.bottom)
            make.right.equalTo(self).offset(-10)
            make.width.equalTo(80)
            make.height.equalTo(32)
        })
        line.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.top.equalTo(purchaseBtn!.snp.bottom).offset(7)
            make.height.equalTo(1)
        }
        descrp.snp.makeConstraints { (make) in
            make.left.equalTo(courseName!)
            make.top.equalTo(line.snp.bottom)
            make.width.equalTo(40)
            make.height.equalTo(30)
        }
        downUpBtn?.snp.makeConstraints({ (make) in
            make.top.width.height.equalTo(descrp)
            make.right.equalTo(self).offset(-10)
        })
        detailWebView?.snp.makeConstraints({ (make) in
            make.left.right.bottom.equalTo(self)
            make.top.equalTo(downUpBtn!.snp.bottom)
        })
       
    }
  
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    

}
