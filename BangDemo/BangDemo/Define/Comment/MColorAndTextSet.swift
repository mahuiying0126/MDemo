//
//  MColorAndTextSet.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/11.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation

///16进制颜色
public func UIColorFromRGB(_ rgbValue :NSInteger) ->UIColor{
    
    return UIColor (red: ((CGFloat)((rgbValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((rgbValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(rgbValue & 0xFF))/255.0, alpha: 1.0)
}
/// RGB 三原色
public func ColorFromRGB(_ R:CGFloat,_ G:CGFloat,_ B:CGFloat ,_ A:CGFloat)->UIColor{
    
    return UIColor (red: R / 255.0 , green: G/255.0, blue: B/255.0, alpha: A)
}

public let Whit = UIColor.white

public let navColor = ColorFromRGB(62.0, 131.0, 229.0,1.0)

public let lineColor = ColorFromRGB(249, 249 , 249, 1.0)

public func FONT(_ int:CGFloat) ->UIFont {
    return UIFont .systemFont(ofSize: int)
}

