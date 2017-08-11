//
//  MNetRequest.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/10.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import Alamofire
class MNetRequest: NSObject {
    
    final class func netRequest(requestSet : MNetRequestSeting, success : @escaping (_ response : [String : AnyObject])->(), failture : @escaping (_ error : Error)->()) {
        ///打印请求链接
        var parameter = [String : Any]()
        if requestSet.paramet != nil {
            MNetworkUtils.printRequestUrlString(urlString: requestSet.hostUrl!, Paramter: requestSet.paramet! as NSDictionary)
            parameter = requestSet.paramet!
        }else{
            MNetworkUtils.printRequestUrlString(urlString: requestSet.hostUrl!, Paramter: ["":""])
            parameter = ["Key":"Value"]
        }
        
        
        if requestSet.requestStytle == .MRequestMethodPOST {
            Alamofire.request(requestSet.hostUrl!, method: .post, parameters: parameter).responseJSON { (response) in
                switch response.result{
                case .success:
                    
                    if let value = response.result.value as? [String: AnyObject] {
                        success(value)
                    }
                case .failure(let error):
                    failture(error)
                    
                }
            }
        }else{
            Alamofire.request(requestSet.hostUrl!, method: .get, parameters: parameter).responseJSON { (response) in
                switch response.result{
                case .success:
                    
                    if let value = response.result.value as? [String: AnyObject] {
                        success(value)
                    }
                case .failure(let error):
                    failture(error)
                    
                }
            }
        }
    }
    
}
