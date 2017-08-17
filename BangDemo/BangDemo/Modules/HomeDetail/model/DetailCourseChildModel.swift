//
//  DetailCourseChildModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/20.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class DetailCourseChildModel: NSObject {
    var ID : String?
    var courseId : String?
    /// * name
    var Name : String?
    /// * parentId
    var parentId  : String?
    /// * type
    var type : String?
    /// * status
    var status : String?
    /// * 增加时间
    var addTime : String?
    /// * 播放量
    var playcount : String?
    /// * 是否免费
    var isfree : Int = 0
    /// * 视频类型
    var videotype : String?
    /// * 老师ID
    var teacherId : String?
    /// * courseMinutes
    var courseMinutes : String?
    /// * courseSeconds
    var courseSeconds : String?
    /// * 文件类型
    var fileType : String?
    /// * courseware
    var courseware : String?
    /// * pageCount
    var pageCount : String?
    /// * touristIsFree
    var touristIsFree : Bool = false
    
    /** 是否被点击*/
    var isSelected : Bool = false
    
    /** *课程 title */
    var courseTitle : String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        
        return ["ID":"id","Name":"name"]
    }
    
}
