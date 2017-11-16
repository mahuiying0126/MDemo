//
//  MNSStringExtension.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/7.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation

extension NSString{
    
    
    /// 计算字体的宽度
    ///
    /// - Parameter font: 字体的尺寸
    /// - Returns: 字体宽度
    func widthForFont(font: inout UIFont) -> CGFloat {
        let size = self.sizeForFont(font: &font, size:.init(width: CGFloat(HUGE), height: CGFloat(HUGE)) , lineBreakMode: .byWordWrapping)
        
        return size.width
    }
    
    /// 给定宽度计算字体的高度
    ///
    /// - Parameters:
    ///   - font: 字体尺寸
    ///   - width: 控件宽度
    /// - Returns: 字体的高度
    func heightForFont(font : inout UIFont,width:CGFloat) -> CGFloat {
        
        let size = self.sizeForFont(font: &font, size: .init(width: width, height: CGFloat(HUGE)), lineBreakMode: .byWordWrapping)
        return size.height
    }
    
    
    /// 计算字体的宽高
    ///
    /// - Parameters:
    ///   - font: 字体尺寸
    ///   - size: 字体模糊宽高
    ///   - lineBreakMode: 字体折行样式
    /// - Returns: 字体宽高
    func sizeForFont(font : inout UIFont,size:CGSize,lineBreakMode:NSLineBreakMode) -> CGSize {
        
        var result = CGSize()
        
        if isEqual(font) {
            font = .systemFont(ofSize: 12)
        }
        if self.responds(to: #selector(boundingRect(with:options:attributes:context:))) {
            var attr = Dictionary<NSAttributedStringKey,Any>()
            attr[NSAttributedStringKey.font] = font
            if lineBreakMode != .byWordWrapping {
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = lineBreakMode
                attr[NSAttributedStringKey.paragraphStyle] = paragraphStyle
            }
            
            let rect = self.boundingRect(with: size, options: [.usesLineFragmentOrigin,.usesFontLeading] , attributes: attr, context: nil)
            result = rect.size
            
        }else{
            
        }
        
        return result
    }
}
