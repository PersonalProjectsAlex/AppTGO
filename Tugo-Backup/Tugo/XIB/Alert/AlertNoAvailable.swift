//
//  AlertNoAvailable.swift
//  Tugo
//
//  Created by Alex on 25/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//
import Lottie
import UIKit

class AlertNoAvailable: UIViewController {
    
    var animationView = LOTAnimationView()
    @IBOutlet weak var centerView: UIView!
        override func viewDidLoad() {
        super.viewDidLoad()
        
        animationView = LOTAnimationView(name: "loading")
        animationView.contentMode = .scaleAspectFill
        animationView.clipsToBounds = true
        animationView.frame = centerView.frame
        animationView.center = centerView.center
        centerView.addSubview(animationView)
        animationView.play()
        animationView.loopAnimation = true
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        animationView.stop()
    }


}
