//
//  MSelectDownViewController.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/21.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MSelectDownViewController: UIViewController,CourseListDelegate {

    /** *下载列表数据 */
    var  selectList : Array<Any>?
    /** *课程图片 */
    var  imageUrl : String?
    /** *替换数据 */
    var  tempArray : Array<Any>?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Whit
        self.title = "下载列表"
        createFoot()
//        self.tempArray = self.selectList
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.CourseListData(self.selectList!)
    }
    
    @objc func downButtonEvent(sender:UIButton){
        if sender.tag == 0 {
            
        }else{
            ///开始下载
         let downView = MDownViewController()
            self.navigationController?.pushViewController(downView, animated: true)
            
        }
    }
    
    ///点击代理
    func didSelectCourseList(index : IndexPath , model : DetailCourseChildModel){
        
        if !model.isSelected {
            let isDownloading = MFMDBTool.shareInstance.cheackFromDownloadingTableIsExist(model.ID!)
            if isDownloading {
                MBProgressHUD.showMBPAlertView("正在下载中", withSecond: 1.5)
                return
            }
            let isFinsh = MFMDBTool.shareInstance.cheackFromFinshTableIsExist(model.ID!)
            if isFinsh {
                MBProgressHUD.showMBPAlertView("下载已完成", withSecond: 1.5)
                return
            }
            let checkResultDict = model.ID?.checkPointIsAbleToPlay()
            if (checkResultDict != nil) {
                let entity = checkResultDict?["entity"]
                let fileStyle = entity?["fileType"]
                let videoStyle = entity?["videoType"]
                model.isSelected = !model.isSelected
                let downModel = DownloadingModel.conversionsModel(model)
                downModel.videoType = videoStyle?.rawString()//96K
                downModel.fileType = fileStyle?.rawString()//Video
                downModel.videoUrl = entity?["videoUrl"].string
                downModel.imageUrl = self.imageUrl
                MFMDBTool.shareInstance.addDownloadingModel(downModel)
                
            }else{
                MBProgressHUD.showMBPAlertView("该视频暂时无法下载", withSecond: 1.0)
            }
        }else{
            MFMDBTool.shareInstance.removeDownloadingModel(model.ID!)
        }
        self.tableView.reloadRows(at: [index], with: .none)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /// 课程列表
    lazy var tableView : DetailCourseListView = {
        
        let tempList = DetailCourseListView(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: Screen_height - 64 - 60), style: UITableViewStyle.plain)
        self.view.addSubview(tempList)
        tempList.isSelectView = true
        tempList.cellID = "select"
        tempList.courseDelegate = self
        return tempList
        
    }()
    
    private func createFoot(){
        let footView = UIView.init(frame: .init(x: 0, y: Screen_height - 64 - 60, width: Screen_width, height: 60))
        self.view.addSubview(footView)
        footView.backgroundColor = Whit
        
        let line = UIView.init(frame: .init(x: 0, y: 0, width: Screen_width, height: 1))
        line.backgroundColor = UIColorFromRGB(0xd2d2d2)
        footView.addSubview(line)
        let line1 = UIView.init(frame: .init(x: Screen_width / 2 - 0.5, y: 15, width: 0.5, height: 30))
        line1.backgroundColor = UIColorFromRGB(0xd2d2d2)
        footView.addSubview(line1)
        
        let iconArr = ["查看缓存","查看下载"]
        for (index,item) in iconArr.enumerated() {
            let downButton = UIButton().buttonTitle(title: item, image: item, selectImage: item, backGroundColor: Whit, Frame: CGRect.init(x: (Screen_width/2) * CGFloat(index) , y: 12 , width: Screen_width / 2 - 3  , height: 40))
            downButton.setTitleColor(UIColorFromRGB(0x333333), for: .normal)
            downButton.titleLabel?.font = FONT(15)
            downButton.layoutButtonWithEdgeInsetsStyle(style: .imageTop, imageTitleSpace: 3)
            downButton.tag = index
            downButton.addTarget(self, action: #selector(downButtonEvent(sender:)), for: .touchUpInside)
            footView.addSubview(downButton)
            
        }
        
    }
    
    deinit {
        MYLog("下载选择页面销毁")
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
