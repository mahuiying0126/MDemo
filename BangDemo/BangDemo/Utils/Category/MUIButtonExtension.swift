//
//  MUIButtonExtension.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/4.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation

enum ButtonEdgeInsetsStyle {
    case ButtonEdgeInsetsStyleTop // image在上，label在下
    case ButtonEdgeInsetsStyleLeft // image在左，label在右
    case ButtonEdgeInsetsStyleBottom // image在下，label在上
    case ButtonEdgeInsetsStyleRight // image在右，label在左
}

extension UIButton {
    
    /// 返回一个button
    ///
    /// - Parameters:
    ///   - title: *button标题
    ///   - image: *图片
    ///   - selectImage: *被选中的图片
    ///   - backGroundColor: *背景色
    ///   - Frame: *button大小fream
    /// - Returns: *返回一个button
    func buttonTitle(title:String,image:String,selectImage:String,backGroundColor:UIColor,Frame:CGRect) -> UIButton {
        let button = UIButton.init(type: .custom)
        button.frame = Frame
        button.backgroundColor = backGroundColor
        button .setTitle(title, for: .normal)
        button.setImage(UIImage.init(named: image), for: .normal)
        button.setImage(UIImage.init(named: selectImage), for: .selected)
        return button
    }
    
    /// 将button文字与图片,上下左右布局
    ///
    /// - Parameters:
    ///   - style: *文字与图片的方式
    ///   - imageTitleSpace: *文字与图片之间的间距
    func layoutButtonWithEdgeInsetsStyle(style:ButtonEdgeInsetsStyle,imageTitleSpace:CGFloat)  {
        // 1. 得到imageView和titleLabel的宽、高
        let imageWith = self.imageView?.frame.size.width
        let imageHeight = self.imageView?.frame.size.height
        var labelWidth : CGFloat
        var labelHeight :CGFloat
        
        if (Double.init(UIDevice.current.systemVersion)! >= 8.0) {
            // 由于iOS8中titleLabel的size为0，用下面的这种设置
            labelWidth = (self.titleLabel?.intrinsicContentSize.width)!
            labelHeight = (self.titleLabel?.intrinsicContentSize.height)!
        }else{
            labelWidth = (self.titleLabel?.frame.size.width)!
            labelHeight = (self.titleLabel?.frame.size.height)!
        }
        // 2. 声明全局的imageEdgeInsets和labelEdgeInsets
        
        var imageEdgeInsets:UIEdgeInsets = .zero
        var labelEdgeInsets:UIEdgeInsets = .zero
        
        // 3. 根据style和space得到imageEdgeInsets和labelEdgeInsets的值
        switch style {
        case .ButtonEdgeInsetsStyleTop:
            imageEdgeInsets = UIEdgeInsetsMake(-labelHeight-imageTitleSpace/2.0, 0, 0, -labelWidth)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith!, -imageHeight! - imageTitleSpace/2.0, 0)
            break
        case .ButtonEdgeInsetsStyleLeft:
            imageEdgeInsets = UIEdgeInsetsMake(0, -imageTitleSpace/2.0, 0, imageTitleSpace/2.0)
            labelEdgeInsets = UIEdgeInsetsMake(0, imageTitleSpace/2.0, 0, -imageTitleSpace/2.0)
            break
            
        case .ButtonEdgeInsetsStyleBottom:
            imageEdgeInsets = UIEdgeInsetsMake(0, 0, -labelHeight-imageTitleSpace/2.0, -labelWidth)
            labelEdgeInsets = UIEdgeInsetsMake(-imageHeight!-imageTitleSpace/2.0, -imageWith!, 0, 0)
            break
        case .ButtonEdgeInsetsStyleRight:
            imageEdgeInsets = UIEdgeInsetsMake(0, labelWidth+imageTitleSpace/2.0, 0, -labelWidth-imageTitleSpace/2.0)
            labelEdgeInsets = UIEdgeInsetsMake(0, -imageWith!-imageTitleSpace/2.0, 0, imageWith!+imageTitleSpace/2.0)
            break
            
        }
        // 4. 赋值
        self.titleEdgeInsets = labelEdgeInsets
        self.imageEdgeInsets = imageEdgeInsets
        
    }
    
    
}
