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
        self.delegate = self
        self.dataSource = self
        self.separatorStyle = .none
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (self.commentData?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellID = "CommentID"
        let cell = MCommentTableViewCell.init(style: .default, reuseIdentifier: cellID)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
