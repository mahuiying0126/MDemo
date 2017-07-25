//
//  UIButtonItemExt.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/8.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation

extension UIBarButtonItem{
    
    
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
