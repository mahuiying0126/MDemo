//
//  DetailCourseListView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/25.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

protocol CourseListDelegate : class {
    
    /// 课程cell点击事件
    ///
    /// - Parameters:
    ///   - indexPath: 当前cell IndexPath
    ///   - model: 点击当前cell的model
    func didSelectCourseList(index : IndexPath , model : DetailCourseChildModel)
    
    /// 课程分区头点击事件
    ///
    /// - Parameters:
    ///   - indexSection: 点击当前分区
    ///   - model: 当前分区的model
    func didClickListCellHeader(indexSection : Int , model : DetailCourseListModel)
}


class DetailCourseListView: UITableView ,UITableViewDelegate,UITableViewDataSource{
    
    var courseDataArray : NSArray?
    weak var courseDelegate : CourseListDelegate?
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
        self.backgroundColor = Whit
        self.separatorStyle = .none
        
        self.showsVerticalScrollIndicator = false
        self.showsHorizontalScrollIndicator = false
    }
    
    func CourseListData(_ dataArray:NSArray)  {
        self.courseDataArray = dataArray
        //将第一个分区展开
        if self.courseDataArray != nil {
            let model  = self.courseDataArray!.firstObject as! DetailCourseListModel
            model.isSelected = true
        }
        
        self.reloadData()
    }
    
    ///分区数
    func numberOfSections(in tableView: UITableView) -> Int {
    
        if self.courseDataArray != nil {
            return self.courseDataArray!.count
        }else{
            return 0
        }
    }
    
    ///行数
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let model  = self.courseDataArray![section] as! DetailCourseListModel
        let tempArray = model.childKpoints
        if model.isSelected {
            return (tempArray?.count)!
        }else{
            return 0
        }
    }
    ///cell内容
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)-> UITableViewCell {
        let cellID = "course"
        
        let cell : MCourseListTableViewCell = MCourseListTableViewCell.init(style: .default, reuseIdentifier: cellID)
        let courseModel  = self.courseDataArray![indexPath.section] as! DetailCourseListModel
        let tempArray = courseModel.childKpoints
        let model = tempArray?[indexPath.row] as! DetailCourseChildModel
        cell.updataCellModel(model)
        return cell
        
    }
    ///分区头视图
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width:Screen_width, height: 40 * Ratio_height))
        view.backgroundColor = Whit
        
        let tmpModel :DetailCourseListModel = self.courseDataArray![section] as! DetailCourseListModel
        let lineView = UIImageView()
        lineView.image = MIMAGE("课程分割线")
        view.addSubview(lineView)
        let courseLabel = UILabel()
        courseLabel.font = FONT(15)
        
        view.addSubview(courseLabel)
        let courseCount = UILabel()
        courseCount.font = FONT(15)
        view.addSubview(courseCount)
        
        courseLabel.text = tmpModel.name!
        courseCount.text = String.init(format: "共%ld节", (tmpModel.childKpoints?.count)!)
        courseLabel.textColor = tmpModel.isSelected ? navColor : UIColor.darkGray
        courseCount.textColor = tmpModel.isSelected ? navColor : UIColor.darkGray
        
        let  button = UIButton.init(frame: view.frame)
        view.addSubview(button)
        button.tag = section + 1941
        button.addTarget(section, action: #selector(tapListHeadView(btn:)), for: .touchUpInside)
    
        lineView.snp.makeConstraints { (make) in
            make.top.equalTo(view).offset(10)
            make.height.equalTo(15)
            make.width.equalTo(2)
            make.left.equalTo(view).offset(10)
        }
        
        courseLabel.snp.makeConstraints { (make) in
            make.left.equalTo(lineView.snp.right).offset(10)
            make.top.equalTo(view).offset(8)
            make.height.equalTo(18)
        }
        
        courseCount.snp.makeConstraints { (make) in
            make.right.equalTo(view.snp.right).offset(-10)
            make.top.equalTo(view).offset(8)
            make.height.equalTo(18)
        }
        
        
        
        
        return view
        
    }
    ///cell点击事件
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let courseModel  = self.courseDataArray![indexPath.section] as! DetailCourseListModel
        let tempArray = courseModel.childKpoints
        let model = tempArray?[indexPath.row] as! DetailCourseChildModel
        if !model.isSelected {
            model.isSelected = !model.isSelected
           self.courseDelegate?.didSelectCourseList(index: indexPath, model: model)
        }
        for (index,item) in (self.courseDataArray?.enumerated())! {
            if index == indexPath.section {
                //当前分区
                let listModel = item as! DetailCourseListModel
                for (currentIndex,currentItem) in (listModel.childKpoints?.enumerated())! {
                    if indexPath.row != currentIndex {
                        let model = currentItem as! DetailCourseChildModel
                        model.isSelected = false
                    }
                }
            }else{
               //其他分区
                let listModel = item as! DetailCourseListModel
                for currentItem in listModel.childKpoints! {
                    let model = currentItem as! DetailCourseChildModel
                    model.isSelected = false
                    
                }
            }
        }
        
        self.reloadData()
        
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40 * Ratio_height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40 * Ratio_height
    }
    
    func tapListHeadView(btn:UIButton)  {
        let section = btn.tag - 1941
        let tmpModel :DetailCourseListModel = self.courseDataArray![section] as! DetailCourseListModel
        tmpModel.isSelected = !tmpModel.isSelected
        self.reloadData()
        
        self.courseDelegate?.didClickListCellHeader(indexSection: section, model: tmpModel)
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
