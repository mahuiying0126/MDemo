//
//  HomeCourseModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/12.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
class HomeCourseModel: NSObject {
    
    var recommendId : String?
    var pageViewcount : String?
    var currentPrice : String?
    var ID : String?
    var isPay = Bool()
    var courseId : String?
    var lessionnum : String?
    var playCount : String?
    var mobileLogo : String?
    var orderNum : String?
    var courseName : String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        
        return ["ID":"id","descrip":"description"]
    }
    
    //MARK: 加载课程列表数据
    func loadRecommandCourseData(success : @escaping (_ response : NSMutableArray) ->()){
        
        MNetworkRequest.sharedInstance.postRequestNoparam(urlString: recommandCourse() as String, success: { (requested) in
            
            let responseData = JSON(requested)
            if(responseData["success"]).boolValue && (responseData["entity"].dictionary != nil){
                let entity =  responseData["entity"]
                let tempDataArray = NSMutableArray()
                if(entity["1"].exists()){
                    
                    let first :NSArray  = HomeCourseModel.mj_objectArray(withKeyValuesArray: entity["1"].rawValue )
                    tempDataArray .add(first)
                    
                }
                if(entity["2"].exists()){
                    let second:NSArray  = HomeCourseModel.mj_objectArray(withKeyValuesArray: entity["2"].rawValue)
                    tempDataArray .add(second)
                }
                success(tempDataArray)
                
            }
            
        }) { (error) in
            //获取数据失败
        }
    }
    
    
    
    
    
    
}
