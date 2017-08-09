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
        let param : [String : Any] = ["courseId":parameter ,"userId":"1" ,"uuId":KEY_UUID ]
        
        MNetworkRequest.sharedInstance .postRequest(urlString:courseinfo() , params: param, success: { (responsData) in
                let responseData = JSON(responsData)
                if responseData["success"].boolValue{
                let tempDict : NSDictionary = responseData["entity"].rawValue as! NSDictionary
                let infoModel = DetailInfoModel .mj_object(withKeyValues: tempDict)!
                let courseModel = DetailCourseModel.mj_object(withKeyValues: tempDict["course"])!
                courseModel.isOK = infoModel.isok
                let coursePackageArray = (tempDict["coursePackageList"]  as! NSArray)
                let listDeatilArray = DetailCourseListModel.mj_objectArray(withKeyValuesArray: tempDict["courseKpoints"])!
                success(infoModel,courseModel,coursePackageArray,listDeatilArray)
                
            }
        }) { (error) in
            
        }
        
    }
    
    
    func loadCommentData(courseID:String,currentPage:NSInteger,isLoadMore:Bool,successBlock:@escaping(_ listData:NSArray,_ totlePage:NSInteger) -> ()) {
        let commentDict : [String : Any] = ["courseId":courseID,"page.currentPage":currentPage]
        MNetworkRequest.sharedInstance .postRequest(urlString: courseAssesslist(), params: commentDict, success: { (data) in
            let responseData = JSON(data)
            if responseData["success"].boolValue{
                let tempDict = responseData["entity"].rawValue as! NSDictionary
                let page = tempDict["page"] as! NSDictionary
                let totlpage = page["totalPageSize"] as! NSInteger

                let tempArray = CommentUserModel.mj_objectArray(withKeyValuesArray: tempDict["assessList"] as! NSArray)
                successBlock(tempArray!,totlpage)
            
            }
        }) { (merror) in
            
        }
        
    }
    
}
