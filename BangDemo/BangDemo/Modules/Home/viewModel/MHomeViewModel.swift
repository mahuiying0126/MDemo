//
//  MHomeViewModel.swift
//  BangDemo
//
//  Created by yizhilu on 2017/7/24.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

typealias courseDidSelectModelBlock = (_ cellModel : HomeCourseModel) -> ()

class MHomeViewModel: NSObject,UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
    /** *cell点击事件 */
    var cellDidSelectEvent : courseDidSelectModelBlock?
    
    func numberOfSections(in collectionView: UICollectionView) -> Int{
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        let tempArray:NSArray = self.dataArray[section] as! NSArray
        return tempArray.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell :HomeCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: MHomeViewController.reuseIdentifier, for: indexPath as IndexPath) as! HomeCollectionViewCell
        let array  = self.dataArray[indexPath.section] as! NSArray
        let model  = array[indexPath.row] as! HomeCourseModel
        cell.cellForModel(model: model)
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        return CGSize.init(width: Screen_width * 0.5, height: Screen_width * 0.41 )
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView{
        var view = UICollectionReusableView();
        if kind == UICollectionElementKindSectionHeader {
            let headView = collectionView .dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: MHomeViewController.reusableView, for: indexPath) as! HomeHeadCollectionReusableView
            view = headView
            headView.moreBtnBlock = {
               ///更多课程
                
            }
            if indexPath.section == 0 {
                headView.recommandLabel?.text = "热门课程"
                headView.recommadIcon?.image = UIImage.init(named: "热")
            }else{
                headView.recommandLabel?.text = "小编推荐"
                headView.recommadIcon?.image = UIImage.init(named: "荐")
            }
        }
        return view
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        
        return CGSize.init(width: Screen_width, height: 50.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat{
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let tempArray  = self.dataArray[indexPath.section] as! NSArray
        let model  = tempArray[indexPath.row] as! HomeCourseModel
        self.cellDidSelectEvent!(model)
    }
    lazy var dataArray : NSMutableArray = {
        
        var tempArray = NSMutableArray()
        
        return tempArray
        
    }()
    
}
