//
//  DetailsController+SendBirdDelegate.swift
//  Tugo
//
//  Created by Alex on 14/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import SendBirdSDK

extension DetailsController: ConnectionManagerDelegate, SBDConnectionDelegate{
    
    // MARK: - Sendbird SiginIn per user
    func registerSendbird(){
        
        let userName = Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName)
        guard let experiences = selectedExperience else{return}
        guard let image = selectedExperience?.assets.first?.url else{return}
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        ConnectionManager.login(userId: userName, nickname: userName) { (user, error) in
            guard error == nil else {
                print(error?.domain.description)
                return
            }
            
            SBDGroupChannel.createChannel(withName: experiences.name, userIds: ["cris01",userName], coverUrl: image, data: "", completionHandler: { (channel, error) in
                guard error == nil else {return}
                weak.selectedGroupChannel = channel
                weak.performSegue(withIdentifier: K.segues.FeedStoryBoard.detailToChatController, sender: nil)
                print(channel)
            })
            
        }
    }
    
    // MARK: - Sendbird Delegate
    func didConnect(isReconnection: Bool) {}
    func didDisconnect() {}
}

