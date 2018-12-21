//
//  LocationPopup.swift
//  MyShot
//
//  Created by Administrador on 26/05/18.
//  Copyright © 2018 avalogics. All rights reserved.
//

import UIKit
import HexColors

class LocationPopup: UIViewController {

    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.setValue(HexColor("#7040F0") , forKey: "textColor")
       
    }

    override func viewWillDisappear(_ animated: Bool) {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        
        let a = formatter.string(from: timePicker.date)
        print(a)
        Singleton.shared.setTime(a)
    }
    
    @IBAction func timepickerChanged(_ sender: UIDatePicker) {
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        let a = formatter.string(from: sender.date)
        print(a)
        Singleton.shared.setTime(a)
        
    }
    

}
