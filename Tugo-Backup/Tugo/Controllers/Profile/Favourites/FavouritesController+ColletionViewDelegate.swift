//
//  FavouritesController+ColletionViewDelegate.swift
//  Tugo
//
//  Created by Alex on 22/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension FavouritesController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoriesMe.count > 0 ? categoriesMe.count : 0
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  favouritesCollectionView.dequeueReusableCell(withReuseIdentifier: K.cells.collection.favouritesCollectionCell, for: indexPath) as? FavouritesCollectionCell else { return UICollectionViewCell() }
        
        if categoriesMe.count > 0{
            cell.setFavourites = categoriesMe[indexPath.row]
        }
        
        return cell
    }
    
    //--Drawing favourites
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let category = categoriesMe[indexPath.row]
        
        if categoriesMe.count > 0 && !category.isLiked{
            
            favourites.append(FavouritesModel(index: categoriesMe[indexPath.row].id, row: indexPath.row))
            print(category)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as? FavouritesCollectionCell
        
        if categories.count > 0{
            
            if favourites.description.contains(categories[indexPath.row].id){
                cell?.isSelected = false
                if let index = favourites.index(where: { $0.index == categories[indexPath.row].id }) {
                    favourites.remove(at: index)
                    
                }
            }
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if cell.isSelected {
            cell.isSelected = true
        } else {
            cell.isSelected = false
        }
    }

    //--Collection cell for delegates
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var size = CGSize()
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            
            case 1920, 2208:
                
                size =  CGSize(width: 127, height: 127)
                
            case 2436:
                
                size =  CGSize(width: 126, height: 126)
                
            default:
                
                size =  CGSize(width: 123, height: 123)
            }
        }
        return size
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: 80)
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
    
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: K.cells.collection.titleHeaderView,
                                                                             for: indexPath) as! HeaderViewcell
            
            return headerView
        default:
            assert(false, "Unexpected element kind")
        }
    }
    
}
