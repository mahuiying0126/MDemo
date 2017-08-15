//
//  DetailCourseListModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/2.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class DetailCourseListModel: NSObject {
    var ID : String?
    var courseId : String?
    var parentId : String?
    var type : String?
    var status : String?
    var sort : String?
    var playcount : String?
    var isfree : String?
    var teacherId : String?
    var courseHour : String?
    var courseMinutes : String?
    var courseSeconds : String?
    var pageCount : String?
    var touristIsFree : String?
    
    
    var name : String?
    var addTime : String?
    var videotype : String?
    var fileType : String?
    var examLink : String?
    var courseware : String?
    var childKpoints : Array<Any>?
    var teacherName : String?
    var isSelected : Bool = false
    var content : String?
    var imageUrl : String?
    var chapterName : String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        
        return ["ID":"id"]
    }
    

    override func mj_keyValuesDidFinishConvertingToObject() {
        self.childKpoints = DetailCourseChildModel.mj_objectArray(withKeyValuesArray: self.childKpoints).copy() as? Array<Any> 
    }
    
    
    
}
