//
//  MNetworkTool.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/10.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation
import UIKit
import Alamofire



private let MNetworkRequestShare = MNetworkRequest()

class MNetworkRequest {
    class var sharedInstance : MNetworkRequest {
        return MNetworkRequestShare
    }
}
extension MNetworkRequest {
    //MARK: - GET 请求
    func getRequest(urlString: String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        
        Alamofire.request(urlString, method: .get, parameters: params)
            .responseJSON { (response) in
                
                switch response.result {
                case .success(let value):
                    
                    success(value as! [String : AnyObject])
                    
                case .failure(let error):
                    failture(error)
                }
        }
        
    }
    //MARK: - POST 请求
    func postRequest(urlString : String, params : [String : Any], success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
      
        let HUD = MBProgressHUD.showAdded(to: UIApplication.shared.windows.last!, animated: true)
        HUD.label.text = "正在加载"
        HUD.animationType = .fade
        HUD.show(animated: true)
        
        printRequestUrlString(urlString: urlString, Paramter: params as NSDictionary)
        
        Alamofire.request(urlString, method: .post, parameters: params).responseJSON { (response) in
            switch response.result{
            case .success:
                
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                }
                HUD.removeFromSuperview()
            case .failure(let error):
                failture(error)
                HUD.mode = .text
                HUD.label.text="请求失败,重新发送请求"
                HUD.removeFromSuperview()
            }
            
        }
    }
    
    //MARK: - POST 无参数请求
    func postRequestNoparam(urlString : String, success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        let HUD = MBProgressHUD.showAdded(to: UIApplication.shared.windows.last!, animated: true)
        HUD.label.text = "正在加载"
        HUD.animationType = .fade
        HUD.show(animated: true)
        MYLog(urlString)
        Alamofire.request(urlString, method: .post).responseJSON { (response) in
            switch response.result{
            case .success:
                if let value = response.result.value as? [String: AnyObject] {
                    success(value)
                }
                HUD.removeFromSuperview()

            case .failure(let error):
                failture(error)
                HUD.mode = .text
                HUD.label.text="请求失败,重新发送请求"
                HUD.removeFromSuperview()
            }
            
        }
    }

}

func printRequestUrlString(urlString:String,Paramter:NSDictionary) {
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
    
}


