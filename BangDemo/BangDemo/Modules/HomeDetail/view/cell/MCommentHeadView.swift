//
//  MCommentHeadView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/9.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MCommentHeadView: UIView {

    /** *输入框 */
    var  addCommentTextView : UITextField?
    /** *发送按钮 */
    var  addCommentButton : UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tip = UILabel()
        tip.text = "有疑惑?讨论下吧"
        self.addSubview(tip)
        tip.font = FONT(15)
        let tipImage = UIImageView()
        self.addSubview(tipImage)
        tipImage.image = MIMAGE("bg-discussion")
        addCommentTextView = UITextField()
        self.addSubview(addCommentTextView!)
        addCommentTextView?.placeholder = "我要评论..."
        addCommentTextView?.font = FONT(15)
        addCommentTextView?.leftView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: 8, height: 0))
        addCommentTextView?.leftViewMode = .always
        addCommentTextView?.textColor = UIColor.lightGray
        addCommentTextView?.layer.borderColor = lineColor.cgColor
        addCommentTextView?.layer.borderWidth = 0.8
        addCommentButton = UIButton()
        self.addSubview(addCommentButton!)
        addCommentButton?.setTitle("发送", for: .normal)
        addCommentButton?.backgroundColor = navColor
        addCommentButton?.setTitleColor(Whit, for: .normal)
        addCommentButton?.titleLabel?.font = FONT(15)
        let tipB = UILabel()
        tipB.text = "课程评论列表"
        tipB.font = FONT(15)
        self.addSubview(tipB)
        
        tip.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(self).offset(15)
            make.height.equalTo(20)
        }
        
        tipImage.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(12)
            make.top.equalTo(tip.snp.bottom).offset(15)
            make.width.height.equalTo(30)
        }
        
        addCommentButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(-10)
            make.top.equalTo(tip.snp.bottom).offset(15)
            make.width.equalTo(44)
            make.height.equalTo(30)
            
        })
        
        addCommentTextView?.snp.makeConstraints({ (make) in
            make.left.equalTo(tipImage.snp.right).offset(5)
            make.top.equalTo(addCommentButton!)
            make.right.equalTo(addCommentButton!.snp.left).offset(-10)
            make.height.equalTo(31)
            
        })
        
        tipB.snp.makeConstraints { (make) in
            make.left.equalTo(self).offset(10)
            make.top.equalTo(tipImage.snp.bottom).offset(15)
            make.height.equalTo(20)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
