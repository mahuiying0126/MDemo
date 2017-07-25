//
//  DetailCourseModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/1.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class DetailCourseModel: NSObject {
    
    var ID : String?
    var isPay = Bool()
    var sourceprice : String?
    var currentprice : String?
    var losetype : String?
    var playNum : String?
    var name : String?
    var context : String?
    var mobileLogo : String?
    var teacherList : NSArray?
    var isOK = Bool()
    var courseID : String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        
        return ["ID":"id"]
    }
    
    
}
