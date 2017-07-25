//
//  MHomeViewController.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/9.
//  Copyright © 2017年 Magic. All rights reserved.
//
import UIKit
import SwiftyJSON

class MHomeViewController: UIViewController ,noticDelegate{
    static let reuseIdentifier = "homeCollectionCell"
    static let reusableView = "ReusableView"
    var homeDelegate = MHomeViewModel()
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.view.backgroundColor = Whit;
        self.title = "首页"
        self.homeCollectionView.reloadData()
        HomeBannerModel().loadingBannerData { [weak self] (array) in
            self?.adviertArray = array
            self?.homeHeadView.BannerIcons(array)
        }
        HomeNoticeModel().loadNoticeData { [weak self](array) in
            self?.homeHeadView.setupNoticeArray(array)
        }
        HomeCourseModel().loadRecommandCourseData { [weak self](array) in
            self?.homeDelegate.dataArray = array
            self?.homeCollectionView .reloadData()
        }
    }
    //MARK: Public 公共方法
    /// 点击跳转到公告详情页面
    /// - Parameter model: 点击公告model
    func clickNoticIndex(model:HomeNoticeModel){
        let messageView = MessageDetailViewController()
        messageView.messageId = model.ID
        messageView.msgDetail = model.descrip
        messageView.msgImageUrl = model.picture 
        messageView.messageTitle = "公告详情"
        self.navigationController?.pushViewController(messageView, animated: true)
    }

    //MARK: lazy 懒加载
    lazy var homeCollectionView: UICollectionView = {
        var layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        
        let collectionView = UICollectionView(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: Screen_height  - 66), collectionViewLayout: layout);
        
        collectionView.delegate = self.homeDelegate
        collectionView.dataSource = self.homeDelegate
        self.homeDelegate.cellDidSelectEvent = { [weak self] (cellModel) in
            ///cell点击事件
            let homeDetail = HomeDetailViewController()
            homeDetail.detailCourse = cellModel.courseId
            self?.navigationController?.pushViewController(homeDetail, animated:true)
        }
        collectionView.backgroundColor = Whit
        collectionView.contentInset = UIEdgeInsets.init(top:Screen_width*0.5 + 25 + 10, left: 0, bottom: 0, right: 0)
        collectionView.register(HomeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        collectionView.register(HomeHeadCollectionReusableView.self, forSupplementaryViewOfKind:UICollectionElementKindSectionHeader, withReuseIdentifier: reusableView)
        
        self.view .addSubview(collectionView)
        collectionView .addSubview(self.homeHeadView)
        return collectionView
    }()
    
    lazy var homeHeadView : HomeHeadView = {
        
        let headView = HomeHeadView.init(frame: CGRect.init(x: 0, y: -(Screen_width*0.5 + 25 + 10), width: Screen_width, height: Screen_width*0.5 + 25 + 10))
        headView.noticdelegate = self
        headView.silenceCarouselView?.silenceCarouselViewTapBlock = {
            [weak self](carouselView, index) in
            //轮播图点击事件,进入详情
            let homeDetail = HomeDetailViewController()
            let model = self?.adviertArray[index] as! HomeBannerModel
            homeDetail.detailCourse = model.courseId
            self?.navigationController?.pushViewController(homeDetail, animated:true)
        }
        return headView;
        
    }()

    lazy var adviertArray : NSMutableArray = {
        var temparray = NSMutableArray()
        return temparray
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
