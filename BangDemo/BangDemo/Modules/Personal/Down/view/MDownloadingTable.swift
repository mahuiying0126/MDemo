//
//  MDownloadingTable.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/25.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import Alamofire
import ReachabilitySwift
class MDownloadingTable: UITableView,UITableViewDelegate,UITableViewDataSource,DownloadStatusChangedDelegate{

    private let cellID : String = "down"
    /** *是否正在下载页面 */
    var  isDownloading : Bool = true
    private var downDataArray : Array<DownloadingModel> = []
    private var downloadInfoM : Array<DownloadInfo> = []
    private var isFirst : Bool = false
    private let reachability = Reachability()!
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.register(MDownTableViewCell.self, forCellReuseIdentifier: cellID)
        DownloadManager.setDownloadStatusChangedDelegate(self)
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
        do{
            // 3、开启网络状态消息监听
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
        
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none  
    }
    
    func updataTableForData(_ isDowning : Bool)  {
        if isDowning {
            ///从数据库获取下载数据
            let temploadArray =  MFMDBTool.shareInstance.listDataFromDownloaingTable()
            if temploadArray.count == 0 {
                return
            }
            if MNetworkUtils.isEnableWIFI() {
                ///如果是wifi网络下,统计一下正在下载数量
                var downingNuber = 0
                for item in temploadArray {
                    ///正在运行,或者有暂停的
                    if item.videoState == Int(STATUS_DOWNLOADING) || item.videoState == Int(STATUS_PAUSED) {
                        downingNuber = 1
                        break
                    }
                }
                ///经过上面遍历,如果没有下载任务,默认开启第一个
                if downingNuber == 0 {
                    let model  = temploadArray.first
                    model?.videoState = Int(STATUS_DOWNLOADING)
                    ///每一次操作都要更新数据库,来保存相应的数据
                    MFMDBTool.shareInstance.updataDownloadState(model!)
                }
            }
            self.downDataArray = temploadArray
            self.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.downDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as! MDownTableViewCell
        cell.selectionStyle = .none
        let model = self.downDataArray[indexPath.row]
        cell.stateButton?.tag = 520 + indexPath.row
        cell.stateButton?.addTarget(self, action: #selector(changeStatrForButtonEvent(sender:)), for: .touchUpInside)
        cell.cellForModel(model)
        self.startDownloadWithModel(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func downloadStatusChanged(_ downloadInfo: DownloadInfo!) {
        
        switch downloadInfo.status {
        case STATUS_DOWNLOADING:
            reloadIndexPathOfRow(downloadInfo)
            break
        case STATUS_PAUSED:
            reloadIndexPathOfRow(downloadInfo)
            break
        case STATUS_STOPPED:
            reloadIndexPathOfRow(downloadInfo)
            break
        case STATUS_COMPLETED:
            checkDownloadComplete(downloadInfo)
            break
        default:
            break
        }
    }
    
    func reloadIndexPathOfRow(_ downInfo : DownloadInfo)  {
        autoreleasepool { () -> () in
            let downloadList = MFMDBTool.shareInstance.listDataFromDownloaingTable()
            for (index,item) in downloadList.enumerated(){
                
                let videoUrl = NSString.init(string: downInfo.id).components(separatedBy:".")
                if item.videoUrl == videoUrl.first {
                    let indexPath = IndexPath.init(row: index, section: 0)
                    let cell = self.cellForRow(at: indexPath) as! MDownTableViewCell
                    cell.updataCellForModel(downInfo)
                    break
                }
                
            }
        }
    }
    
    func checkDownloadComplete(_ downloadInfo : DownloadInfo) {
        let videoUrl = NSString.init(string: downloadInfo.id).components(separatedBy:".")
        
        for item in MFMDBTool.shareInstance.listDataFromDownloaingTable() {
            if videoUrl.first == item.videoUrl {
                MFMDBTool.shareInstance.addFinshModel(item)
                ///完成将数据做最后一次更新
                item.totalSize = Float(downloadInfo.size)
                MFMDBTool.shareInstance.updataDownloadState(item)
                ///将正在下载列表任务移除
            MFMDBTool.shareInstance.removeDownloadingModel(item.kPointID!)
               break
            }
        }
        ///重新调用数据源
        loadingArrayData()
        
        for item in self.downDataArray {
            let downloadInfo = mgetCurrentDownInfoModel(item.videoUrl!)
            if (downloadInfo.status != STATUS_DOWNLOADING || downloadInfo.status != STATUS_COMPLETED || downloadInfo.status != STATUS_DELETED) && (!item.isManualSuspen){
                item.videoState = Int(STATUS_DOWNLOADING)
                self.startDownloadWithModel(item)
                MFMDBTool.shareInstance.updataDownloadState(item)
                break;
            }
        }
        
    }
    
    private func loadingArrayData(){
        self.downDataArray.removeAll()
        self.downDataArray = MFMDBTool.shareInstance.listDataFromDownloaingTable()
        
        self.reloadData()
    }
    
    func reachabilityChanged(note: NSNotification){
        let reachability = note.object as! Reachability // 准备获取网络连接信息
        if reachability.isReachable { // 判断网络连接状态
            print("网络连接：可用")
            if reachability.isReachableViaWiFi { // 判断网络连接类型
                print("连接类型：WiFi")
                if self.isFirst {
                    let downArray = MFMDBTool.shareInstance.listDataFromDownloaingTable()
                    if downArray.count > 0 {
                        for item in downArray {
                            let downloadInfo = self.mgetCurrentDownInfoModel(item.videoUrl!)
                            MYLog(downloadInfo.status)
                            if (downloadInfo.status == STATUS_PAUSED || downloadInfo.status == STATUS_ERROR || downloadInfo.status == STATUS_STOPPED) && (!item.isManualSuspen) {
                                item.videoState = Int(STATUS_DOWNLOADING)
                                self.startDownloadWithModel(item)
                                MFMDBTool.shareInstance.updataDownloadState(item)
                                break;
                            }
                            
                        }
                        self.loadingArrayData()
                    }
                }
                self.isFirst = true
                
            } else {
                print("连接类型：移动网络")
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
                    self.loadingArrayData()
                }
            }
        } else {
            print("网络连接：不可用")
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
                self.loadingArrayData()
            }
        }
        
    }
    @objc func changeStatrForButtonEvent(sender : UIButton){
    
        let row = sender.tag - 520
        let downModel = self.downDataArray[row]
        let downloadInfo = mgetCurrentDownInfoModel(downModel.videoUrl!)
        MYLog(downloadInfo.status)
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
            self.startDownloadWithModel(downModel)
            break
        }
        downModel.currentSize = Float(downloadInfo.progress)
        downModel.totalSize = Float(downloadInfo.size)
        ///点击一个开启下载,另一个暂停
        for (index,iteam) in self.downDataArray.enumerated() {
            if index != row {
                let downInfo = mgetCurrentDownInfoModel(iteam.videoUrl!)
                
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
        ///每一次操作都要更新数据库,来保存相应的数据
        MFMDBTool.shareInstance.updataDownloadState(downModel)
    }
    
    private func startDownloadWithModel(_ model : DownloadingModel){
        
        let wifi = MNetworkUtils.isEnableWIFI()
        let haveNet = !MNetworkUtils.isNoNet()
        ///是 WiFi 情况并且网络可用,如果下载器没状态,或者手动改变状态,开启下载
        if ((wifi && haveNet) && ( model.videoState == Int(STATUS_DOWNLOADING))) {
            DownloadManager.setDebugMode(false)
            DownloadManager.init(LibraryFor96k) {[weak self] (merror) in
                if (merror == nil) {
                    DownloadManager.start(withName: model.videoUrl, channel: CHANNEL_AUDIO, speed: SPEED_10X)
                    self?.downloadInfoM = DownloadManager.listDownloadInfos()
                }
            }
        }
    }
    
    private func mgetCurrentDownInfoModel(_ videoUrl : String) -> DownloadInfo {
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
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
