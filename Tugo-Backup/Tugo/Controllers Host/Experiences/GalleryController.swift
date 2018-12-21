//
//  GalleryController.swift
//  Tugo
//
//  Created by Alex on 19/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import TLPhotoPicker

class GalleryController: UIViewController {
    
    // MARK: - Let-Var
    var images = [UIImage]()
    var showState = true
    var selectedAssets = [TLPHAsset]()
    
    // MARK: - Outlets
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up UI elements to be used through the code
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        if images.count > 0{
            weak.showState = true
            weak.performSegue(withIdentifier: "prueba", sender: nil)
            weak.images.removeAll()
            
        }else{
            if showState{
                weak.setSlider()
            }
        }
        
        
    }

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "prueba" {
            let detailController = segue.destination as! ImageSliderController
            detailController.imagesArray = images
        }
        
    }
    
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){}
    
    func setUpActions(){}
    
    private func gettingData(){}
    
    
    func setSlider(){
        selectedAssets.removeAll()
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 5
        configure.allowedVideo = false
        viewController.configure = configure
        viewController.selectedAssets = selectedAssets
        if self.selectedAssets.count > 0{
            self.showState = true
        }else{
             self.showState = false
        }
        self.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - Objective C
    
}
