//
//  DetailCommentView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/25.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class DetailCommentView: UITableView ,UITableViewDelegate,UITableViewDataSource{

    /** *课程评论数据 */
    var commentData : NSArray?
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.tableHeaderView = MCommentHeadView.init(frame:.init(x: 0, y: 0, width: Screen_width, height: 130))
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    func commentData(_ data : NSArray)  {
        
        let tempData = NSMutableArray()
        
        for model in data {
            let cellFrame = CommentCellFrameModel().cellFrameModel(model as! CommentUserModel)
            tempData.add(cellFrame)
        }
        self.commentData = tempData.copy() as? NSArray
        self.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.commentData == nil ? 0 : (self.commentData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CommentID"
        let cell = MCommentTableViewCell.init(style: .default, reuseIdentifier: cellID)
        
        let cellFrame = self.commentData?[indexPath.row] as!CommentCellFrameModel
        cell.updatCellFrame(model: cellFrame)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let cellFrameModel = self.commentData?[indexPath.row] as! CommentCellFrameModel
        return cellFrameModel.cellHeight!
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
