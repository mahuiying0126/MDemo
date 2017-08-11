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
    
    func loadingBannerData(success : @escaping (_ response : NSMutableArray)->(),failture : @escaping (_ error : Error)->()){
        
        let bunder = MNetRequestSeting()
        bunder.hostUrl = advertisement()
        bunder.cashSeting = .MSave
        bunder.isHidenHUD = true
        bunder.requestDataFromHostURL(seting: bunder, successBlock: { (responseData) in
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
        }) { (error) in
            failture(error)
        }
        
        
    }

    
}
