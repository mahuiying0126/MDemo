//
//  UIButtonItemExt.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/8.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation

extension UIBarButtonItem{
    
    
   /// 设置一个导航按钮
   ///
   /// - Parameters:
   ///   - target:  target
   ///   - action: 点击事件
   ///   - image: 正常图片
   ///   - hightImage: 高亮图片
   /// - Returns: 返回设置好的BarButton
   func itemWithTarg(target:Any,action:Selector,image:NSString,hightImage:NSString) -> UIBarButtonItem {
        let button:UIButton = UIButton(type:.custom)
        button .addTarget(target, action: action, for: .touchUpInside)
        button.setBackgroundImage(UIImage(named:image as String),for:.normal)
        button.setBackgroundImage(UIImage(named:hightImage as String), for: .highlighted)
        var fream:CGRect = button.frame
        fream.size = (button.currentBackgroundImage?.size)!
        button.frame = fream
        
        return UIBarButtonItem(customView:button)
    }

    
    
    
    
}
