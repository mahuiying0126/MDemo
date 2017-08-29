//
//  MDownTableViewCell.swift
//  BangDemo
//
//  Created by yizhilu on 2017/8/25.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MDownTableViewCell: UITableViewCell {

    /** *图片 */
    var videoImage : UIImageView?
    /** *标题 */
    var  videoNameLB : UILabel?
    /** *缓存提示 */
    var  fileSizeLB : UILabel?
    /** *缓存进度条 */
    var  progressView : UIProgressView?
    /** *状态按钮 */
    var stateButton : UIButton?
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        videoImage = UIImageView()
        self.contentView.addSubview(videoImage!)
        videoImage?.layer.masksToBounds = true
        videoImage?.layer.cornerRadius = 30
        
        videoNameLB = UILabel()
        videoNameLB?.textColor = .black
        videoNameLB?.font = FONT(15)
        videoNameLB?.numberOfLines = 2
        self.contentView.addSubview(videoNameLB!)
        
        fileSizeLB = UILabel()
        fileSizeLB?.textColor = .black
        fileSizeLB?.font = FONT(13)
        self.contentView.addSubview(fileSizeLB!)
        
        progressView = UIProgressView()
        progressView?.progressTintColor = .green
        progressView?.progress = 0
        self.contentView.addSubview(progressView!)
        
        stateButton = UIButton.init(type: .custom)
        stateButton?.setTitle("等待中", for: .normal)
        stateButton?.setTitleColor(ColorFromRGB(31, 83, 197, 1.0), for: .normal)
        stateButton?.setBackgroundImage(MIMAGE("sbtn-pause"), for: .normal)
        stateButton?.titleLabel?.font = FONT(15)
        
        self.contentView.addSubview(stateButton!)
        let line = UIView()
        line.backgroundColor = .gray
        self.contentView.addSubview(line)
        
        videoImage?.snp.makeConstraints({ (make) in
            make.top.left.equalTo(self.contentView).offset(10)
            make.width.height.equalTo(60)
        })
        
        videoNameLB?.snp.makeConstraints({ (make) in
            make.top.equalTo(videoImage!.snp.top)
            make.left.equalTo(videoImage!.snp.right).offset(10)
            make.right.equalTo(self.contentView.snp.right).offset(-80)
        })
        
        fileSizeLB?.snp.makeConstraints({ (make) in
            make.left.equalTo(videoNameLB!.snp.left)
            make.bottom.equalTo(videoImage!.snp.bottom).offset(-5)
            make.height.equalTo(15)
        })
        
        progressView?.snp.makeConstraints({ (make) in
            make.top.equalTo(videoImage!.snp.bottom).offset(2)
            make.left.equalTo(fileSizeLB!.snp.left)
            make.height.equalTo(3)
            make.right.equalTo(self.contentView.snp.right).offset(-70)
            
        })
        
        stateButton?.snp.makeConstraints({ (make) in
            make.right.equalTo(self.contentView.snp.right).offset(-10)
            make.width.equalTo(60)
            make.height.equalTo(30)
            make.centerY.equalToSuperview()
        })
        
        line.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.bottom.equalToSuperview()
            make.height.equalTo(0.5)
        }
        
    }
    
    func cellForModel(_ model : DownloadingModel)  {
        videoNameLB?.text = model.videoName
        videoImage?.af_setImage(withURL: URL.init(string: model.imageUrl!)!,placeholderImage:UIImage.init(named: "加载中"))
        
        progressView?.progress = 0.0
        fileSizeLB?.text = "等待下载中..."
        if model.videoState == 3 {
            stateButton?.setTitle("暂停", for: .normal)
        }
        if model.videoState == 6 || model.videoState == 8 {
            stateButton?.setTitle("继续", for: .normal)
        }
        
        if model.videoState == 5 {
            stateButton?.setTitle("重试", for: .normal)
        }
    }
    
    func updataCellForModel(_ model : DownloadInfo)  {
        let curren = (Float(model.progress)/10000.0)*(Float(model.size)/1024.0/1024.0)
        let totle  = Float(model.size)/1024.0/1024.0
        if curren > 0 && totle > 0 {
            fileSizeLB?.text = String.init(format: "%.2fM / %.2fM", curren,totle)
        }else{
            fileSizeLB?.text = "等待下载中..."
        }
        
        progressView?.progress = Float(model.progress) / 10000.0
        if model.status == 3 {
            stateButton?.setTitle("暂停", for: .normal)
        }
        if model.status == 6 || model.status == 8 {
            stateButton?.setTitle("继续", for: .normal)
        }
        
        if model.status == 5 {
            stateButton?.setTitle("重试", for: .normal)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
