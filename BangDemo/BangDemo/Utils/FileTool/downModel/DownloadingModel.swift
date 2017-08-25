//
//  DownloadingModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/23.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class DownloadingModel: NSObject {
    /** *课程 ID */
    var courseId : String?
    /** *节点 ID */
    var kPointID : String?
    /** *视频名称 */
    var videoName : String?
    /** *课程名称 */
    var  courseName : String?
    /** *播放量 */
    var playcount : String?
    /** *老师名称 */
    var teacherName : String?
    /** *视频 OR 音频类型: CC,96K 等 */
    var videoType : String?
    /** *文件类型,是:视频还是音频 */
    var fileType : String?
    /** *通过节点得到的链接 */
    var videoUrl : String?
    /** *图片 url */
    var imageUrl : String?
    /** *父节点 id */
    var parentId : String?
    /** *总大小 */
    var totalSize : String?
    /** *当前大小 */
    var currentSize : String?
    
    class func conversionsModel(_ model : DetailCourseChildModel) ->DownloadingModel{
        let downModel = DownloadingModel()
        downModel.courseId = model.courseId
        downModel.kPointID = model.ID
        downModel.videoName = model.Name
        downModel.courseName = model.courseTitle
        downModel.playcount = model.playcount
        downModel.teacherName = model.teacherId
        
        return downModel
    }

}
