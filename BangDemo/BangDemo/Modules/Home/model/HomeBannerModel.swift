//
//  HomeBannerModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/18.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
class HomeBannerModel: NSObject {
    
    var ID : String?
    var courseId : String?
    var title : String?
    var keyWord : String?
    var seriesNumber : String?
    var color : String?
    var previewUrl : String?
    var imagesUrl : String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
      
        return ["ID":"id"]
    }
    
    func loadingBannerData(success : @escaping (_ response : NSMutableArray)->()){
        
        MNetworkRequest.sharedInstance.postRequestNoparam(urlString: advertisement() as String, success: {(requestData) in
            let responseData = JSON(requestData)
            if(responseData["success"].boolValue && responseData["entity"].dictionary != nil){
                let entity = responseData["entity"]
                if(entity["indexCenterBanner"].array != nil){
                    let indexCenterBanners = entity["indexCenterBanner"]
                    //mj转模型
                    let adviertArray = HomeBannerModel.mj_objectArray(withKeyValuesArray: indexCenterBanners.rawValue)
                    //bunder图片
                    if(adviertArray != nil) {
                        success(adviertArray!)
                    }
                }
            }
        }) { (error) in}
    }

    
}
