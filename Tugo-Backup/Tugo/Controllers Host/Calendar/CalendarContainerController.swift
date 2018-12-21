//
//  CalendarContainerController.swift
//  Tugo
//
//  Created by Alex on 30/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class CalendarContainerController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}
