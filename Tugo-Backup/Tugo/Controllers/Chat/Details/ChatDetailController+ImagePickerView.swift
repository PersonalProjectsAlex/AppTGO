//
//  ChatDetailController+ImagePickerView.swift
//  Tugo
//
//  Created by Alex on 5/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import TLPhotoPicker

extension ChatDetailController:TLPhotosPickerViewControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource{
    // MARK: - TLPIckerActions
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        self.selectedAssets = withTLPHAssets
    }
    
    
    func showExceededMaximumAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    func photoPickerDidCancel() {
        // cancel
    }
    
    func dismissComplete() {
        // picker dismiss completion
    }
    
    func didExceedMaximumNumberOfSelection(picker: TLPhotosPickerViewController) {
        self.showExceededMaximumAlert(vc: picker)
    }
    
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        picker.dismiss(animated: true) {
            let alert = UIAlertController(title: "", message: "Denied albums permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        let alert = UIAlertController(title: "", message: "Denied camera permissions granted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        picker.present(alert, animated: true, completion: nil)
    }
    
    // MARK: - CollectionView
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return selectedAssets.count > 0 ? selectedAssets.count : 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell =  photosCollectionView.dequeueReusableCell(withReuseIdentifier: K.cells.collection.selectePhotosCollectionCell, for: indexPath) as? SelectePhotosCollectionCell else { return UICollectionViewCell() }
        if self.selectedAssets.count > 0{
            cell.photoimageView.image = self.selectedAssets[indexPath.row].fullResolutionImage
            saveImage = self.selectedAssets[indexPath.row].fullResolutionImage
            imageState = true
        }else{
            imageState = false
            cell.photoimageView.image = #imageLiteral(resourceName: "tugologo")
        }
        return cell
    }
    
    


}
