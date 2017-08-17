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

    func loadingHomeCourseData(parameter: String ,success : @escaping (_ infoModel : DetailInfoModel,_ courseModel : DetailCourseModel,_ coursePackageArray : Array<Any>,_ listDeatilArray : Array<Any>)->()){
        
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
                success(infoModel,courseModel,coursePackageArray as! Array<Any>,listDeatilArray as! Array<Any>)
                
            }
        }) { (error) in
            
        }
        
        
        
    }
    
    func loadCommentData(courseID:String,currentPage:NSInteger,isLoadMore:Bool,successBlock:@escaping(_ listData:Array<Any>,_ totlePage:NSInteger) -> ()) {
        
        let comment = MNetRequestSeting()
        comment.isHidenHUD = false
        comment.hostUrl = courseAssesslist()
        comment.paramet = ["courseId":courseID,"page.currentPage":currentPage]
        comment.requestDataFromNetSet(seting: comment, successBlock: { (responseData) in
            if responseData["success"].boolValue{
                let tempDict = responseData["entity"].rawValue as! NSDictionary
                let page = tempDict["page"] as! NSDictionary
                let totlpage = page["totalPageSize"] as! NSInteger
                
                let tempArray = CommentUserModel.mj_objectArray(withKeyValuesArray: tempDict["assessList"]) as! Array<Any>
                successBlock(tempArray,totlpage)
                
            }
        }) { (error) in
            
        }
    }
    
    func handlCourseDataForNext(currentRow: inout NSInteger,currentSection: inout NSInteger,courseData: inout Array<Any>) -> DetailCourseChildModel  {
        
        let courseModel  = courseData[currentSection] as! DetailCourseListModel
        let tempArray = courseModel.childKpoints
        let rowModel = tempArray?[currentRow] as! DetailCourseChildModel
        rowModel.isSelected = false
        if currentRow == (tempArray?.count)! - 1 {
            ///说明当前的行在边界,下一曲的话,行=0 再判断分区
            courseModel.isSelected = false
            currentRow = 0
            if currentSection == courseData.count - 1{
                //说明分区也在边界,在边界就让分区=0
                currentSection = 0
            }else{
                currentSection += 1
            }
            let courModel  = courseData[currentSection] as! DetailCourseListModel
            courModel.isSelected = true;
            let Array = courModel.childKpoints
            let model = Array?[currentRow] as! DetailCourseChildModel
            model.isSelected = true
            return model
        }else{
            ///说明当前行在本区,只需要将行+1,分区不变
            currentRow += 1
            let model = tempArray?[currentRow] as! DetailCourseChildModel
            model.isSelected = true
            return model
            
        }
        
    }
    func handlCourseDataForPrevious(currentRow: inout NSInteger,currentSection: inout NSInteger,courseData: inout Array<Any>) -> DetailCourseChildModel  {

        let courseModel  = courseData[currentSection] as! DetailCourseListModel
        let tempArray = courseModel.childKpoints
        let rowModel = tempArray?[currentRow] as! DetailCourseChildModel
        rowModel.isSelected = false
        if currentRow == 0 {
            ///说明当前的行在边界,上一曲的话要判断分区在哪?
            if currentSection == 0 {
                //如果行=0 分区=0,只能说明在第一分区,第一行,再上一个还都是0
                currentSection = 0
                currentRow = 0
                rowModel.isSelected = true
                return rowModel
                
            }else{
                //将上一个分区关掉
                courseModel.isSelected = false
                //说明没有在第一分区,将分区-1
                currentSection -= 1
                //拿到-1后分区的行数
                let courModel  = courseData[currentSection] as! DetailCourseListModel
                courModel.isSelected = true;
                let Array = courModel.childKpoints
                currentRow = (Array?.count)! - 1
                let model = Array?[currentRow] as! DetailCourseChildModel
                model.isSelected = true
                return model
            }
            
        }else{
            ///说明当前行在本区,只需要将行-1,分区不变
            currentRow -= 1
            let model = tempArray?[currentRow] as! DetailCourseChildModel
            model.isSelected = true
            return model
            
        }
        
    }
    
    
    
}
