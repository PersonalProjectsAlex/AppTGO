//
//  MethodPaymentController.swift
//  Tugo
//
//  Created by Alex on 20/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import fluid_slider

class MethodPaymentController: UIViewController {

    @IBOutlet weak var slider: Slider!
    
    override func viewDidLoad() {
        super.viewDidLoad()

      
       
        
        
        view.addSubview(slider)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     
    }
 
    

}
