//
//  CategoryRow.swift
//  Agua
//
//  Created by Edgar Trujillo on 4/12/16.
//  Copyright © 2016 Edgar Trujillo. All rights reserved.
//

import UIKit


import UIKit

class CategoryRow : UITableViewCell {
    @IBOutlet weak var collectionView: UICollectionView!
    var category:Category? = nil {
        didSet {
            }
    }
}

extension CategoryRow : UICollectionViewDataSource {
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return category!.rewards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("videoCell", forIndexPath: indexPath) as! ccell
        if let category = category {
            cell.reward = category.rewards[indexPath.row]
        }
        return cell
    }
    
}

extension CategoryRow : UICollectionViewDelegateFlowLayout {
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
      //  let itemsPerRow:CGFloat = 4
        let hardCodedPadding:CGFloat = 5
        let itemHeight = collectionView.bounds.height - (2 * hardCodedPadding)
        let itemWidth = itemHeight * 300 / 444
        return CGSize(width: itemWidth, height: itemHeight)
    }
    
}