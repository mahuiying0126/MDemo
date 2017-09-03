//
//  MStringExtension.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/4.
//  Copyright © 2017年 Magic. All rights reserved.
//

import Foundation
import SwiftyJSON
extension String {
    
    
    /// 去除文字中的空格
    ///
    /// - Returns: 返回替换好的文字
    func deletSpaceInString() -> String{
        
        ///去掉首尾空格 包括后面的换行 \n
        let content = self.trimmingCharacters(in: .whitespacesAndNewlines)
        ///将空格替换成""
        let replace = content.replacingOccurrences(of: " ", with: "")
        
        return replace
    }
    
    /// 文字段落样式
    ///
    /// - Parameters:
    ///   - font: 文字大小
    ///   - color: 文字颜色
    ///   - headIndent: 首行缩进的距离
    /// - Returns: 设置的好的NSAttributedString文字段落
    func getParagraphStyle(font:CGFloat,color:UIColor,headIndent:CGFloat) -> NSAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        ///字体的行间距
        paragraphStyle.lineSpacing = 1.5
        ///首行缩进
        paragraphStyle.firstLineHeadIndent = headIndent
        ///（两端对齐的）文本对齐方式：（左，中，右，两端对齐，自然）
        paragraphStyle.alignment = .justified
        ///结尾部分的内容以……方式省略 ( "...wxyz" ,"abcd..." ,"ab...yz")
        paragraphStyle.lineBreakMode = .byWordWrapping
        ///最低行高
        paragraphStyle.maximumLineHeight = 10.0
        ///最大行高
        paragraphStyle.maximumLineHeight = 20.0;
        ///段与段之间的间距
        ///paragraphStyle.paragraphSpacing = 5
        ///段首行空白空间
        /// paragraphStyle.paragraphSpacingBefore = 22.0
        ///书写方向,一共三种
        paragraphStyle.baseWritingDirection = .leftToRight
        ///行高
        paragraphStyle.lineHeightMultiple = 15
        
        let dic = [NSParagraphStyleAttributeName : paragraphStyle,
                   NSFontAttributeName: UIFont.systemFont(ofSize: font),
                   NSForegroundColorAttributeName : color]
        let text = NSAttributedString.init(string: self, attributes: dic)
        
        return text
    }
    
    func checkPointIsAbleToPlay() ->  JSON{
        
        let checkPoint = MNetRequestSeting()
        let host = checkKpoint()
        let paramter = ["kpointId":self,"userId":USERID,"uuId":KEY_UUID]
        checkPoint.hostUrl = MNetworkUtils.printRequestUrlString(urlString: host, Paramter: paramter as NSDictionary)
        let poindInfo = checkPoint.requestDataForSynchronous(checkPoint)
        
        return JSON(poindInfo)
        
        
    }
    
    
}
