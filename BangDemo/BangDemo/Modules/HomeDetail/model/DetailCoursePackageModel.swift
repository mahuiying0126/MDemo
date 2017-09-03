//
//  DetailCoursePackageModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/7/18.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class DetailCoursePackageModel: NSObject {

    /** *课程包ID */
    var ID : String?
    /** *课程包名字*/
    var name : String?
    /** *是否支付 */
    var isPay : Int = 0
    /** *losetype */
    var losetype : Int = 0
    /** *是否被选择 */
    var isSelect : Bool = false
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["ID":"id"]
    }
    
}
