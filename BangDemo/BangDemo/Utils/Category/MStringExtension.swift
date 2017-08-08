//
//  MStringExtension.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/4.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation

extension String {
    
    func deletSpaceInString() -> String{
        ///去掉首尾空格 包括后面的换行 \n
        let content = self.trimmingCharacters(in: .whitespacesAndNewlines)
        ///将空格替换成""
        let replace = content.replacingOccurrences(of: " ", with: "")
        
        return replace
    }
    
}
