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
    var cellHeight :  CGFloat?
    
    private let spacingM : CGFloat = 10
    private let maxWith = (Screen_width - 5 * 10) * 0.5
    private var font15 = UIFont.systemFont(ofSize: 15)
    private var font13 = UIFont.systemFont(ofSize: 13)
    func cellFrameModel(_ cellModel : CommentUserModel) -> CommentCellFrameModel {
        let frameModel   = CommentCellFrameModel()
        frameModel.model = cellModel
        ///定义图片宽高是40,边距是15
        ///图片 frame
        frameModel.imageFrame = .init(x: Spacing_width15, y: Spacing_heght15, width: 40, height: 40)
        
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
        let name_x = (frameModel.imageFrame?.maxX)! + spacingM
        let name_y = frameModel.imageFrame?.minY
        let name_w = (name as NSString).widthForFont(font: &font15)
        ///昵称 frame
        frameModel.nameFrame = .init(x: name_x, y: name_y!, width: name_w, height: 18)
        
        let time_w = (cellModel.createTime! as NSString).widthForFont(font: &font13)
        let time_x = Screen_width - Spacing_heght15 - time_w
        ///时间 frame
        frameModel.timeFrame = .init(x: time_x, y: name_y!, width: time_w, height: 18)
        
        let content_y = (frameModel.timeFrame?.maxY)! + spacingM
        
        let conttempSize = CGSize.init(width: Screen_width - name_x - 15.0, height: CGFloat(MAXFLOAT))
        
        let contentSize = (cellModel.content! as NSString).sizeForFont(font: &font15, size: conttempSize, lineBreakMode: .byCharWrapping)
        
        ///评论内容 frame
        frameModel.contentFrame = .init(x: name_x, y: content_y, width: contentSize.width, height:contentSize.height)
        
        let line_y = (frameModel.contentFrame?.maxY)! + Spacing_heght15
        
        ///分割线 frame
        frameModel.lineFrame = CGRect.init(x: 0, y: line_y, width: Screen_width, height: 1.0)
        ///cell 高度 frame
        frameModel.cellHeight = frameModel.lineFrame?.maxY
        
        
       return frameModel
    }
}
