//
//  DetailTeacherListModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/2.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class DetailTeacherListModel: NSObject {
    
    var ID : String?
    var name : String?
    var isStar : String?
    var picPath : String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        
        return ["ID":"id"]
    }
}
