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

class ChatImageDetailHostController: UIViewController {
    
    var selecteduserFile: String?
    
    
    @IBOutlet weak var photoImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = selecteduserFile else{return}
        photoImageView.sd_setImage(with: URL(string: image), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        
        
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
