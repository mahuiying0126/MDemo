//
//  MCommentTableViewCell.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/4.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MCommentTableViewCell: UITableViewCell {

    /** *头像 */
    var headImage : UIImageView?
    /** *昵称 */
    var  nickLable : UILabel?
    /** *时间 */
    var  timeLabel : UILabel?
    /** *评论内容 */
    var  contentLabel : UILabel?
    /** *分割线 */
    var  lineView : UIView?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        headImage = UIImageView()
        self.contentView.addSubview(headImage!)
        nickLable = UILabel()
        nickLable?.font = FONT(15)
        nickLable?.textColor = navColor
        self.contentView.addSubview(nickLable!)
        timeLabel = UILabel()
        timeLabel?.textAlignment = .right
        timeLabel?.font = FONT(13)
        timeLabel?.textColor = .gray
        self.contentView.addSubview(timeLabel!)
        contentLabel = UILabel()
        contentLabel?.font = FONT(17)
        contentLabel?.textColor = .gray
        contentLabel?.numberOfLines = 0
        self.contentView.addSubview(contentLabel!)
        lineView = UIView()
        lineView?.backgroundColor = lineColor
        self.contentView.addSubview(lineView!)
        
    }
    
    func updatCellFrame(model:CommentCellFrameModel)  {
        let cellModel = model.model

        let tempStr = imageUrlString + (cellModel?.avatar)!
        let url = NSURL.init(string: tempStr)
        self.headImage?.af_setImage(withURL: url! as URL,placeholderImage:UIImage.init(named: "头像"))
        self.headImage?.frame = model.imageFrame!
        
        if (cellModel?.nickname?.deletSpaceInString().characters.count)! > 0 {
            self.nickLable?.text = cellModel?.nickname!
        }else if(cellModel?.mobile?.deletSpaceInString().characters.count)! > 0{
            self.nickLable?.text = cellModel?.mobile!
        }else if(cellModel?.email?.deletSpaceInString().characters.count)! > 0{
            self.nickLable?.text = cellModel?.email!
        }
        self.nickLable?.frame = model.nameFrame!
        
//        let mytime = cellModel?.createTime as! NSMutableString
//        
//        if mytime.length > 3 {
//            mytime.deleteCharacters(in: NSRange.init(location: mytime.length - 3, length: 3))
//        }
        self.timeLabel?.text = cellModel?.createTime!
        
        self.timeLabel?.frame = model.timeFrame!
       
        let attribstr = try! NSAttributedString.init(data:(cellModel?.content?.data(using: String.Encoding.unicode))! , options: [NSDocumentTypeDocumentAttribute:NSHTMLTextDocumentType], documentAttributes: nil)
        
        self.contentLabel?.attributedText = attribstr
        self.contentLabel?.frame = model.contentFrame!
        self.lineView?.frame = model.lineFrame!
   
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
