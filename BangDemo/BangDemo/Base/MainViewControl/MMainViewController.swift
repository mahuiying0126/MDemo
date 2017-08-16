//
//  MMainViewController.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/9.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import Foundation
class MMainViewController: UITabBarController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let tabBar = UITabBar.appearance()
        
        tabBar.barTintColor = ColorFromRGB(241.0, 241.0, 241.0, 1.0)
        tabBar.tintColor = ColorFromRGB(127.0, 127.0, 127.0, 1.0)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        addChildViewControl(viewController: MHomeViewController(), title: "首页", image: "推荐未选", selectImage: "推荐已选")
        addChildViewControl(viewController: MCourseViewController(), title: "课程", image: "课程未选", selectImage: "课程选中")
        addChildViewControl(viewController: MRecordViewController(), title: "记录", image: "记录未选", selectImage: "记录已选")
        addChildViewControl(viewController: MDownViewController(), title: "下载", image: "下载未选", selectImage: "下载已选")
        
    }
    
    
    
   private func addChildViewControl(viewController:UIViewController,title:NSString,image:String,selectImage:NSString) {
        
        viewController.tabBarItem.title = title as String
        viewController.tabBarItem.titlePositionAdjustment = UIOffsetMake(0, -5)
        viewController.tabBarItem.image = UIImage(named:image)
        
        viewController.tabBarItem.selectedImage = UIImage(named:selectImage as String)?.withRenderingMode(UIImageRenderingMode.alwaysOriginal)
        //设置文字样式
        var textAttrs = Dictionary<String, Any>()
        textAttrs[NSForegroundColorAttributeName] = UIColorFromRGB(0x919192);
        //被选择
        var selectTextAttrs = Dictionary<String,Any>()
        selectTextAttrs[NSForegroundColorAttributeName] = ColorFromRGB(63.0, 131.0, 230.0, 1.0);
        selectTextAttrs[NSFontAttributeName] = FONT(16.0)
        viewController.tabBarItem.setTitleTextAttributes(
            textAttrs, for: UIControlState.normal)
        viewController.tabBarItem.setTitleTextAttributes(selectTextAttrs, for: UIControlState.selected)
        
        let mainNavigation = MNavigationViewController(rootViewController: viewController)
        mainNavigation.navigationBar.isTranslucent = false
        addChildViewController(mainNavigation)
        
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
