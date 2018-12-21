//
//  TacoDialogView.swift
//  Demo
//
//  Created by Tim Moose on 8/12/16.
//  Copyright © 2016 SwiftKick Mobile. All rights reserved.
//

import UIKit
import SwiftMessages

class BecomeHostDialogView: MessageView {
    
    // MARK: - Let-Var
   
    let codePendient = Singleton.shared.checkisBool(key: K.defaultKeys.Auth.Host.pendingState)
    
    
    // MARK: - Outlets
    @IBOutlet weak var alertImageView: UIImageView!
    
    // MARK: - LifeCycles
    
}
