//
//  DetailTopToolView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/23.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit


@objc protocol topButtonClickDelegate {
    func collectionAndDownClick(buttonTag:Int)
    func threeSegmentBtn(segmentIndex: Int)
}


class DetailTopToolView: UIView {

    var collectionBtn : UIButton?
    /** *课程 id */
    var courseId : String?
    weak var topViewButtonDelegate : topButtonClickDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = lineColor
        setBaseViewLayout()
    }
    
    
    
    func setBaseViewLayout()  {
        let btnNormalIcons :Array = ["离线下载","收藏","分享"]
        let btnSelectedIcons :Array = ["离线下载","已收藏","分享"]
        
        for i in 0 ..< btnNormalIcons.count{
            
            let btn = UIButton().buttonTitle(title: btnNormalIcons[i], image: btnNormalIcons[i], selectImage: btnSelectedIcons[i], backGroundColor: Whit, Frame: CGRect.init(x: Screen_width / 3 * CGFloat(i) , y: 0, width: Screen_width/3 - CGFloat(1)  , height: 40))
            btn.tag = i
            btn.setTitleColor(.gray, for: .normal)
            btn.setTitleColor(navColor, for: .selected)
            btn.titleLabel?.font = FONT(15)
            btn.titleEdgeInsets = .init(top: 0, left: 5, bottom: 0, right: 0)
            btn.addTarget(self, action: #selector(detailThreeBtnClick(sender:)), for: .touchUpInside)
            self.addSubview(btn)
            if i == 1 {

                collectionBtn = btn
                
            }
        }
       let segmentBackView = UIView.init(frame: CGRect.init(x: 0, y: 50, width: Screen_width, height: 40))
        segmentBackView.backgroundColor = Whit
        self.addSubview(segmentBackView)
        
        let threeSegmentBtn = UISegmentedControl.init(frame: CGRect.init(x: 20 * Ratio_width, y: 5, width: Screen_width - 40*Ratio_width, height: 30))
        segmentBackView .addSubview(threeSegmentBtn)
        threeSegmentBtn .insertSegment(withTitle: "课程介绍", at: 0, animated: true)
        threeSegmentBtn.insertSegment(withTitle: "课程章节", at: 1, animated: true)
        threeSegmentBtn.insertSegment(withTitle: "讨论区", at: 2, animated: true)
        threeSegmentBtn.selectedSegmentIndex = 0
        threeSegmentBtn.tintColor = navColor
        threeSegmentBtn .addTarget(self, action: #selector(threeSegmentBtnClick(sender:)), for: .valueChanged)
        
    }
    
    
    func detailThreeBtnClick(sender: UIButton)  {
        if sender.tag == 1 {
            if sender.isSelected {
                ///已经是已收藏状态,再点击就是取消收藏
                ///在这里直接取反,为了避免图标闪动
                sender.isSelected = false
                collectionCleanCourse()
            }else{
                sender.isSelected = true
                collectionCourse()
            }
        }else{
          self.topViewButtonDelegate?.collectionAndDownClick(buttonTag: sender.tag)
        }
        
        
    }
    
    func threeSegmentBtnClick(sender:UISegmentedControl) {
       
        self.topViewButtonDelegate?.threeSegmentBtn(segmentIndex: sender.selectedSegmentIndex)
    }
    
    private func collectionCleanCourse() {
        
        let collection = MNetRequestSeting()
        collection.hostUrl = collectionCleanFavorites()
        collection.paramet = ["userId":USERID,"courseId":self.courseId!]
        collection.requestDataFromNetSet(seting: collection, successBlock: { [weak self](responseData) in
            if responseData["success"].boolValue {
                self?.collectionBtn?.isSelected = false
                MBProgressHUD.showSuccess("取消收藏")
                ///再将本地缓存重新刷新
                self?.refreshCourseData()
            }else{
                self?.collectionBtn?.isSelected = true
                MBProgressHUD.showError("取消失败!")
            }
        }) { [weak self](merror) in
            self?.collectionBtn?.isSelected = true
            MBProgressHUD.showError("取消失败!")
        }
    }
    private func collectionCourse() {
        if NSInteger(USERID)! > 0 {
            let collection = MNetRequestSeting()
            collection.hostUrl = collectionAdd()
            collection.paramet = ["userId":USERID,"courseId":self.courseId!]
            collection.requestDataFromNetSet(seting: collection, successBlock: { [weak self](responseData) in
                if responseData["success"].boolValue {
                    self?.collectionBtn?.isSelected = true
                    MBProgressHUD.showSuccess("收藏成功!")
                     ///再将本地缓存重新刷新
                    self?.refreshCourseData()
                }else{
                    self?.collectionBtn?.isSelected = false
                    MBProgressHUD.showError("收藏失败!")
                }
            }) { [weak self](merror) in
                self?.collectionBtn?.isSelected = false
                MBProgressHUD.showError("收藏失败!")
            }
            
        }else{
            MBProgressHUD.showMBPAlertView("请登录后收藏", withSecond: 1.0)
        }
        
    }
    
    /// 重新刷新课程列表及老师数据
    private func refreshCourseData() {
        let homeCourse = MNetRequestSeting()
        homeCourse.hostUrl = courseinfo()
        homeCourse.isHidenHUD = true
        homeCourse.paramet  = ["courseId":self.courseId!,"userId":USERID ,"uuId":KEY_UUID]
        homeCourse.cashSeting = .MSave
        homeCourse.isRefresh = true;
        homeCourse.requestDataFromNetSet(seting: homeCourse, successBlock: { (reson) in
            
        }, failture: { (merror) in
            
        })
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
}
