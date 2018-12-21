//
//  AlertNoAvailable.swift
//  Tugo
//
//  Created by Alex on 25/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//
import UIKit
import KMPlaceholderTextView
import Alamofire

class AlertSetAboutMe: UIViewController {
    
    // MARK: - Let-Var
    let aboutMe = Singleton.shared.checkValueSet(key: K.defaultKeys.others.aboutMe)
    
    // MARK: - Outlets
    
    @IBOutlet weak var greetUserLabel: UILabel!
    @IBOutlet weak var aboutMeTextView: KMPlaceholderTextView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        if !aboutMe.isEmpty{
                weak.aboutMeTextView.text = aboutMe
        }
        
        if let aboutMe = aboutMeTextView.text {
            Singleton.shared.setAboutMe(aboutMe: aboutMe)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let aboutMe = aboutMeTextView.text {
            Singleton.shared.setAboutMe(aboutMe: aboutMe)
        }
    }
    

}
