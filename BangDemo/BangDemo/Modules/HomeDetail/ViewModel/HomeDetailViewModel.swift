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

    
    /// 加载详情页数据
    ///
    /// - Parameters:
    ///   - parameter: 参数
    ///   - success: 成功回调
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
    
    
    /// 加载课程评论数据
    ///
    /// - Parameters:
    ///   - courseID: 课程 id
    ///   - currentPage:  当前页
    ///   - isLoadMore: 是否加载更多
    ///   - successBlock: 成功回调
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
    
    /// 处理音视频锁屏播放事件
    ///
    /// - Parameters:
    ///   - currentRow: 播放的当前行
    ///   - currentSection: 播放的当前分区
    ///   - courseData: 播放列表总数据
    /// - Returns: 返回点击下一个按钮的下一个 model
    func handlCourseDataForNext(indexArray:inout Array<IndexPath>,courseData: inout Array<Any>) -> DetailCourseChildModel  {
        var currentIndex = indexArray.first!
        let courseModel  = courseData[currentIndex.section] as! DetailCourseListModel
        let tempArray = courseModel.childKpoints
        let rowModel = tempArray?[currentIndex.row] as! DetailCourseChildModel
        rowModel.isSelected = false
        if currentIndex.row == (tempArray?.count)! - 1 {
            ///说明当前的行在边界,下一曲的话,行=0 再判断分区
            courseModel.isSelected = false
            currentIndex.row = 0
            if currentIndex.section == courseData.count - 1{
                //说明分区也在边界,在边界就让分区=0
                currentIndex.section = 0
            }else{
                currentIndex.section += 1
            }
            let courModel  = courseData[currentIndex.section] as! DetailCourseListModel
            courModel.isSelected = true;
            let Array = courModel.childKpoints
            let model = Array?[currentIndex.row] as! DetailCourseChildModel
            model.isSelected = true
            indexArray.append(currentIndex)
            return model
        }else{
            ///说明当前行在本区,只需要将行+1,分区不变
            currentIndex.row += 1
            let model = tempArray?[currentIndex.row] as! DetailCourseChildModel
            model.isSelected = true
            indexArray.append(currentIndex)
            return model
            
        }
        
    }
    
    
    /// 处理音视频锁屏播放事件
    ///
    /// - Parameters:
    ///   - currentRow: 播放的当前行
    ///   - currentSection: 播放的当前分区
    ///   - courseData: 播放列表总数据
    /// - Returns: 返回点击上一个按钮的上一个 model
    func handlCourseDataForPrevious(indexArray:inout Array<IndexPath>,courseData: inout Array<Any>) -> DetailCourseChildModel  {
        var currentIndex = indexArray.first!
        let courseModel  = courseData[currentIndex.section] as! DetailCourseListModel
        let tempArray = courseModel.childKpoints
        let rowModel = tempArray?[currentIndex.row] as! DetailCourseChildModel
        rowModel.isSelected = false
        if currentIndex.row == 0 {
            ///说明当前的行在边界,上一曲的话要判断分区在哪?
            if currentIndex.section == 0 {
                //如果行=0 分区=0,只能说明在第一分区,第一行,再上一个还都是0
                currentIndex.section = 0
                currentIndex.row = 0
                rowModel.isSelected = true
                return rowModel
                
            }else{
                //将上一个分区关掉
                courseModel.isSelected = false
                //说明没有在第一分区,将分区-1
                currentIndex.section -= 1
                //拿到-1后分区的行数
                let courModel  = courseData[currentIndex.section] as! DetailCourseListModel
                courModel.isSelected = true;
                let Array = courModel.childKpoints
                currentIndex.row = (Array?.count)! - 1
                let model = Array?[currentIndex.row] as! DetailCourseChildModel
                model.isSelected = true
                indexArray.append(currentIndex)
                return model
            }
            
        }else{
            ///说明当前行在本区,只需要将行-1,分区不变
            currentIndex.row -= 1
            let model = tempArray?[currentIndex.row] as! DetailCourseChildModel
            model.isSelected = true
            indexArray.append(currentIndex)
            return model
            
        }
        
    }
    
    
    
}
