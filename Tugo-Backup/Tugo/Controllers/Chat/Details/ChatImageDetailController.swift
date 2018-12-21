//
//  ChatImageDetailController.swift
//  Tugo
//
//  Created by Alex on 13/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SendBirdSDK
import SDWebImage

class ChatImageDetailController: UIViewController{
    
    var selecteduserFile: String?
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let downGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(self.downGestureHandler(_:)))
        downGestureRecognizer.direction = (.down)
        view.addGestureRecognizer(downGestureRecognizer)
        guard let image = selecteduserFile else{return}
        photoImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        
        
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func downGestureHandler(_ recognizer: UISwipeGestureRecognizer?) {
        self.dismiss(animated: true, completion: nil)
        print("hjgjg")
    }

    
  
}
