//
//  FeedController+CollectionViewDelegate.swift
//  Tugo
//
//  Created by Alex on 17/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension FeedController: UICollectionViewDataSource, UICollectionViewDelegate,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count > 0 ? categories.count : 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  storiesCollectionView.dequeueReusableCell(withReuseIdentifier: K.cells.collection.storiesCollectionCell, for: indexPath) as? StoriesCollectionCell else { return UICollectionViewCell() }
        

        if categories.count > 0{
            cell.setCategories = categories[indexPath.row]
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        if categories.count > 0{
            selectedCategory = categories[indexPath.row]
            performSegue(withIdentifier: K.segues.FeedStoryBoard.storiesToCategoryPerStorie, sender: nil)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
