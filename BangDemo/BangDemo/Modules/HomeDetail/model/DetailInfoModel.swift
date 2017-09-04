//
//  DetailInfoModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/1.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class DetailInfoModel: NSObject {
    
    /// *当前课程的 id
    var currentCourseId : String?
    
    /// *当前课程的节点
    var defaultKpointId : String?
    
    /// *是否有音频
    var haveAudio : Bool = false
    
    /// *是否收藏,否,收藏
    var isFav : Bool = false
    
    /// *是否有视频
    var haveVideo : Bool = false
    
    /// *是否购买
    var isok : Bool = false
    
    
}
