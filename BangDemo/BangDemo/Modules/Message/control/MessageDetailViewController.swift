//
//  MessageDetailViewController.swift
//  BangDemo
//
//  Created by yizhilu on 2017/5/22.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MessageDetailViewController: UIViewController , UIWebViewDelegate{

    var messageId : String?
    /*
     * 分享信息
     **/
    var messageTitle : String?
    var msgImageUrl : String?
    var msgDetail : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.backgroundColor = Whit
        self.navigationController?.navigationBar.barTintColor = ColorFromRGB(241, 241, 241, 1.0)
        UIApplication.shared .statusBarStyle = .default
        self.navigationItem.leftBarButtonItem = UIBarButtonItem().itemWithTarg(target: self, action: #selector (backBarButtonItemClick), image: "blue_message-return", hightImage: "blue_message-return")
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem().itemWithTarg(target: self, action: #selector (MessageRightBtnClick), image: "blue_btn-share", hightImage: "blue_btn-share")
        setMessageDetailLayout()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super .viewWillDisappear(animated)
        self.navigationController?.navigationBar.barTintColor = navColor
        UIApplication.shared .statusBarStyle = .lightContent
    }
    
    func setMessageDetailLayout()  {
        let courseIdString = articleInfo()+("/")+(self.messageId)!
        let url = URL.init(string: courseIdString)
        let request = URLRequest.init(url: url!)
        self.messageWeb.loadRequest(request)
        self.view.addSubview(self.messageWeb)
        
        
    }
    func webViewDidStartLoad(_ webView: UIWebView) {
        self.tipHUD .show(animated: true)
    }
    func webViewDidFinishLoad(_ webView: UIWebView) {
        //加载完了
        self.tipHUD.hide(animated: true)
    }
    
    func backBarButtonItemClick()  {
        self.navigationController?.popViewController(animated: true)
    }
    func MessageRightBtnClick()  {
        //分享
    }
    
    lazy var messageWeb : UIWebView = {
        let temp = UIWebView.init(frame: CGRect.init(x: 0, y: 0, width: Screen_width, height: Screen_height - 64))
        temp.delegate = self

        return temp
    }()
    
    lazy var tipHUD :MBProgressHUD = {
        
        let tempHUD = MBProgressHUD.showAdded(to: self.view, animated: true)
    
        tempHUD.mode = MBProgressHUDMode.indeterminate
        tempHUD.label.text = "正在加载"
        
        return tempHUD
        
    }()
    
    deinit {
        print("销毁了")
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
