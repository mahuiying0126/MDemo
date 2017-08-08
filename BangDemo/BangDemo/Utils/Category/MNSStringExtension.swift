//
//  MNSStringExtension.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/7.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation

extension NSString{
    
    func widthForFont(font: inout UIFont) -> CGFloat {
        let size = self.sizeForFont(font: &font, size:CGSize.init(width: CGFloat(HUGE), height: CGFloat(HUGE)) , lineBreakMode: .byWordWrapping)
        
        return size.width
    }
    
    
    
    func sizeForFont(font : inout UIFont,size:CGSize,lineBreakMode:NSLineBreakMode) -> CGSize {
        var result = CGSize()
        if  isEqual(font) {
            font = .systemFont(ofSize: 12)
        }
        if self.responds(to: #selector(boundingRect(with:options:attributes:context:))) {
            let attr = NSMutableDictionary()
            attr[NSFontAttributeName] = font
            if lineBreakMode != .byWordWrapping {
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = lineBreakMode
                attr[NSParagraphStyleAttributeName] = paragraphStyle
            }
            
            let rect = self.boundingRect(with: size, options: [.usesLineFragmentOrigin,.usesFontLeading] , attributes: attr as? [String : Any], context: nil)
            result = rect.size
            
        }else{
            
        }
        
        return result
    }
}
