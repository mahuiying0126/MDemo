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
    var isPay : Bool = false
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
    
    /// 加载首页课程接口
    ///
    /// - Parameters:
    ///   - success: 成功回调
    ///   - failture: 失败回调
    func loadRecommandCourseData(success : @escaping (_ response : Array<Any>) ->(),failture : @escaping (_ error : Error)->()){
        
        let recommand = MNetRequestSeting()
        recommand.hostUrl = recommandCourse()
        recommand.cashSeting = .MSave
        recommand.isHidenHUD = false
        recommand.requestDataFromNetSet(seting: recommand, successBlock: { (responseData) in
            if(responseData["success"]).boolValue && (responseData["entity"].dictionary != nil){
                let entity =  responseData["entity"]
                var tempDataArray = Array<Any>()
                if(entity["1"].exists()){
                    
                    let first = HomeCourseModel.mj_objectArray(withKeyValuesArray: entity["1"].rawValue )
                    tempDataArray.append(first!)
                    
                }
                if(entity["2"].exists()){
                    let second  = HomeCourseModel.mj_objectArray(withKeyValuesArray: entity["2"].rawValue)
                    tempDataArray.append(second!)
                }
                success(tempDataArray)
                
            }

        }) { (error) in
            failture(error)
        }
       
    }
    
    
    
    
    
    
}
