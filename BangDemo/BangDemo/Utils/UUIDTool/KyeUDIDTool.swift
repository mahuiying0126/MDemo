//
//  KyeUDIDTool.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/8.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation
private var UUID : String?

public func getUUID()->String{
    
    
    let UUIDDate = SSKeychain.passwordData(forService: "com.magic", account: "com.magic")
    
    
    if UUIDDate != nil{
        
        UUID = NSString(data: UUIDDate!, encoding: String.Encoding.utf8.rawValue)! as String
    }
    
    
    if(UUID == nil){
        
        UUID = UIDevice.current.identifierForVendor!.uuidString as String
        
        SSKeychain.setPassword(UUID! as String, forService: "com.magic", account: "com.magic")
        
    }
   
    return UUID! as String
    
}

