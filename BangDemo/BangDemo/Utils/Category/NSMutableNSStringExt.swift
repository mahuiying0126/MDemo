//
//  NSMutableNSStringExt.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/2.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation
extension NSMutableAttributedString{
    
    /// 图片文字结合,图片在前
    ///
    /// - Parameters:
    ///   - imageName: 图片的名称
    ///   - textStr: 当前传入的文字
    ///   - fontSize: 文字大小
    ///   - color: 文字颜色
    /// - Returns: 返回富文本字符串
    func attributedString(imageName:String,textStr:String,fontSize:CGFloat,color:UIColor) -> NSMutableAttributedString {
        let text = NSMutableAttributedString()
        
        let title : NSAttributedString = NSAttributedString(string: textStr, attributes: [NSAttributedStringKey.foregroundColor : color, NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontSize)])
        let kongge : NSAttributedString = NSAttributedString(string: " ", attributes: [NSAttributedStringKey.foregroundColor : color, NSAttributedStringKey.font : UIFont.systemFont(ofSize: fontSize)])
        
        var image = UIImage(named:imageName)
        image = UIImage.init(cgImage: (image?.cgImage)!, scale: 2.0, orientation: UIImageOrientation.up)
        let textAttachment : NSTextAttachment = NSTextAttachment()
        textAttachment.image = image
        textAttachment.bounds = CGRect(x: 0, y: -7, width: 25, height: 25)
        text.append(NSAttributedString(attachment: textAttachment))
        
        text.append(kongge)
        
        text.append(title)
        
        return text
    }
    
    /// 标签,文字类型富文本,只支持文字类型标签,如:¥ $,等字符
    ///
    /// - Parameters:
    ///   - titleString: 符号文字
    ///   - lineStyle : 线的位置
    ///   - markFont: 标签的字体大小
    ///   - markMakeRange: 标签范围
    ///   - markColor: 标签颜色
    ///   - textFont: 文字大小
    ///   - textMakeRange: 文字范围
    ///   - textColor: 文字颜色
    /// - Returns: 返回一个标签类富文本
    func markStyleAttributeString(_ titleString :String,lineStyle:NSUnderlineStyle, markFont:CGFloat,markMakeRange:NSRange,markColor:UIColor,textFont:CGFloat,textMakeRange:NSRange,textColor:UIColor) -> NSMutableAttributedString {
        //富文本设置
        let attributeString = NSMutableAttributedString.init(string: titleString)
        attributeString.addAttribute(NSAttributedStringKey.font, value: FONT(markFont), range: markMakeRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: markColor, range: markMakeRange)
        attributeString.addAttribute(NSAttributedStringKey.font, value: FONT(textFont), range: textMakeRange)
        attributeString.addAttribute(NSAttributedStringKey.foregroundColor, value: textColor, range: textMakeRange)
        
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: NSNumber.init(value: lineStyle.rawValue), range: NSMakeRange(0, attributeString.length))
        
        return attributeString
    }
    
    
}

