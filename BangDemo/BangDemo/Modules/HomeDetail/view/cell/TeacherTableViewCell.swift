//
//  TeacherTableViewCell.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/2.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class TeacherTableViewCell: UITableViewCell {

    var detailImage : UIImageView?
    var detailName : UILabel?
    var cellModel : DetailTeacherListModel?
    

    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupTeacherCellM()
    }
    
     func setUpCellDataM(_ model:DetailTeacherListModel) {
        self.cellModel = model
        let imageUrl : String = imageUrlString + (model.picPath)!
        let url  = NSURL.init(string: imageUrl)
        self.detailImage?.af_setImage(withURL: url! as URL, placeholderImage:UIImage.init(named: "加载中"))
        do{
            var name = String()
            if Int(model.isStar!)!  == 0 {
                name = " 高级讲师  " + (model.name)!
            }else if Int(model.isStar!)!  == 1 {
                name = " 首席讲师  " + (model.name)!
            }
            let attribut = NSMutableAttributedString.init(string: name)
            attribut.addAttribute(NSAttributedStringKey.foregroundColor, value: navColor, range: NSRange.init(location: 0, length: 5))
            attribut.addAttribute(NSAttributedStringKey.font, value: FONT(15), range: NSRange.init(location: 0, length: (model.name?.characters.count)!))
            self.detailName?.attributedText = attribut
        }
        
        
        
    }
    
    func setupTeacherCellM()  {
        do{
            detailImage = UIImageView()
            self.contentView.addSubview(detailImage!)
            detailName = UILabel()
            detailName?.font = FONT(15)
            self.contentView.addSubview(detailName!)
            
        }
        do{
            let line = UIView()
            line.backgroundColor = lineColor
            self.contentView.addSubview(line)
            
            detailImage?.snp.makeConstraints({ (make) in
                make.left.top.equalTo(self).offset(12)
                make.width.equalTo(60 * Ratio_height)
                make.height.equalTo(45 * Ratio_height)
            })
            detailName?.snp.makeConstraints({ (make) in
                make.left.equalTo(detailImage!.snp.right).offset(5)
                make.top.equalTo(detailImage!.snp.top).offset(10)
                make.height.equalTo(21)
                make.width.equalTo(self.contentView).multipliedBy(0.5)
            })
            line.snp.makeConstraints { (make) in
                make.left.right.bottom.equalTo(self.contentView)
                make.height.equalTo(0.5)
            }
 
        }
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
