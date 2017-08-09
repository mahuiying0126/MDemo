//
//  MUIImageExtension.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/9.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation
extension UIImage {
    
    
    /// 裁剪 UIImage
    ///
    /// - Parameters:
    ///   - radius:  裁剪角度
    ///   - size: image 的宽高
    /// - Returns: 被裁剪好的图片
    func drawRectWithRoundedCorner(radius: CGFloat, _ size: CGSize) -> UIImage {
        let rect = CGRect(origin: CGPoint(x: 0, y: 0), size: size)
        
        UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
        UIGraphicsGetCurrentContext()!.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,cornerRadii: CGSize(width: radius, height: radius)).cgPath)
        UIGraphicsGetCurrentContext()?.clip()
        
        self.draw(in: rect)
        UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
        let output = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return output!
    }
    
   
}
