//
//  MFMDBTool.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/22.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MFMDBTool: NSObject {
    static let shareInstance : MFMDBTool = MFMDBTool()
    // 保存数据库队列对象
    final private var dbQueue : FMDatabaseQueue?
    
    private override init() {
        super.init()
        ///创建数据库对象
        dbQueue = FMDatabaseQueue(path: dbFilePath())
        ///创建表
        self.createDownTable()
        self.createFinshTable()
        
    }
    
    private func dbFilePath() -> String {
        let path = NSHomeDirectory() + "/Library"
        let filePath = path + "/" + "96K_Download.db"
        MYLog("数据库路径:\(filePath)")
        return filePath
    }
    
    /// 创建正在下载的表
    private func createDownTable(){
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "create table if not exists DownloadingList (courseId varchar(20),kPointId varchar(20),videoName varchar(100),courseName varchar(100),playcount varchar(20),teacherName varchar(100),videotype varchar(100),fileType varchar(100),videoUrl varchar(100),imageUrl varchar(100),parentId varchar(20),totalSize varchar(100),currentSize varchar(100),primary key (kPointId))"
            let result = dataBase?.executeUpdate(sql, withArgumentsIn: nil)
            if result! {
                MYLog("正在下载表创建成功")
            } else {
                MYLog("正在下载表创建失败")
            }
            
        })
    }
    
    /// 创建下载完成的表
    private func createFinshTable(){
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "create table if not exists DownloadFinishedList (courseId varchar(20),kPointId varchar(20),videoName varchar(100),courseName varchar(100),playcount varchar(20),teacherName varchar(100),videotype varchar(100),fileType varchar(100),videoUrl varchar(100),imageUrl varchar(100),parentId varchar(20),totalSize varchar(100),currentSize varchar(100),primary key (kPointId))"
            let result = dataBase?.executeUpdate(sql, withArgumentsIn: nil)
            if result! {
                MYLog("下载完成表创建成功")
            }else {
                MYLog("下载完成表创建失败")
            }
        })
    }
    
    
    /// 向正在下载表中加入 model
    ///
    /// - Parameter model:  下载的 model
    func addDownloadingModel(_ model : DownloadingModel) {
        
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "replace INTO DownloadingList (courseId,kPointId,videoName,courseName,playcount,teacherName,videotype,fileType,videoUrl,imageUrl,parentId,totalSize,currentSize) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
            try?dataBase?.executeUpdate(sql, values: [model.courseId as Any,model.kPointID as Any,model.videoName as Any,model.courseName as Any,model.playcount as Any,model.teacherName as Any,model.videoType as Any,model.fileType as Any,model.videoUrl as Any,model.imageUrl as Any,model.parentId as Any,model.totalSize as Any,model.currentSize as Any])
        })
    }
    
    ///  向下载完成的表中加入 model
    ///
    /// - Parameter model:  已完成的 model
    func addFinshModel(_ model : DownloadingModel)  {
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "replace INTO DownloadFinishedList (courseId,kPointId,videoName,courseName,playcount,teacherName,videotype,fileType,videoUrl,imageUrl,parentId,totalSize,currentSize) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)"
            try?dataBase?.executeUpdate(sql, values: [model.courseId as Any,model.kPointID as Any,model.videoName as Any,model.courseName as Any,model.playcount as Any,model.teacherName as Any,model.videoName as Any,model.fileType as Any,model.videoUrl as Any,model.imageUrl as Any,model.parentId as Any,model.totalSize as Any,model.currentSize as Any])
        })
    }
    
    
    ///  通过 model 移除正在下载表中的数据
    ///
    /// - Parameter model: 想要移除的 model
    func removeDownloadingModel(_ pointID : String)  {
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "delete from DownloadingList where kPointId = ?"
           dataBase?.executeUpdate(sql, withArgumentsIn: [pointID])
        })
    }
    
    ///  通过 model 移除已完成下载表中数据
    ///
    /// - Parameter model: 想要移除的 model
    func removeFinshModel(_ pointID : String)  {
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "delete from DownloadFinishedList where kPointId = ?"
            dataBase?.executeUpdate(sql, withArgumentsIn: [pointID])
        })
    }
    
    /// 检查当前 model 是否已在正在下载表中
    ///
    /// - Parameter model: 要检查的 mode
    /// - Returns: true 已存在, false 不存在
    func cheackFromDownloadingTableIsExist(_ pointID : String) -> Bool {
        let tempModel = DownloadingModel()
        
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "select kPointId from DownloadingList where kPointId = ?"
            let rs = dataBase?.executeQuery(sql, withArgumentsIn: [pointID])
            while (rs?.next())! {
                let kpoint = rs?.string(forColumn: "kPointId")
                if pointID == kpoint {
                    tempModel.kPointID = kpoint
                }
            }
        })
        if (tempModel.kPointID != nil) {
            return true
        }else{
            return false
        }
    }
    
    /// 检查当前 model 是否已在完成下载表中
    ///
    /// - Parameter model: 当前 model
    /// - Returns: true 存在, false 不存在
    func cheackFromFinshTableIsExist(_ pointID : String) -> Bool {
        let tempModel = DownloadingModel()
        
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "select kPointId from DownloadFinishedList where kPointId = ?"
            let rs = dataBase?.executeQuery(sql, withArgumentsIn: [pointID])
            while (rs?.next())! {
                let kpoint = rs?.string(forColumn: "kPointId")
                if pointID == kpoint {
                    tempModel.kPointID = kpoint
                }
            }
        })
        if (tempModel.kPointID != nil) {
            return true
        }else{
            return false
        }
    }
    
    /// 获取正在下载的数据
    ///
    /// - Returns: 数组里面是 model
    func listDataFromDownloaingTable() -> Array<DownloadingModel> {
        var downArray = Array<DownloadingModel>()
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "select * from DownloadingList"
            let rs = dataBase?.executeQuery(sql, withArgumentsIn: nil)
            while (rs?.next())! {
                let model = DownloadingModel()
                
                model.courseId = rs?.string(forColumn: "courseId")
                model.kPointID = rs?.string(forColumn: "kPointID")
                model.videoName = rs?.string(forColumn: "videoName")
                model.courseName = rs?.string(forColumn: "courseName")
                model.playcount = rs?.string(forColumn: "playcount")
                model.teacherName = rs?.string(forColumn: "teacherName")
                model.videoType = rs?.string(forColumn: "videoType")
                model.fileType = rs?.string(forColumn: "fileType")
                model.videoUrl = rs?.string(forColumn: "videoUrl")
                model.imageUrl = rs?.string(forColumn: "imageUrl")
                model.parentId = rs?.string(forColumn: "parentId")
                model.totalSize = rs?.string(forColumn: "totalSize")
                model.currentSize = rs?.string(forColumn: "currentSize")
                downArray.append(model)
            }
        })
        
        return downArray
    }
    
    /// 获取已完成下载数据
    ///
    /// - Returns: 数组里面是 model
    func listDataFromFinshTable() -> Array<DownloadingModel> {
        var downArray = Array<DownloadingModel>()
        dbQueue?.inDatabase({ (dataBase) in
            let sql = "select * from DownloadFinishedList"
            let rs = dataBase?.executeQuery(sql, withArgumentsIn: [0])
            while (rs?.next())! {
                let model = DownloadingModel()
                model.courseId = rs?.string(forColumn: "courseId")
                model.kPointID = rs?.string(forColumn: "kPointID")
                model.videoName = rs?.string(forColumn: "videoName")
                model.courseName = rs?.string(forColumn: "courseName")
                model.playcount = rs?.string(forColumn: "playcount")
                model.teacherName = rs?.string(forColumn: "teacherName")
                model.videoType = rs?.string(forColumn: "videoType")
                model.fileType = rs?.string(forColumn: "fileType")
                model.videoUrl = rs?.string(forColumn: "videoUrl")
                model.imageUrl = rs?.string(forColumn: "imageUrl")
                model.parentId = rs?.string(forColumn: "parentId")
                model.totalSize = rs?.string(forColumn: "totalSize")
                model.currentSize = rs?.string(forColumn: "currentSize")
                downArray.append(model)
            }
        })
        
        return downArray
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
