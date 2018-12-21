//
//  ChatDetailController+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 4/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import SendBirdSDK



extension ChatDetailController: UITableViewDelegate,UITableViewDataSource{
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return baseMessage.count > 0 ? baseMessage.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: K.cells.table.messageChatTableCell , for: indexPath) as? MessageChatTableCell else { return UITableViewCell() }
        if baseMessage.count > 0{
            cell.setBaseMessage = baseMessage[indexPath.row]
            
        }
        
        //cell.setMessage
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 115
    }
    
//    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 115
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return UITableViewAutomaticDimension
//    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}

        if baseMessage.count > 0{
            let message = baseMessage[indexPath.row]
            if message is SBDFileMessage{
                let userFile = message as! SBDFileMessage
                weak.selecteduserFile = userFile.url
                self.performSegue(withIdentifier: K.segues.ChatStoryboard.chatToImageChatDetail, sender: self)
            }
        }
    }
    
    
}
