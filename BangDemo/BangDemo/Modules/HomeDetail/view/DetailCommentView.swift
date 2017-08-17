//
//  DetailCommentView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/25.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
@objc protocol addCommentCompleteDelegate {
    func addCommentComplete()
}
class DetailCommentView: UITableView ,UITableViewDelegate,UITableViewDataSource{

    
    /** *发送视图 */
    var commentHead : MCommentHeadView?
    
    private var courseId : String?
    private var pointId : String?
    /** *课程评论数据 */
    var commentData = Array<Any>()
    ///提交评论的代理
    weak var commentCompleteDelegate : addCommentCompleteDelegate?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        commentHead = MCommentHeadView.init(frame:.init(x: 0, y: 0, width: Screen_width, height: 130))
        self.tableHeaderView = commentHead
        commentHead?.addCommentButton?.addTarget(self, action: #selector(addComment), for: .touchUpInside)
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    func commentData(_ data : Array<Any>,courseID:String,pointID:String)  {
        self.courseId = courseID
        self.pointId = pointID
        self.commentData.removeAll()
        for model in data {
            let cellFrame = CommentCellFrameModel().cellFrameModel(model as! CommentUserModel)
            self.commentData.append(cellFrame)
        }
        
        self.reloadData()
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  self.commentData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CommentID"
        let cell = MCommentTableViewCell.init(style: .default, reuseIdentifier: cellID)
        
        let cellFrame = self.commentData[indexPath.row] as!CommentCellFrameModel
        cell.updatCellFrame(model: cellFrame)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellFrameModel = self.commentData[indexPath.row] as! CommentCellFrameModel
        return cellFrameModel.cellHeight!
    }
    
    
    @objc func addComment()  {
        commentHead?.addCommentTextView?.resignFirstResponder()
        if Int(USERID)! > 0 {
            if self.courseId != nil && self.pointId != nil {
                let addComment = MNetRequestSeting()
                addComment.hostUrl = Courseassessadd()
                addComment.paramet = ["courseAssess.courseId":self.courseId!,"courseAssess.kpointId":self.pointId!,"userId":USERID,"courseAssess.content":commentHead!.addCommentTextView!.text!]
                addComment.requestDataFromNetSet(seting: addComment, successBlock: { [weak self] (responseData) in
                    if responseData["success"].boolValue {
                        self?.commentCompleteDelegate?.addCommentComplete()
                        self?.commentHead?.addCommentTextView?.text = ""
                        MBProgressHUD.showSuccess(responseData["message"].string)
                    }
                }) { (merror) in
                    MBProgressHUD.showError("添加评论失败!")
                }
            }else{
                MBProgressHUD.showError("添加评论失败!") 
            }
            
            
        }else{
            MBProgressHUD.showMBPAlertView("您还没有登录!", withSecond: 1.5)
        }
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
