//
//  HomeDetailViewController.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/22.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import SwiftyJSON
class HomeDetailViewController: UIViewController,DetailTopBaseViewDelegate,topButtonClickDelegate,buyCourseOrPlayViewDelegate,CourseListDelegate,MPlayerViewDelegate,addCommentCompleteDelegate {
    
    /** 课程 id**/
    var detailCourse : String?
    /** *课程标题 */
    var  courseTitle : String?
    private var infoModel : DetailInfoModel?
    private var courseModel : DetailCourseModel?
    /** *播放器视图 */
    private var playerView : MPlayerView?
    /** *点击当前 indexPath*/
    private var tempIndex : IndexPath?
    
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
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //取消隐藏导航栏
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        switch event!.subtype {
        case .remoteControlPlay:// play按钮
            MYLog("播放")
            self.playerView?.playPlayer()
            break

        case .remoteControlPause:// pause按钮
            MYLog("暂停")
            self.playerView?.pausePlayer()
            break

        case .remoteControlNextTrack:  // next
            
            let model = HomeDetailViewModel().handlCourseDataForNext(currentIndex: &self.tempIndex!, courseData: &self.listDeatilArray)
            
            self.listTableView.reloadTableViewFromRemoteControlEvents(self.listDeatilArray)
            self.didSelectCourseList(index: self.tempIndex!, model: model)
            
            break
        case .remoteControlPreviousTrack:  // previous
            let model = HomeDetailViewModel().handlCourseDataForPrevious(currentIndex: &self.tempIndex!, courseData: &self.listDeatilArray)
            
            self.listTableView.reloadTableViewFromRemoteControlEvents(self.listDeatilArray)
            self.didSelectCourseList(index: self.tempIndex!, model: model)
            break
        default:
            break
        }
    }
    
    //MARK: 数据请求
    ///课程数据请求
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
            ///将讨论内容加载放这,为了拿到 pointID
            self?.loadCommentData()
        }
    }
    ///评论课程数据
    func loadCommentData() {
        HomeDetailViewModel().loadCommentData(courseID: detailCourse!, currentPage: 1, isLoadMore: true) {[weak self] (commentData, totlePage) in
            self?.commentTableView.commentData(commentData, courseID: (self?.detailCourse)!, pointID: (self?.infoModel?.defaultKpointId)!)
        }
    }
    
    //MARK: 视图数据填充
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
        let tempPackageArray  = DetailCoursePackageModel.mj_objectArray(withKeyValuesArray: self.coursePackageArray) as! Array<Any>
        
        coursePackView.packageFromData(tempPackageArray)
        self.listTableView.tableHeaderView = coursePackView
        self.listTableView.CourseListData(self.listDeatilArray)
    }
    
    //MARK:返回,播放按钮代理事件
    func topBaseViewBackVsPlay(tage: Int){
        switch tage {
        case 1:
            self.navigationController?.popViewController(animated: true)
            break
        case 2:
            ///中间大播放按钮
            let courseModel  = self.listDeatilArray.first as! DetailCourseListModel
            let tempArray = courseModel.childKpoints
            let model = tempArray?.first as! DetailCourseChildModel
            self.didSelectCourseList(index: IndexPath.init(row: 0, section: 0), model: model)
            break
            
        default:
            break
        }
    }
    ///MARK:收藏代理
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
    ///MARK:segment代理
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
    //MARK:添加评论完成代理回掉
    func addCommentComplete(){
        loadCommentData()
    }
    //MARK:课程列表,分区头点击事件
    func didClickListCellHeader(indexSection : Int , model : DetailCourseListModel){
        MYLog("点击了课程列表分区头\(indexSection)")
    }
    ///MARK:课程列表,单元格点击事件
    func didSelectCourseList(index : IndexPath , model : DetailCourseChildModel){
        self.tempIndex = index
        model.courseTitle = self.courseTitle
        
        if MNetworkUtils.isNoNet() {
            MBProgressHUD.showError("已于网络断开连接")
            return
        }
        
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
                    playVideoWithUrl(url: entity["videoUrl"].string!, type: MediaVideoType,model: model)
                }else if videoStyle.string == MediaUnknownType {
                    ///CC视频
                    MBProgressHUD.showMBPAlertView("视频格式不正确", withSecond: 1.0)
                }
                
                
            }else if fileStyle.string == MediaAudioType {
                ///音频
                playVideoWithUrl(url: entity["videoUrl"].string!, type: MediaAudioType,model: model)
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
    
    private func playVideoWithUrl(url:String,type:String,model:DetailCourseChildModel) {
        
        if MNetworkUtils.isNoNet() {
            MBProgressHUD.showMBPAlertView("无可用网络", withSecond: 1.0)
            return
        }
        if MNetworkUtils.isEnableWWAN() {
            ///4G网络提示信息
            
        }else if MNetworkUtils.isEnableWIFI() {
            ///Wifi 直接播放
            playMeidoWithUrl(url: url, type: type,model: model)
            
        }
        
    }
    
    private func playMeidoWithUrl(url:String,type:String,model:DetailCourseChildModel){
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
            self?.playerView?.model = model
            self?.view.addSubview((self?.playerView)!)
        }
    }
    
    ///MARK:播放器代理事件
    func closePlayer() {
        ///还可以做一些操作,比如清除单元格状态
        self.playerView = nil
        ///将远程事件取消
        UIApplication.shared.endReceivingRemoteControlEvents()
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
            comment.commentCompleteDelegate = self
        return comment
        
    }()
    
    lazy var listDeatilArray : Array<Any> = {
        
        let tempArray = Array<Any>()
        return tempArray
    }()
    
    lazy var coursePackageArray : Array<Any> = {
        let tempArray = Array<Any>()
        
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
