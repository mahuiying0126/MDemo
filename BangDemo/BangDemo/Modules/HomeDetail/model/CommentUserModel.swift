//
//  CommentUserModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/4.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class CommentUserModel: NSObject {

    /** *id*/
    var ID : Int?
    /** *用户 id */
    var userId : Int?
    /** *kpointId */
    var kpointId : Int?
    /** *状态 */
    var status : Int?
    /** *邮箱是否可用 */
    var emailIsavalible : Int?
    /** *手机是否可用 */
    var mobileIsavalible : Int?
    /** *昵称是否可用 */
    var isavalible : Int?
    /** *评论内容 */
    var content : String?
    /** *评论时间 */
    var createTime : String?
    /** *昵称 */
    var nickname : String?
    /** *邮箱 */
    var email :  String?
    /** *手机 */
    var mobile :  String?
    /** *用户ip 地址 */
    var userip : String?
    /** *短评论 */
    var shortContent :  String?
    /** *头像 */
    var avatar :  String?
    
    override static func mj_replacedKeyFromPropertyName() -> [AnyHashable : Any]! {
        return ["ID":"id"]
    }
}
