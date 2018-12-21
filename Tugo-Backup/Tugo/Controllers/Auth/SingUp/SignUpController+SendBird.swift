//
//  SignUpController+SendBird.swift
//  Tugo
//
//  Created by Alex on 28/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import SendBirdSDK
extension SignUpController: ConnectionManagerDelegate, SBDConnectionDelegate{
    
    
    // MARK: - Sendbird SiginIn per user
    func registerSendbird(nickname:String, userID: String, userPhoto: String){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        ConnectionManager.login(userId: userID, nickname: nickname) { (user, error) in
            guard error == nil else {
                print(error?.domain.description)
                return
            }
            
            SBDMain.updateCurrentUserInfo(withNickname: nil, profileUrl: userPhoto, completionHandler: { (error) in
                if let error = error{
                    print(error)
                }else{
                    print("Photo updated")
                }
            })
        }
    }
    
    // MARK: - Sendbird Delegate
    func didConnect(isReconnection: Bool) {}
    func didDisconnect() {}
}
