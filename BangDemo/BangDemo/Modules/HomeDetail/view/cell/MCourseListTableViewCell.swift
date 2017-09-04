//
//  MCourseListTableViewCell.swift
//  BangDemo
//
//  Created by yizhilu on 2017/6/26.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MCourseListTableViewCell: UITableViewCell {

    var courseImage : UIImageView?
    
    var courseName : UILabel?
    
    /** *下载状态 */
    var  downState : UILabel?
    
    var markLabel : UILabel?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        MsetUpdataCellData()
    }
    
    func MsetUpdataCellData() {
        courseImage = UIImageView()
        self.contentView.addSubview(courseImage!)
        courseName = UILabel()
        self.contentView.addSubview(courseName!)
        courseName?.textColor = UIColorFromRGB(0x555555)
        courseName?.font = FONT(15)
        downState = UILabel()
        self.contentView.addSubview(downState!)
        downState?.textColor = UIColorFromRGB(0x666666)
        downState?.font = FONT(12)
        downState?.text = ""
        markLabel = UILabel()
        self.contentView.addSubview(markLabel!)
        markLabel?.textColor = UIColorFromRGB(0x41DF77)
        markLabel?.font = FONT(12)
        
        courseImage?.snp.makeConstraints({ (make) in
            make.left.top.equalTo(self).offset(10)
            make.width.height.equalTo(20)
            
        })
        
        
        markLabel?.snp.makeConstraints({ (make) in
            make.right.equalTo(self).offset(-8)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(18)
        })
        
        downState?.snp.makeConstraints({ (make) in
            make.top.equalTo(self).offset(10)
            make.right.equalTo(markLabel!.snp.left).offset(-8)
            make.height.equalTo(18)
        })

        courseName?.snp.makeConstraints({ (make) in
            make.left.equalTo(courseImage!.snp.right).offset(10)
//            make.right.equalTo(downState!.snp.left).offset(-10)
            make.top.equalTo(self).offset(10)
            make.height.equalTo(18)
        })
    
    }
    
    func updataCellModel(_ model:DetailCourseChildModel) {
        self.courseName?.text = model.Name
        self.courseName?.textColor = model.isSelected ? navColor : .darkGray
        if model.isfree == 1 {
            self.markLabel?.layer.borderColor = UIColor.green.cgColor
            self.markLabel?.layer.borderWidth = 1
            self.markLabel?.text = "试听"
        }else{
            self.markLabel?.text = ""
        }
        self.courseImage?.image = MIMAGE(model.isSelected ? "qbg-section-s" : "qbg-section-n")
        
        let isDownloading = MFMDBTool.shareInstance.cheackFromDownloadingTableIsExist(model.ID!)
        if isDownloading {
            self.downState?.text = "下载中"
            
        }
        let isFinsh = MFMDBTool.shareInstance.cheackFromFinshTableIsExist(model.ID!)
        if isFinsh {
            self.downState?.text = "已完成"
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
