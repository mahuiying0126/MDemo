//
//  MNetRequestSeting.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/9.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import SwiftyJSON

class MNetRequestSeting: NSObject {
    
    
    /// 缓存设置
    ///
    /// - MCacheNoSave: 不缓存数据
    /// - MCacheSave: 缓存数据
    enum MCacheSeting {
        case MNoSave
        case MSave
    }
    /// 网络请求方式
    ///
    /// - MRequestMethodPOST: POST请求
    /// - NRequestMethodGET: GET请求
    enum MRequesttMethod {
        case MRequestMethodPOST
        case NRequestMethodGET
    }
    
    /** *是否显示 HUD */
    var isHidenHUD : Bool = false
    /** *是否是HTTPS请求,默认是NO */
    var isHttpsRequest : Bool = false
    /** *是否刷新数据 */
    var isRefresh : Bool = false
    /** *缓存设置策略 */
    var cashSeting : MCacheSeting?
    /** *请求方式,默认POST请求 */
    var requestStytle : MRequesttMethod?
    /** *缓存时间 */
    var cashTime : NSInteger = 0
    /** *请求地址 */
    var hostUrl : String?
    /** *参数 */
    var paramet : [String:Any]?
    /** *验证json格式 */
    var jsonValidator : Any?
    
    final func requestDataFromNetSet(seting:MNetRequestSeting,successBlock : @escaping (_ response : JSON)->(), failture : @escaping (_ error : Error)->()) {
        
        let HUD = MBProgressHUD.showAdded(to: UIApplication.shared.windows.last!, animated: true)
        HUD.label.text = "正在加载"
        HUD.animationType = .fade
        HUD.show(animated: true)
        HUD.isHidden = seting.isHidenHUD
        if seting.cashSeting == .MSave{
            ///设置了缓存,如果没有设置缓存时间,默认3分钟缓存时间
            let path = self.cacheFilePath()
            let fileManager = FileManager.default
            ///检测文件路径存不存在
            let isFileExist = fileManager.fileExists(atPath: path)
            ///将以前缓存的数据取出
            let data = NSKeyedUnarchiver.unarchiveObject(withFile: path)
            ///如果没有网络,以前有缓存则直接返回缓存的
            if MNetworkUtils.isNoNet() {
                if isFileExist {
                    let response = JSON(data!)
                    if (!response.isEmpty) {
                        successBlock(response)
                    }
                    
                    HUD.removeFromSuperview()
                    return
                }else{
                    HUD.removeFromSuperview()
                    MBProgressHUD.showError("已于网络断开连接")
                    return
                }
                
            }
            ///如果存在,再检查文件有没有过期,日期间隔根据自己定的
            if isFileExist && !seting.isRefresh {
                
                if (data != nil) {
                    let time = MNetworkUtils.compareTime(currentTime: self.getCurrentTime(), fileCreatTime: self.getFileCreateTime())
                    if time == 1 {
                        ///当前时间超过文件创建时间,刷新数据
                        MNetRequest.netRequest(requestSet: seting, success: { [weak self](responseData) in
                            
                            ///进行本地保存
                            self?.saveCashDataForArchiver(response: responseData, seting: seting)
                            ///将请求数据进行 json 转换
                            let response = JSON(responseData)
                            if (seting.jsonValidator != nil){
                                let result = MNetworkUtils.validateJSON(json: responseData, jsonValidator: seting.jsonValidator!)
                                if result {
                                    successBlock(response)
                                }
                            }else{
                                
                                successBlock(response)
                            }
                            
                            HUD.removeFromSuperview()
                            
                            }, failture: { (error) in
                                HUD.mode = .text
                                HUD.label.text="请求失败,重新发送请求"
                                HUD.removeFromSuperview()
                        })
                    }else{
                        //文件创建时间小于当前时间,返回缓存数据
                        
                        let response = JSON(data!)
                        successBlock(response)
                        HUD.removeFromSuperview()
                    }
                    
                }
            }else{
                MNetRequest.netRequest(requestSet: seting, success: { [weak self](responseData) in
                    
                    ///保存数据
                    self?.saveCashDataForArchiver(response: responseData, seting: seting)
                    let respon = JSON(responseData)
                    if (seting.jsonValidator == nil) {
                        
                        successBlock(respon)
                    }else{
                        let result = MNetworkUtils.validateJSON(json: responseData, jsonValidator: seting.jsonValidator!)
                        if result {
                            successBlock(respon)
                        }
                    }
                    
                    HUD.removeFromSuperview()
                    }, failture: { (error) in
                        HUD.mode = .text
                        HUD.label.text="请求失败,重新发送请求"
                        HUD.removeFromSuperview()
                        
                })
            }
        } else{
            ///默认,不缓存
            if MNetworkUtils.isNoNet() {
                HUD.removeFromSuperview()
                MBProgressHUD.showError("已于网络断开连接")
                return
            }
            MNetRequest.netRequest(requestSet: seting, success: {(responseData) in
                
                if (seting.jsonValidator != nil){
                    let result = MNetworkUtils.validateJSON(json: responseData, jsonValidator: seting.jsonValidator!)
                    if result {
                        let response = JSON(responseData)
                        successBlock(response)
                    }
                }else{
                    let response = JSON(responseData)
                    successBlock(response)
                }
                
                HUD.removeFromSuperview()
                
            }, failture: { (error) in
                HUD.mode = .text
                HUD.label.text="请求失败,重新发送请求"
                HUD.removeFromSuperview()
            })
        }
        
    }
    
    func requestDataForSynchronous(hostUrl:String) -> JSON {
        
        
        let url = URL(string:hostUrl)
        //创建请求对象
        let request = URLRequest(url: url!)
        let session = URLSession.shared
        var responDic = NSDictionary()
        let semaphore = DispatchSemaphore(value: 0)
        let dataTask = session.dataTask(with: request,completionHandler: {(data, response, error) -> Void in
            if error != nil{
                print(error!)
            }else{
                
                responDic = try! JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! NSDictionary
            }
            semaphore.signal()
        }) as URLSessionTask
        
        //使用resume方法启动任务
        dataTask.resume()
        _ = semaphore.wait(timeout: DispatchTime.distantFuture)
        return JSON(responDic)
    }
    
    
    
    ///将数据保存到本地
    private func saveCashDataForArchiver(response : [String : AnyObject],seting:MNetRequestSeting){
        let path = self.cacheFilePath()
        
        do {
            if(seting.jsonValidator == nil){
                ///没有验证直接存储
                NSKeyedArchiver.archiveRootObject(response, toFile: path)
            }else{
                let result = MNetworkUtils.validateJSON(json: response, jsonValidator: seting.jsonValidator!)
                if result {
                    NSKeyedArchiver.archiveRootObject(response, toFile: path)
                }else{
                    ///格式不正确
                    let fileManager = FileManager.default
                    let isFileExist = fileManager.fileExists(atPath: path)
                    if isFileExist {
                        try fileManager.removeItem(atPath: path)
                    }
                }
            }
            
            
        } catch let err as NSError {
            print(err.description)
        }
        
    }
    ///文件路径
    private func cacheFilePath() -> String{
        let cacheFileName = self.cacheFileName()
        let path = self.cacheBasePath()
        return path + "/" + cacheFileName
    }
    
    //将请求路径和参数拼接成文件名称
    private func cacheFileName() -> String {
        var requestInfo = String()
        if self.paramet != nil {
            requestInfo = String.init(format: "%@","%@", self.hostUrl!,self.paramet!)
        }else{
            requestInfo = self.hostUrl!
        }
        
        return MNetworkUtils.md5StringFromString(string: requestInfo)
    }
    ///根路径
    private func cacheBasePath() -> String{
        
        let cachePath =  NSHomeDirectory() + "/Library/Caches"
        
        let path = cachePath + "/MLazyRequestCache"
        let fileManager = FileManager.default
        var isDir : ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDir) {
            if !isDir.boolValue {
                ///删除原来的,再创建
                try? fileManager.removeItem(atPath: path)
                self.createBaseDirectoryAtPath(path: path)
            }
        }else{
            ///文件不存在,创建
            self.createBaseDirectoryAtPath(path: path)
        }
        
        return path
        
    }
    ///创建文件夹
    private func createBaseDirectoryAtPath(path : String) {
        
        try? FileManager.default.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
    }
    
    ///获取当前时间
    private func getCurrentTime() -> Date {
        let formatter = DateFormatter()
        formatter.date(from: "dd-MM-yyyy-HHmmss")
        let dateTime = formatter.string(from: Date())
        let date = formatter.date(from: dateTime)
        let time : TimeInterval = TimeInterval(self.cashTime > 0 ? 3 * 60 : self.cashTime * 60)
        let currentTime = date?.addingTimeInterval(-time)
        return currentTime!
    }
    ///获取文件夹创建时间
    private func getFileCreateTime() -> Date{
        let path = self.cacheFilePath()
        let fileManager = FileManager.default
        let fileAttributes = try! fileManager.attributesOfItem(atPath: path)
        let fileCreateDate = fileAttributes[FileAttributeKey.creationDate]
        
        return fileCreateDate as! Date
    }
    
}
