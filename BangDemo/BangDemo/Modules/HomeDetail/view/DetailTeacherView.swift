//
//  DetailTeacherView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/25.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

protocol buyCourseOrPlayViewDelegate : class {
    func purchaseNowOrPlay()
}

class DetailTeacherView: UITableView,UITableViewDelegate,UITableViewDataSource,UIWebViewDelegate {
    
    var detailTeacherArray : Array<Any> = []
    
    private let cellId = "teacher"

    weak var buyOrPlayDelegate : buyCourseOrPlayViewDelegate?
    
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.tableFooterView = UIView.init(frame: CGRect.zero)
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
        self.tableHeaderView = self.headView
        self.register(TeacherTableViewCell.self, forCellReuseIdentifier: cellId)
        self.headView.detailWebView?.delegate = self
        self.headView.downUpBtn?.addTarget(self, action: #selector(downBtnClick(sender:)), for: .touchUpInside)
        self.headView.purchaseBtn?.addTarget(self, action: #selector(purchaseNowBtnClick(sender:)), for: .touchUpInside)
    }
    
    //MARK: 接收老师页面,课程介绍数据
    func teacherListData(_ teacherModel:DetailCourseModel)  {
        self.detailTeacherArray = teacherModel.teacherList!
        self.headView.setTeacherHeadModel(teacherModel)
        self.reloadData()
    }
    
    //MARK: 购买按钮代理回调
    
    @objc func purchaseNowBtnClick(sender:UIButton){
        if (self.buyOrPlayDelegate != nil) {
            self.buyOrPlayDelegate?.purchaseNowOrPlay()
        }
    }
    
    //MARK: tableview代理
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailTeacherArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell  = tableView.dequeueReusableCell(withIdentifier: cellId) as!TeacherTableViewCell
        
        
        let tempDic : NSDictionary = self.detailTeacherArray[indexPath.row] as! NSDictionary
        let model  = DetailTeacherListModel.mj_object(withKeyValues: tempDic)!
        
        cell.setUpCellDataM(model)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let baseView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: 40))
        baseView.backgroundColor = Whit
        let topLine = UIView.init(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: 10))
        baseView.addSubview(topLine)
        topLine.backgroundColor = lineColor
        let bottmLine = UIView.init(frame: CGRect.init(x: 0, y: 39, width: Screen_width, height: 1))
        baseView.addSubview(bottmLine)
        bottmLine.backgroundColor = lineColor
        let teacherLabel = UILabel.init(frame: CGRect.init(x: 12, y: 15, width: 100, height: 20))
        teacherLabel.backgroundColor = Whit
        teacherLabel.text = "讲师"
        baseView .addSubview(teacherLabel)
        return baseView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 12 * 2 + 45*Ratio_height
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    //MARK: webView代理事件
    func webView(_ webView: UIWebView, didFailLoadWithError: Error){
        var frame = webView.frame
        frame.size.height = webView.scrollView.contentSize.height + 110
        webView.frame = frame
        changeWebViewLayout(height: frame.size.height)
    }
    func webViewDidFinishLoad(_ webView: UIWebView){
        var frame = webView.frame
        frame.size.height = webView.scrollView.contentSize.height + 110
        webView.frame = frame
        changeWebViewLayout(height: frame.size.height)
    }
    
    func changeWebViewLayout(height : CGFloat)  {
        var frame = self.headView.frame
        frame.size.height = height
        self.headView.frame = frame
        self.tableHeaderView = self.headView
    }
    //MARK: 收缩,展开事件
    @objc func downBtnClick(sender:UIButton) {
        var web_h = CGFloat()
        let temp_H :CGFloat = 110
        if sender.isSelected {
            ///展开
            let tmpH = self.headView.detailWebView?.scrollView.contentSize.height
            web_h = tmpH! + temp_H
            changeWebViewLayout(height: web_h)
        }else{
            changeWebViewLayout(height: temp_H)
        }
        sender.isSelected = !sender.isSelected
    }

    
    /// 课程标题,价格,立即购买按钮
    lazy var headView : TeacherHeaderView = {
        let tempHead = TeacherHeaderView.init(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: 110))
        
        return tempHead
    }()
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
