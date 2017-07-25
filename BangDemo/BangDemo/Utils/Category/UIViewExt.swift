//
//  UIViewExt.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/24.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation

extension UIView{
    
    func createView(Fream:CGRect,BackgroundColor:UIColor) -> UIView {
        let view = UIView.init(frame: Fream)
        view.backgroundColor = backgroundColor
        
        return view
    }
    
}
