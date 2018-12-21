//
//  PruebaController.swift
//  Tugo
//
//  Created by Alex on 12/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import AEImage

class PruebaController: UIViewController{
    
    @IBOutlet weak var prueba: UIView!
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var motionSettings  = MotionSettings()
      
        let  imageScrollView = ImageScrollView()
        imageScrollView.displayMode = .fillHeight
        imageScrollView.infiniteScroll = .horizontal
       
        
        imageScrollView.motionScrollDelegate?.motionSettings.isEnabled = true
        imageScrollView.motionScrollDelegate?.motionSettings.sensitivity = 1.0
        imageScrollView.image = #imageLiteral(resourceName: "panorama")
        imageScrollView.frame = prueba.bounds
        
        
        prueba.addSubview(imageScrollView)
        
      
        
    }
    
}
