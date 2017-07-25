//
//  HTTPInterface.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/11.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation
import SwiftyJSON



public let baseUrlString = "http://t.268xue.com/app/"
public let imageUrlString = "http://static.268xue.com"


/* 首页bunder**/
public func advertisement() ->String{
    
   return baseUrlString .appending("index/banner")
}
/* 首页公告**/
public func homeNote() ->String{
    
    return baseUrlString.appending("index/article")
}

/* 首页课程**/
public func recommandCourse() ->String{
    
    return baseUrlString.appending("index/course")
}

/* 咨询详情**/

public func articleInfo() ->String{
    
    return baseUrlString.appending("article/info")
}

/// 课程详情
public func courseinfo() ->String{
    
    return baseUrlString.appending("course/info")
}

/// 课程介绍接口

public func coursecontent() -> String{
    
    return baseUrlString.appending("course/content")
}


