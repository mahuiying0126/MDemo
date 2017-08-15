//
//  HomeDetailViewModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/4.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
class HomeDetailViewModel: NSObject {

    func loadingHomeCourseData(parameter: String ,success : @escaping (_ infoModel : DetailInfoModel,_ courseModel : DetailCourseModel,_ coursePackageArray : NSArray,_ listDeatilArray : NSArray)->()){
        
        let homeCourse = MNetRequestSeting()
        homeCourse.hostUrl = courseinfo()
        homeCourse.isHidenHUD = true
        homeCourse.paramet  = ["courseId":parameter ,"userId":USERID ,"uuId":KEY_UUID ]
        homeCourse.cashSeting = .MSave
        homeCourse.requestDataFromNetSet(seting: homeCourse, successBlock: { (responseData) in
            if responseData["success"].boolValue{
                let tempDict : NSDictionary = responseData["entity"].rawValue as! NSDictionary
                let infoModel = DetailInfoModel .mj_object(withKeyValues: tempDict)!
                let courseModel = DetailCourseModel.mj_object(withKeyValues: tempDict["course"])!
                let coursePackageArray = (tempDict["coursePackageList"]  as! NSArray)
                let listDeatilArray = DetailCourseListModel.mj_objectArray(withKeyValuesArray: tempDict["courseKpoints"])!
                success(infoModel,courseModel,coursePackageArray,listDeatilArray)
                
            }
        }) { (error) in
            
        }
        
        
        
    }
    
    func loadCommentData(courseID:String,currentPage:NSInteger,isLoadMore:Bool,successBlock:@escaping(_ listData:NSArray,_ totlePage:NSInteger) -> ()) {
        
        let comment = MNetRequestSeting()
        comment.isHidenHUD = false
        comment.hostUrl = courseAssesslist()
        comment.paramet = ["courseId":courseID,"page.currentPage":currentPage]
        comment.requestDataFromNetSet(seting: comment, successBlock: { (responseData) in
            if responseData["success"].boolValue{
                let tempDict = responseData["entity"].rawValue as! NSDictionary
                let page = tempDict["page"] as! NSDictionary
                let totlpage = page["totalPageSize"] as! NSInteger
                
                let tempArray = CommentUserModel.mj_objectArray(withKeyValuesArray: tempDict["assessList"] as! NSArray)
                successBlock(tempArray!,totlpage)
                
            }
        }) { (error) in
            
        }
    }
    
}
