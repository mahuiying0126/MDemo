//
//  MDownloadingTable.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/25.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import Alamofire
///点击播放按钮代理
protocol playViedoDelegate : class  {
    func playVideoWithVideoModel(model : DownloadingModel)
}

class MDownloadingTable: UITableView,UITableViewDelegate,UITableViewDataSource,DownloadStatusChangedDelegate{
    
    /** *代理 */
    var  playLocalVidelDelgate : playViedoDelegate?
    private let cellDownID : String = "downID"
    private let cellFinshID : String = "finshID"
    /** *是否正在下载页面 */
    private var  isDownloading : Bool = true
    //如果第一次初始化时不进行 WiFi 网络下检测
    private var isFirst : Bool = false
    private var downDataArray : Array<DownloadingModel> = []
    private var downFinshArray : Array<DownloadingModel> = []
    /** *控制器 */
    var  viewControlM : UIViewController?
//    private let reachability = Reachability()!
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        self.register(MDownTableViewCell.self, forCellReuseIdentifier: cellDownID)
        self.register(MFinshTableViewCell.self, forCellReuseIdentifier: cellFinshID)
        DownloadManager.setDownloadStatusChangedDelegate(self)
        // 1、设置网络状态消息监听 2、获得网络Reachability对象
//        NotificationCenter.default.addObserver(self, selector: #selector(self.reachabilityChanged),name: ReachabilityChangedNotification,object: reachability)
//        do{
//            // 3、开启网络状态消息监听
//            try reachability.startNotifier()
//        }catch{
//            MYLog("could not start reachability notifier")
//        }
        
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none  
    }
    ///更新下载列表和完成列表
    func updataTableForData(_ isDowning : Bool)  {
        self.isDownloading = isDowning
        self.endEditing(false)
        
        if isDowning {
            ///从数据库获取下载数据
            var temploadArray =  MFMDBTool.shareInstance.listDataFromDownloaingTable()
            MDownDataUtils.checkTheDownListVideoState(&temploadArray)
            self.downDataArray = temploadArray
        }else{
            self.downFinshArray.removeAll()
            self.downFinshArray = MFMDBTool.shareInstance.listDataFromFinshTable()
            
        }
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isDownloading {
            return self.downDataArray.count
 
        }
        return self.downFinshArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isDownloading {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellDownID) as! MDownTableViewCell
            cell.selectionStyle = .none
            let model = self.downDataArray[indexPath.row]
            cell.stateButton?.tag = 520 + indexPath.row
            cell.stateButton?.addTarget(self, action: #selector(changeStatrForButtonEvent(sender:)), for: .touchUpInside)
            cell.cellForModel(model)
            self.startDownloadWithModel(model)
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: cellFinshID) as! MFinshTableViewCell
            cell.selectionStyle = .none
            let model = self.downFinshArray[indexPath.row]
            cell.stateButton?.tag = 1040 + indexPath.row
            cell.stateButton?.addTarget(self, action: #selector(playViewWithModel(sender:)), for: .touchUpInside)
            cell.cellForModel(model)
            return cell
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCellEditingStyle {
        return .delete
    }
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        self .setEditing(editing, animated: animated)
//    }
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "移除"
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        DownloadManager.init(LibraryFor96k) {[weak self] (merror) in
            if (merror == nil) {
                MDownDataUtils.downloadInfoM = DownloadManager.listDownloadInfos()
                self?.beginUpdates()
                if (self?.isDownloading)! {
                    ///删除下载的部分
                    let downingModel = self?.downDataArray[indexPath.row]
                    let downInfo = MDownDataUtils.mgetCurrentDownInfoModel((downingModel?.videoUrl!)!)
                    if downInfo.status != 0 {
                        //说明下载器里有这个下载任务再移除
                        DownloadManager.delete(downInfo.id)
                    }
                    MFMDBTool.shareInstance.removeDownloadingModel((downingModel?.kPointID!)!)
                }else{
                    ///删除本地文件
                    let finshModel = self?.downFinshArray[indexPath.row]
                    let downInfo = MDownDataUtils.mgetCurrentDownInfoModel((finshModel?.videoUrl!)!)
                    DownloadManager.delete(downInfo.id)
                    MFMDBTool.shareInstance.removeFinshModel((finshModel?.kPointID!)!)
                }
                self?.endUpdates()
                self?.loadDataArray()
            }
        }
        
    }
    
    /// 下载器的代理事件
    ///
    /// - Parameter downloadInfo: 每个下载任务的下载 model
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
    
    /// 刷新单元格数据
    ///
    /// - Parameter downInfo: 下载 model
    private func reloadIndexPathOfRow(_ downInfo : DownloadInfo)  {
        autoreleasepool { () -> () in
            if !isDownloading {
               return
            }
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
    
    /// 下载完成调用,刷新数据和开启下一个任务
    ///
    /// - Parameter downloadInfo: 下载器 model
    private func checkDownloadComplete(_ downloadInfo : DownloadInfo) {
        ///将下载任务加入到完成的数据列表中
        MDownDataUtils.handleDownCompleteData(downloadInfo)
        ///重新调用数据源
        loadDataArray()
        ///如果还有数据,且有正在等待下载任务,就开启
        startDownloadTask()
        
    }
    
    ///将数据重新刷新
    private func loadDataArray(){
        self.downDataArray.removeAll()
        self.downDataArray = MFMDBTool.shareInstance.listDataFromDownloaingTable()
        if self.isDownloading {
            
            self.reloadData()
            
        }else{
            ///已切换到完成界面
            self.updataTableForData(self.isDownloading)
        }
    }
    
    ///手动改变下载任务的状态
    @objc private func changeStatrForButtonEvent(sender : UIButton){
    
        let row = sender.tag - 520
        let downModel = self.downDataArray[row]
        ///点击逻辑操作
        let state = MDownDataUtils.checkVideoStateFromButtonEvent(downDataArray: &self.downDataArray, row: row)
        ///状态小于3说明下载器中无下载任务,要初始化当前下载信息
        if state < 3 {
           self.startDownloadWithModel(downModel)
        }
    }
    ///点击播放按钮执行代理
    @objc private func playViewWithModel(sender:UIButton){
        let model = self.downFinshArray[sender.tag - 1040]
        self.playLocalVidelDelgate?.playVideoWithVideoModel(model: model)
    }
    
    ///网络检测
    @objc private func reachabilityChanged(note: NSNotification){
//        let reachability = note.object as! Reachability // 准备获取网络连接信息
//        if reachability.isReachable { // 判断网络连接状态
//            MYLog("网络连接：可用")
//            if reachability.isReachableViaWiFi { // 判断网络连接类型
//                MYLog("连接类型：WiFi")
//                if self.isFirst {
//                    startDownloadTask()
//                    self.loadDataArray()
//                }
//                self.isFirst = true
//                
//            } else {
//                MYLog("连接类型：移动网络")
//                MDownDataUtils.handel4GChangeFromNet()
//                self.loadDataArray()
//            }
//        } else {
//            MYLog("网络连接：不可用")
//            MDownDataUtils.handleNoNetFromNer()
//            self.loadDataArray()
//        }
        
    }
    ///开启下一个下载任务
    private func startDownloadTask(){
        let downArray = MFMDBTool.shareInstance.listDataFromDownloaingTable()
        if downArray.count > 0 {
            for item in downArray {
                let downloadInfo = MDownDataUtils.mgetCurrentDownInfoModel(item.videoUrl!)
                MYLog(downloadInfo.status)
                if (downloadInfo.status == STATUS_PAUSED || downloadInfo.status == STATUS_ERROR || downloadInfo.status == STATUS_STOPPED) && (!item.isManualSuspen) {
                    item.videoState = Int(STATUS_DOWNLOADING)
                    self.startDownloadWithModel(item)
                    MFMDBTool.shareInstance.updataDownloadState(item)
                    break;
                }
                
            }
        }
    }
    
    ///开启下载
    private func startDownloadWithModel(_ model : DownloadingModel){
        
        let wifi = MNetworkUtils.isEnableWIFI()
        let haveNet = !MNetworkUtils.isNoNet()
        let wwan = MNetworkUtils.isEnableWWAN()
        ///是 WiFi 情况并且网络可用,如果下载器没状态,或者手动改变状态,开启下载
        if ((wifi && haveNet) && ( model.videoState == Int(STATUS_DOWNLOADING))) {
            
            MDownDataUtils.startDownloadTaskWithModel(model)
            
        } else if (wwan && haveNet) && ( model.videoState == Int(STATUS_DOWNLOADING)) {
            //当前4G 网络
            let alertControl = UIAlertController.init(title: "提示", message: "当前4G网络是否下载?", preferredStyle: .alert)
            let allow = UIAlertAction.init(title: "是", style: .default, handler: { (action) in
                MDownDataUtils.startDownloadTaskWithModel(model)
            })
            
            let cancel = UIAlertAction.init(title: "否", style: .cancel, handler: {[weak self](action) in
                model.videoState = Int(STATUS_PAUSED)
                model.isManualSuspen = true
                ///每一次操作都要更新数据库,来保存相应的数据
                MFMDBTool.shareInstance.updataDownloadState(model)
                self?.loadDataArray()
            })
            alertControl.addAction(allow)
            alertControl.addAction(cancel)
            viewControlM?.present(alertControl, animated: true, completion: nil)
        }
        
    }
    

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
