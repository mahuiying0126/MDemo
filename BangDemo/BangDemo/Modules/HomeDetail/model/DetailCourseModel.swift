//
//  DetailCourseModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/1.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class DetailCourseModel: NSObject {
    
    /// *课程 id
    var ID : String?
    
    /// *是否已经支付
    var isPay : Bool = false
    
    /// *课程原价
    var sourceprice : String?
    /// *课程当前价格
    var currentprice : String?
    var losetype : String?
    ///  *播放量
    var playNum : String?
    /// *课程名称
    var name : String?
    /// *课程描述
    var context : String?
    /// *课程图片
    var mobileLogo : String?
    /// 老师列表
    var teacherList : Array<Any>?
    /// 是否买了
    var isOK : Bool = false
    /// 课程 id
    var courseID : String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        
        return ["ID":"id"]
    }
    
    
}
