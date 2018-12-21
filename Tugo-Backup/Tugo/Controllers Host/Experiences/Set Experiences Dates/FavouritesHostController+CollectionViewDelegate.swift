//
//  FavouritesHostController+CollectionViewDelegate.swift
//  Tugo
//
//  Created by Alex on 2/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension FavouritesHostController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categories.count > 0 ? categories.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  favouritesCollectionView.dequeueReusableCell(withReuseIdentifier: K.cells.collection.favouritesHostCollectionCell, for: indexPath) as? FavouritesHostCollectionCell else { return UICollectionViewCell() }
        
        if categories.count > 0{
            cell.setCategories = categories[indexPath.row]
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // get a reference to our storyboard cell
        let cell = collectionView.cellForItem(at: indexPath) as? FavouritesHostCollectionCell
        if categories.count > 0{
            
            if let index = favourites.index(where: { $0.index == categories[indexPath.row].id }) {
                favourites.remove(at: index)
            }
            
          
            favourites.append(FavouritesModel(index: categories[indexPath.row].id, row: indexPath.row))
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
       
        if categories.count > 0{
            print(categories[indexPath.row].id)
            if favourites.description.contains(categories[indexPath.row].id){
                
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
        
        if favourites.count > 0 && fromBack{
            
                for i in favourites{
                    
                    if indexPath.row == i.row{
                        cell.isSelected = true
                    }
                }
            
        }
        
    }
    

    
    //To Show 3 items per row
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 125, height: 125)
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
        //1
        switch kind {
        //2
        case UICollectionElementKindSectionHeader:
            //3
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind,
                                                                             withReuseIdentifier: K.cells.collection.titleHeaderView,
                                                                             for: indexPath) as! HeaderViewcell
            
            return headerView
        default:
            //4
            assert(false, "Unexpected element kind")
        }
    }
    
}
