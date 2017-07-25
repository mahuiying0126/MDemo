//
//  MCoursePackageView.swift
//  BangDemo
//
//  Created by yizhilu on 2017/7/11.
//  Copyright © 2017年 Magic. All rights reserved.
//

import UIKit

class MCoursePackageView: UICollectionView ,UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{

    let identityPackage = "coursePackage"
    /** *课程包数据 */
    var coursePackArray : NSArray?
    
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        self.backgroundColor = Whit
        self.bounces = false
        self.isScrollEnabled = false
        self.showsHorizontalScrollIndicator = false
        self.showsVerticalScrollIndicator = false
        self.delegate = self
        self.dataSource = self
        self.register(CoursePackageCollectionViewCell.self, forCellWithReuseIdentifier: identityPackage)
        
    }
    
    func packageFromData(dataArray:NSArray)  {
        let model = dataArray.firstObject as!DetailCoursePackageModel
        model.isSelect = true
        coursePackArray = dataArray
        self.reloadData()
    }
    
    //MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return coursePackArray!.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        
        let cell : CoursePackageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: identityPackage, for: indexPath) as! CoursePackageCollectionViewCell
        
        let model = self.coursePackArray?[indexPath.row] as!DetailCoursePackageModel
        cell.cellModel(model: model)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (Screen_width - 30) * 0.5
        return .init(width: width, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 10, left: 10, bottom: 10, right: 10)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
