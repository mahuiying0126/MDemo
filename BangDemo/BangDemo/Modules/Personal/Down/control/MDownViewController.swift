//
//  MDownViewController.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/9.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MDownViewController: UIViewController {

    ///初始化一个下载单例,为了使控制器不走声明周期,做下载
    static let shareInstance = MDownViewController()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Whit
        self.title = "离线下载"
        self.downLoadTable.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.downLoadTable.updataTableForData(true)

    }
    
    @objc func segmetEvent(sender:UISegmentedControl){
        if sender.selectedSegmentIndex == 0 {
            ///下载中
            self.downLoadTable.isDownloading = true
        }else{
            ///已完成
            self.downLoadTable.isDownloading = false
        }
    }
    
    
    lazy var downLoadTable : MDownloadingTable = {
        let segTile = ["下载中","已完成"]
        let segmet = UISegmentedControl.init(items: segTile)
        segmet.frame = .init(x: 20, y: Spacing10, width: Screen_width - 40, height: 30)
        self.view.addSubview(segmet)
        segmet.selectedSegmentIndex = 0
        segmet.addTarget(self, action: #selector(segmetEvent(sender:)), for: .valueChanged)
        
        let tableView = MDownloadingTable.init(frame:CGRect.init(x: 0, y: segmet.frame.maxY + Spacing10, width: Screen_width, height: Screen_height - 64 - 30), style: .plain)
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
