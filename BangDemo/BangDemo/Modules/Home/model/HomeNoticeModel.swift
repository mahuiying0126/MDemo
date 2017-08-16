//
//  HomeNoticeModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/19.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
class HomeNoticeModel: NSObject {

    var hotArticle : String?
    var ID : String?
    var isShowType : String?
    var status : String?
    var title : String?
    var descrip : String?
    var picture : String?
    

    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        
        return ["ID":"id","descrip":"description"]
    }

    //MARK: 加载公告数据
    func loadNoticeData(success: @escaping(_ response : Array<Any>) -> (),failture : @escaping (_ error : Error)->() )  {
    
        let notic = MNetRequestSeting()
        notic.hostUrl = homeNote()
        notic.cashSeting = .MSave
        notic.isHidenHUD = true
        notic.requestDataFromNetSet(seting: notic, successBlock: { (responseData) in
            if (responseData.dictionary != nil)  {
                if(responseData["success"].boolValue){
                    if(responseData["entity"].array != nil){
                        let entity = responseData["entity"];
                        let noticeArray = HomeNoticeModel.mj_objectArray(withKeyValuesArray: entity.rawValue)
                        if(noticeArray != nil){
                            success(noticeArray as! Array<Any>)
                        }
                    }
                }
            }
        }) { (error) in
           failture(error)
        }
        
    }

    
}
