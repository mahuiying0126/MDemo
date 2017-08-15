//
//  HomeDetailViewController.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/22.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
class HomeDetailViewController: UIViewController,DetailTopBaseViewDelegate,topButtonClickDelegate,buyCourseOrPlayViewDelegate,CourseListDelegate,MPlayerViewDelegate {
    
    var detailCourse : String?
    var infoModel : DetailInfoModel?
    var courseModel : DetailCourseModel?
    
    /** *播放器视图 */
    var playerView : MPlayerView?
    
    //隐藏电池栏
    override var prefersStatusBarHidden: Bool{
        return true
    }
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Whit
        //隐藏导航栏
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        
        self.view.addSubview(self.topBaseView)
        loadDetailData()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //取消隐藏导航栏
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    //MARK:数据请求
    func loadDetailData()  {
        HomeDetailViewModel().loadingHomeCourseData(parameter: detailCourse!) { [weak self](someInfoModel, coursModel, coursPackageArray, listDeatilData) in
            self?.infoModel = someInfoModel
            self?.courseModel = coursModel
            self?.coursePackageArray = coursPackageArray
            self?.listDeatilArray = listDeatilData
            self?.courseModel?.courseID = self?.detailCourse!
            if(self?.infoModel?.isFav == false && Int(USERID) != 0){
                self?.topViewTool.collectionBtn?.isSelected = true
            }
            ///获取数据,刷新UI
            self?.settopBaseViewData()
            self?.setTeacherListData()
            self?.MCourseListData()
        }
        
        HomeDetailViewModel().loadCommentData(courseID: detailCourse!, currentPage: 1, isLoadMore: true) {[weak self] (commentData, totlePage) in
            self?.commentTableView.commentData(commentData)
        }
        
    }
    ///顶部视图,播放按钮,数据实现
    func settopBaseViewData() {
        ///顶部图片路径
        let url = String.init(format: "%@%@", imageUrlString,(self.courseModel?.mobileLogo)!)
        self.topBaseView.setImageUrl(imageUrl: url)
    }
    ///老师,课程介绍等数据
    func setTeacherListData(){
        self.teacherList.teacherListData((self.courseModel)!)
    }
    ///课程列表数据,和分区头,课程包数据
    
    func MCourseListData()  {
        let number  = NSInteger(Float(self.coursePackageArray.count) / 2.0 + 0.6)
        let height = number * 40 + 5*(number+1)
        let frame = CGRect.init(x: 0, y: 0, width: Int(Screen_width), height: height)
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        
        let coursePackView = MCoursePackageView.init(frame: frame, collectionViewLayout: flowLayout)
        let tempPackageArray = DetailCoursePackageModel.mj_objectArray(withKeyValuesArray: self.coursePackageArray)
        
        coursePackView.packageFromData(dataArray: tempPackageArray!)
        self.listTableView.tableHeaderView = coursePackView
        
        self.listTableView.CourseListData(self.listDeatilArray)
    }
    
    
    //MARK: Public 公共方法&代理
    ///返回,播放按钮代理事件
    func topBaseViewBackVsPlay(tage: Int){
        switch tage {
        case 1:
            self.navigationController?.popViewController(animated: true)
            break
        case 2:
            ///中间大播放按钮
            let courseModel  = self.listDeatilArray[0] as! DetailCourseListModel
            let tempArray = courseModel.childKpoints
            let model = tempArray?.first as! DetailCourseChildModel
            self.didSelectCourseList(index: IndexPath(), model: model)
            break
            
        default:
            break
        }
    }
    ///收藏代理
    func collectionAndDownClick(buttonTag:Int){
        
        MYLog(buttonTag)
        switch buttonTag {
        case 0:
            ///下载
            
            break
        case 2:
            ///分享
            
            break
        default:
            break
        }
        
    }
    ///segment代理
    func threeSegmentBtn(segmentIndex: Int){
        switch segmentIndex {
        case 0:
            self.detailScrollView.contentOffset = CGPoint.init(x: 0, y: 0)
            self.teacherList.reloadData()
            break
        case 1:
            self.detailScrollView.contentOffset = CGPoint.init(x: Screen_width, y: 0)
            break
        case 2:
            self.detailScrollView.contentOffset = CGPoint.init(x: 2 * Screen_width, y: 0)
            break
        default:
            break
        }
    }
    
    //MARK:购买按钮
    func purchaseNowOrPlay(){
        MYLog("购买按钮点击")
    }
    //MARK:课程列表,分区头点击事件
    
    func didClickListCellHeader(indexSection : Int , model : DetailCourseListModel){
        MYLog("点击了课程列表分区头\(indexSection)")
    }
    
    func didSelectCourseList(index : IndexPath , model : DetailCourseChildModel){
        var checkResultDict : JSON!
        if NSInteger(USERID)! > 0 {
            ///用户登录了
           checkResultDict = model.ID?.checkPointIsAbleToPlay()
        }else{
            ///提示去登录
            return
        }
    
        if checkResultDict["success"].boolValue {
            let entity = checkResultDict["entity"]
            let fileStyle = entity["fileType"]
            let videoStyle = entity["videoType"]
            if fileStyle.string == MediaVideoType {
                ///视频
                if videoStyle.string == PlayerMedia96KType {
                    ///96K视频
                    playVideoWithUrl(url: entity["videoUrl"].string!, type: MediaVideoType)
                }else if videoStyle.string == MediaUnknownType {
                    ///CC视频
                    MBProgressHUD.showMBPAlertView("视频格式不正确", withSecond: 1.0)
                }
                
                
            }else if fileStyle.string == MediaAudioType {
                ///音频
                playVideoWithUrl(url: entity["videoUrl"].string!, type: MediaAudioType)
            }
            

        }else{
            if (self.infoModel?.isok)! {
                ///已经买了,还是不能播
                MBProgressHUD.showMBPAlertView("视频暂时无法播放", withSecond: 1.5)
            }else{
                ///不能播,可能没有买
                MBProgressHUD.showMBPAlertView("还未购买课程,请先去购买!", withSecond: 1.5)
            }
        }

    }
    
    private func playVideoWithUrl(url:String,type:String) {
        
        if MNetworkUtils.isNoNet() {
            MBProgressHUD.showMBPAlertView("无可用网络", withSecond: 1.0)
            return
        }
        if MNetworkUtils.isEnableWWAN() {
            ///4G网络提示信息
            
        }else if MNetworkUtils.isEnableWIFI() {
            ///Wifi 直接播放
            playMeidoWithUrl(url: url, type: type)
            
        }
        
    }
    
    private func playMeidoWithUrl(url:String,type:String){
        ParsingEncrypteString().parseStringWith(urlString: url, fileType: type, isLocal: false) {[weak self] (videoUrl) in
            if self?.playerView != nil {
                self?.playerView?.removeFromSuperview()
                self?.playerView?.currentTime = 0
                self?.playerView?.exchangeWithURL(videoURLStr: videoUrl)
            }else{
                self?.playerView = MPlayerView.shared.initWithFrame(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: Screen_width * 9/16), videoUrl: videoUrl, type: type)
                self?.playerView?.mPlayerDelegate = self
            }
            self?.playerView?.videoParseCode = url
            self?.view.addSubview((self?.playerView)!)
        }
    }
    
    ///MARK:播放器代理事件
    func closePlayer() {
        ///还可以做一些操作,比如清除单元格状态
        self.playerView = nil
    }
    func setBackgroundTime(_ currTime: Float, _ totTime: Float) {
        //        print("~~~~~当前时间!!!!!!总时间",currTime,totTime);
    }
    
    
    
    //MARK: lazy 懒加载
    /// 返回按钮,播放按钮
    lazy var topBaseView : DetailTopBaseView = {
        let topView = DetailTopBaseView.init(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: Screen_width * 9/16.0))
        topView.topDelegate = self
        
        self.view.addSubview(self.topViewTool)
        self.detailScrollView.addSubview(self.teacherList)
        
        self.detailScrollView.addSubview(self.listTableView)
        self.detailScrollView.addSubview(self.commentTableView)
        return topView
    }()
    
    /// 离线下载,收藏,分享
    lazy var topViewTool : DetailTopToolView = {
        let tempTool = DetailTopToolView.init(frame: CGRect.init(x: 0, y: Screen_width * 9/16.0, width: Screen_width, height: 100))
        tempTool.topViewButtonDelegate = self
        tempTool.courseId = self.detailCourse
        return tempTool
    }()
    
    /// 滚动视图
    lazy var detailScrollView : UIScrollView = {
        
        let tempScroollView = UIScrollView.init(frame: CGRect.init(x: 0, y: self.topViewTool.frame.maxY, width: Screen_width, height: Screen_height - self.topViewTool.frame.maxY))
        
        tempScroollView.isScrollEnabled = false
        tempScroollView.showsVerticalScrollIndicator = false
        tempScroollView.showsHorizontalScrollIndicator = false
        tempScroollView.contentSize = CGSize.init(width: 3 * Screen_width, height: tempScroollView.frame.height)
        
        self.view.addSubview(tempScroollView)
        
        return tempScroollView
        
    }()
    
    /// 课程介绍
    lazy var teacherList : DetailTeacherView = {
        let tempTeacherList = DetailTeacherView.init(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: self.detailScrollView.frame.height), style: UITableViewStyle.plain)
        tempTeacherList.buyOrPlayDelegate = self
        return tempTeacherList
    }()
    
    /// 课程列表
    lazy var listTableView : DetailCourseListView = {
        
        let tempList = DetailCourseListView.init(frame: CGRect.init(x: Screen_width, y: 0, width: Screen_width, height: self.detailScrollView.frame.height), style: UITableViewStyle.plain)
        tempList.courseDelegate = self
        return tempList
        
    }()
    
    /// 讨论区
    lazy var commentTableView : DetailCommentView = {
        
        let comment = DetailCommentView.init(frame: CGRect.init(x: 2 * Screen_width, y: 0, width: Screen_width, height: self.detailScrollView.frame.height), style: UITableViewStyle.plain)
        return comment
        
    }()
    
    lazy var listDeatilArray : NSArray = {
        
        let tempArray = NSArray()
        return tempArray
    }()
    
    lazy var coursePackageArray : NSArray = {
        let tempArray = NSArray()
        
        return tempArray
    }()
    
    deinit {
        MYLog("详情页面销毁了")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}
