//
//  DatePopup.swift
//  Tugo
//
//  Created by Alex on 10/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import HexColors

class DatePopup: UIViewController {
    
    let locale = Locale(identifier: "es_GT")
    var status = false
    let dateFormatter = DateFormatter()
    
    @IBOutlet weak var timePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        timePicker.locale = locale
        timePicker.setValue(HexColor("#7040F0") , forKey: "textColor")
       timePicker.datePickerMode = .date
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: timePicker.date.description)
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let a =  dateFormatter.string(from: date!)
        Singleton.shared.setDate(a)
        
    }
    
    @IBAction func timepickerChanged(_ sender: UIDatePicker) {
      print(sender.date)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        let date = dateFormatter.date(from: sender.date.description)
        dateFormatter.dateFormat = "yyyyMMdd"
        
        let a =  dateFormatter.string(from: date!)
        print(a)
        Singleton.shared.setDate(a)
        
    }
    
   
    
}
