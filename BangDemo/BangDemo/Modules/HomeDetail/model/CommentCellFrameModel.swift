//
//  CommentCellFrameModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/4.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class CommentCellFrameModel: NSObject {
    /** *评论数据 */
    var model : CommentUserModel?
    /** *图片位置 */
    var imageFrame :  CGRect?
    /** *名字位置 */
    var nameFrame :  CGRect?
    /** *评论时间位置 */
    var timeFrame : CGRect?
    /** *评论位置 */
    var contentFrame :  CGRect?
    /** *分割线位置 */
    var lineFrame :  CGRect?
    /** *行高 */
    var cellHeight :  CGRect?
    
    private let spacingM : CGFloat = 10
    private let maxWith = (Screen_width - 5 * 10) * 0.5
    
    func setCellModel(_ cellModel : CommentUserModel) -> CommentCellFrameModel {
        let frameModel   = CommentCellFrameModel()
        frameModel.model = cellModel
        ///定义图片宽高是40,边距是15
        frameModel.imageFrame = CGRect.init(x: Spacing_width, y: Spacing_heght, width: 40, height: 40)
        var name = ""
        
        if ((cellModel.nickname?.deletSpaceInString().characters.count)! > 0) {
            name = cellModel.nickname!
        }else if((cellModel.mobile?.deletSpaceInString().characters.count)! > 0){
           name = cellModel.mobile!
            
        }else if((cellModel.email?.deletSpaceInString().characters.count)! > 0){
            name = cellModel.email!
        }else{
            name = "匿名用户"
        }
        
//        let name_x = (frameModel.imageFrame?.maxX)! + spacingM
//        let name_y = frameModel.imageFrame?.minY
//        let tmpSize = CGSize.init(width: maxWith, height: CGFloat(MAXFLOAT))
        
        
        
        
       return frameModel
    }
}
