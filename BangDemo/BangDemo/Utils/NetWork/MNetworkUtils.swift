//
//  MNetworkUtils.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/10.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import Alamofire
class MNetworkUtils: NSObject {
    
    final class func compareTime(currentTime:Date,fileCreatTime:Date) -> NSInteger{
        let dateFormatter = DateFormatter()
        dateFormatter.date(from: "dd-MM-yyyy-HHmmss")
        let currentStr = dateFormatter.string(from: currentTime)
        let fileStr = dateFormatter.string(from: fileCreatTime)
        let currentDate = dateFormatter.date(from: currentStr)
        let fileDate = dateFormatter.date(from: fileStr)
        let result = currentDate?.compare(fileDate!)
        var aaa = 0
        if result == .orderedDescending {
            aaa = 1
        }else if result == .orderedAscending {
            aaa = -1
        }
        
        return aaa
    }
    
    ///MD5加密
    final class func md5StringFromString(string : String) -> String {
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
    
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deinitialize()
        
        return String(format: hash as String)
    }
    
    /// json 格式校验
    final class func validateJSON(json:Any,jsonValidator:Any) -> Bool {
        if json is NSDictionary && jsonValidator is NSDictionary {
            let dict : NSDictionary = json as! NSDictionary
            let validator : NSDictionary = jsonValidator as! NSDictionary
            var result = true
            let enumerator = validator.keyEnumerator()
            var key = String()
            
            while(enumerator.nextObject() != nil) {
                key = enumerator.nextObject() as! String
                let value = dict[key]
                let mformats : Any = validator[key]!
                if value is NSDictionary || value is NSArray {
                    result = self.validateJSON(json: value!, jsonValidator: mformats)
                    if !result{
                        break
                    }
                }else{
                    if (value is NSNull) == false && ((value as AnyObject).isKind(of: mformats as! AnyClass)) == false {
                        result = false
                        break
                    }
                }
            }
            return result
        }else if (json is NSArray && jsonValidator is NSArray){
            let validatorArray : NSArray = jsonValidator as! NSArray
            
            if validatorArray.count > 0 {
                let array : NSArray = json as! NSArray
                let validator = validatorArray[0]
                for item in array {
                    let result = self.validateJSON(json: item, jsonValidator: validator)
                    if (!result) {
                        return false
                    }
                    
                }
            }
            return true
        }else if (((json as AnyObject).isKind(of: jsonValidator as! AnyClass))) {
            return true
        }else{
        return false
        }
    }
    
    ///打印请求路径
    final class func printRequestUrlString(urlString:String,Paramter:NSDictionary) -> String{
        let dicKeysArray = Paramter.allKeys
        var urlWithParamterString = urlString
        
        if dicKeysArray.count > 0 {
            urlWithParamterString = urlWithParamterString.appending("?")
        }
        
        for key in 0 ..< dicKeysArray.count {
            urlWithParamterString = urlWithParamterString.appendingFormat("%@=%@&", dicKeysArray[key] as! CVarArg,Paramter[dicKeysArray[key]] as! CVarArg)
            if key == dicKeysArray.count - 1 {
                urlWithParamterString = (urlWithParamterString as NSString).substring(with: NSRange.init(location: 0, length: urlWithParamterString.characters.count - 1))
            }
        }
        MYLog(urlWithParamterString)
        return urlWithParamterString
    }
    
    ///WIFI 是否可用
    final class func isEnableWIFI() -> Bool {
    
        let netReachability = NetworkReachabilityManager()?.networkReachabilityStatus
        if netReachability == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.ethernetOrWiFi) {
        return true
    }
    
    return false
    }
    
    ///WWAN 是否可用
    final class func isEnableWWAN() -> Bool {
        let netReachability = NetworkReachabilityManager()?.networkReachabilityStatus
        if netReachability == NetworkReachabilityManager.NetworkReachabilityStatus.reachable(.wwan) {
            return true
        }
        return false
    }
    ///网络是否可用; YES->网络不可用
    final class func isNoNet()->Bool {
        let netReachability = NetworkReachabilityManager()?.networkReachabilityStatus
        if netReachability == NetworkReachabilityManager.NetworkReachabilityStatus.notReachable {
            return true
        }
        return false
    }
    
        
        
        

        
        
    
}


