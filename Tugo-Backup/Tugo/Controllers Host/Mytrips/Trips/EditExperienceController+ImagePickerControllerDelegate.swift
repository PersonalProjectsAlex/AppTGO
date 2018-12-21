//
//  EditExperienceController+ImagePickerControllerDelegate.swift
//  Tugo
//
//  Created by Alex on 15/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//


import Foundation
import UIKit
import TLPhotoPicker
import PhotosUI

extension EditExperienceController:TLPhotosPickerViewControllerDelegate{
    // MARK: - TLPIckerActions
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        // use selected order, fullresolution image
        selectedAssets = withTLPHAssets
        
        images.removeAll()
        
        let imageManager = PHCachingImageManager()
        let options = PHImageRequestOptions()
        options.isNetworkAccessAllowed = true
        options.isSynchronous = true
        options.resizeMode = PHImageRequestOptionsResizeMode.exact
        let targetSize = CGSize(width:800, height: 800)
        
        let assets = withTLPHAssets.compactMap({ $0.phAsset })
        for asset in assets {
            
            imageManager.requestImage(for: asset, targetSize: targetSize, contentMode: PHImageContentMode.aspectFit, options: options) { (receivedImage, info) in
                
                guard let image = receivedImage else { return }
                self.images.append(image)
                
            }
        }
        
        if images.count > 0{
            for i in self.images{
                
                changeImage(image: i)
            }
        }
        
        
        
    }
    
    
    func showExceededMaximumAlert(vc: UIViewController) {
        let alert = UIAlertController(title: "", message: "Exceed Maximum Number Of Selection", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        vc.present(alert, animated: true, completion: nil)
    }
    
    
    func photoPickerDidCancel() {
        self.navigationController?.dismiss(animated: true) {}
        self.dismiss(animated: true, completion: nil)
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
    
}
