//
//  MUIImageViewExtension.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/9.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation
extension UIImageView {
    
     /// 给图片加圆角
     ///
     /// - Parameter radius: 圆角角度
     func addCornerRadius(_ radius: CGFloat) {
        
        self.image = self.image?.drawRectWithRoundedCorner(radius: radius, self.bounds.size)
    }
    
 
}
