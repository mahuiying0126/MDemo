//
//  MNavigationViewController.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/9.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit
import Foundation
class MNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let navigationBar = UINavigationBar .appearance()
        navigationBar.barTintColor = navColor
        navigationBar.tintColor = .white
        navigationBar.titleTextAttributes =  [
            NSForegroundColorAttributeName: Whit,
            ]
        navigationBar.backgroundColor = navColor
        
        let item = UIBarButtonItem.appearance()
        let attrs = NSMutableDictionary()
        attrs[NSForegroundColorAttributeName] = Whit
        attrs[NSFontAttributeName] = FONT(15.0)
        
        item.setTitleTextAttributes(attrs as? [String : Any], for: UIControlState.normal)
        // 设置不可用状态
        let disableTextAttrs = NSMutableDictionary()
        disableTextAttrs[NSForegroundColorAttributeName] = ColorFromRGB(153.0, 153.0, 153.0 , 0.7)
        disableTextAttrs[NSFontAttributeName] = FONT(15.0)
        self.navigationBar.isTranslucent = false

        item.setTitleTextAttributes(disableTextAttrs as? [String : Any], for: UIControlState.disabled)
    }

   
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        viewController.automaticallyAdjustsScrollViewInsets = true
        if self.viewControllers.count > 0 {
            //当push 出页面时，隐藏导航栏按钮
            viewController.hidesBottomBarWhenPushed = true
            
            //设置导航栏左侧按钮
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem().itemWithTarg(target: self, action: #selector (MNavigationViewController.backBtnClick), image: "ebtn-return", hightImage: "ebtn-return")

        }
        super.pushViewController(viewController, animated: animated)
    }
    
    func backBtnClick() {
        self .popViewController(animated: true)
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
