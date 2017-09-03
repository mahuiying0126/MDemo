//
//  MDownDataUtils.swift
//  BangDemo
//
//  Created by magic on 2017/9/2.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MDownDataUtils: NSObject {
    static var downloadInfoM : Array<DownloadInfo> = []
    
    class func checkTheDownListVideoState(_ downData : inout Array<DownloadingModel>) {
        if downData.count > 0 {
            if MNetworkUtils.isEnableWIFI() {
                ///如果是wifi网络下,统计一下正在下载数量
                var downingNuber = 0
                for item in downData {
                    ///正在运行,或者有暂停的
                    if item.videoState == Int(STATUS_DOWNLOADING) || item.videoState == Int(STATUS_PAUSED) {
                        downingNuber = 1
                        break
                    }
                }
                ///经过上面遍历,如果没有下载任务,默认开启第一个
                if downingNuber == 0 {
                    let model  = downData.first
                    model?.videoState = Int(STATUS_DOWNLOADING)
                    ///每一次操作都要更新数据库,来保存相应的数据
                    MFMDBTool.shareInstance.updataDownloadState(model!)
                }
            }
        }
        
    }
    class func checkVideoStateFromButtonEvent(downDataArray : inout Array<DownloadingModel>,row : Int) ->Int {
        
        ///点击一个开启下载,另一个暂停
        for (index,iteam) in downDataArray.enumerated() {
            if index != row {
                let downInfo = self.mgetCurrentDownInfoModel(iteam.videoUrl!)
                ///如果 stats 是下载状态就暂停,其他的没状态的肯定没开启下载
                if downInfo.status == STATUS_DOWNLOADING || iteam.videoState == Int(STATUS_DOWNLOADING){
                    DownloadManager.stop(downInfo.id)
                    iteam.videoState = Int(STATUS_PAUSED)
                    iteam.isManualSuspen = true
                    ///每一次操作都要更新数据库,来保存相应的数据
                    MFMDBTool.shareInstance.updataDownloadState(iteam)
                }
            }
        }
        let downModel = downDataArray[row]
        let downloadInfo = self.mgetCurrentDownInfoModel(downModel.videoUrl!)
        MYLog(downloadInfo.status)
        ///此状态为了给下载列表一个回执
        var state = 3
        
        switch downloadInfo.status {
        case STATUS_DOWNLOADING:
            downModel.isManualSuspen = true
            downModel.videoState = Int(STATUS_PAUSED)
            DownloadManager.stop(downloadInfo.id)
            break
        case STATUS_PAUSED:
            downModel.isManualSuspen = false
            downModel.videoState = Int(STATUS_DOWNLOADING)
            DownloadManager.start(downloadInfo.id)
            break
        case STATUS_STOPPED:
            downModel.isManualSuspen = false
            downModel.videoState = Int(STATUS_DOWNLOADING)
            DownloadManager.start(downloadInfo.id)
            break
        case STATUS_ERROR:
            downModel.isManualSuspen = false
            downModel.videoState = Int(STATUS_DOWNLOADING)
            DownloadManager.start(downloadInfo.id)
            break
        default:
            ///上面所有状态都不符合,说明下载器里面没这个任务
            downModel.isManualSuspen = false
            downModel.videoState = Int(STATUS_DOWNLOADING)
            ///将中间变量做改变
            state = 0
            break
        }
        downModel.currentSize = Float(downloadInfo.progress)
        downModel.totalSize = Float(downloadInfo.size)
        ///每一次操作都要更新数据库,来保存相应的数据
        MFMDBTool.shareInstance.updataDownloadState(downModel)
        return state

    }
    
    ///获取每个下载任务的下载信息
    class func mgetCurrentDownInfoModel(_ videoUrl : String) -> DownloadInfo {
        var model = DownloadInfo()
        for info in self.downloadInfoM {
            let temp = NSString.init(string: info.id).components(separatedBy:".")
            if videoUrl == temp.first{
                model = info
                break
            }
        }
        return model
    }
    
    class func handleDownCompleteData(_ downloadInfo : DownloadInfo){
        let videoUrl = NSString.init(string: downloadInfo.id).components(separatedBy:".")
        for item in MFMDBTool.shareInstance.listDataFromDownloaingTable() {
            if videoUrl.first == item.videoUrl {
                ///完成将数据做最后一次更新
                item.totalSize = Float(downloadInfo.size)
                MFMDBTool.shareInstance.addFinshModel(item)
                ///将正在下载列表任务移除
                MFMDBTool.shareInstance.removeDownloadingModel(item.kPointID!)
                break
            }
        }
    }
    class func handel4GChangeFromNet(){
        let downArray = MFMDBTool.shareInstance.listDataFromDownloaingTable()
        if downArray.count > 0 {
            for item in downArray {
                let downloadInfo = self.mgetCurrentDownInfoModel(item.videoUrl!)
                if (downloadInfo.status == STATUS_DOWNLOADING){
                    item.videoState = Int(STATUS_PAUSED)
                    DownloadManager.stop(downloadInfo.id)
                    MFMDBTool.shareInstance.updataDownloadState(item)
                    break;
                }
                
            }
        }
    }
    
    class func handleNoNetFromNer(){
        let downArray = MFMDBTool.shareInstance.listDataFromDownloaingTable()
        if downArray.count > 0 {
            for item in downArray {
                let downloadInfo = self.mgetCurrentDownInfoModel(item.videoUrl!)
                if (downloadInfo.status == STATUS_DOWNLOADING){
                    item.videoState = Int(STATUS_PAUSED)
                    DownloadManager.stop(downloadInfo.id)
                    MFMDBTool.shareInstance.updataDownloadState(item)
                    break;
                }
                
            }
        }
    }
    
}
