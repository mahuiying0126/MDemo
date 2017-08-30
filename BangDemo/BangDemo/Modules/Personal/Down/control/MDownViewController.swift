//
//  MDownViewController.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/9.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MDownViewController: UIViewController,playViedoDelegate,MPlayerViewDelegate {

    ///初始化一个下载单例,为了使控制器不走声明周期,做下载
    static let shareInstance = MDownViewController()
    
    /** *播放器视图 */
    private var playerView : MPlayerView?
    private var segmetControl : UISegmentedControl?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Whit
        self.title = "离线下载"
        self.downLoadTable.reloadData()
        let segTile = ["下载中","已完成"]
        segmetControl = UISegmentedControl.init(items: segTile)
        segmetControl?.frame = .init(x: 20, y: Spacing10, width: Screen_width - 40, height: 30)
        self.view.addSubview(segmetControl!)
        segmetControl?.selectedSegmentIndex = 0
        segmetControl?.addTarget(self, action: #selector(segmetEvent(sender:)), for: .valueChanged)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if MFMDBTool.shareInstance.listDataFromDownloaingTable().count > 0 {
            self.downLoadTable.updataTableForData(true)
            segmetControl?.selectedSegmentIndex = 0
        }else{
            if MFMDBTool.shareInstance.listDataFromFinshTable().count > 0 {
                self.downLoadTable.updataTableForData(false)
                segmetControl?.selectedSegmentIndex = 1
            }else{
                self.downLoadTable.updataTableForData(true)
                segmetControl?.selectedSegmentIndex = 0
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //消失关闭播放器
        self.playerView?.closPlaer()
        self.playerView = nil
    }
    
    func playVideoWithVideoModel(model : DownloadingModel){
        let url = LibraryFor96k + "/\(model.videoUrl!)"
        ParsingEncrypteString.parseStringWith(urlString: url, fileType: model.fileType!, isLocal: true) {[weak self] (videoUrl) in
            if self?.playerView != nil {
                self?.playerView?.removeFromSuperview()
                self?.playerView?.currentTime = 0
                self?.playerView?.exchangeWithURL(videoURLStr: videoUrl)
            }else{
                self?.navigationController?.setNavigationBarHidden(true, animated: false)
                self?.playerView = MPlayerView.shared.initWithFrame(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: Screen_width * 9/16), videoUrl: videoUrl, type: model.fileType!)
                self?.downLoadTable.frame = CGRect.init(x: 0, y: Screen_width * 9/16, width: Screen_width, height: Screen_height - Screen_width * 9/16)
                self?.playerView?.mPlayerDelegate = self
            }
            
            self?.playerView?.videoParseCode = url
            self?.view.addSubview((self?.playerView)!)
        }
        
    }

    
    func closePlayer(){
        self.playerView = nil
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.downLoadTable.frame = CGRect.init(x: 0, y: 50, width: Screen_width, height: Screen_height - 64 - 50)
    }
    
    @objc func segmetEvent(sender:UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            ///下载中
            self.downLoadTable.updataTableForData(true)
        }else{
            ///已完成
            self.downLoadTable.updataTableForData(false)
        }
    }
    
    
    lazy var downLoadTable : MDownloadingTable = {
    
        let tableView = MDownloadingTable.init(frame:CGRect.init(x: 0, y: 50 , width: Screen_width, height: Screen_height - 64 - 50), style: .plain)
        tableView.playLocalVidelDelgate = self
        tableView.viewControlM = self
        self.view.addSubview(tableView)
        
        return tableView
    }()

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    deinit {
        MYLog("下载页面消失了")
    }

}
