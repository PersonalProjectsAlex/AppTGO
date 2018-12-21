//
//  ChatCell.swift
//  Tugo
//
//  Created by Alex on 31/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SendBirdSDK
import SDWebImage
import SwiftMoment

class ChatCell: UITableViewCell {

    var setGroups: SBDGroupChannel?{
        didSet {
            setupCell()
        }
    }
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var senderLabel: UILabel!
    @IBOutlet weak var lastMessageLabel: UILabel!
    @IBOutlet weak var updatedAtLabel: UILabel!
    @IBOutlet weak var profileImageview: RoundedImageView!
    @IBOutlet weak var newMessageIndicator: UIImageView!
    
    var arrayUser = [String]()
    var arrayUserImage = [String]()
    
    
    func setupCell(){
        guard let groups = setGroups else{return}
        titleLabel.text = groups.name
        let members = groups.members
        guard let mem = members as? [SBDMember] else {
            return
        }
        
        for i in mem{
            arrayUser.append(i.userId)
            if let avatar = i.profileUrl{
                arrayUserImage.append(avatar)
            }
            
        }
        groups.lastMessage?.createdAt
        let currentUser = Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName)
        arrayUser = arrayUser.filter{$0 != currentUser}
        guard let senderName = arrayUser.first else{return}
        senderLabel.text = "@\(senderName)"
        
        if let cover = groups.coverUrl, !cover.isEmpty{
            profileImageview.sd_setImage(with: URL(string: cover), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        }
        
        //Setting last message
        guard let a = Double(exactly: (groups.lastMessage?.createdAt)!) else{return}
        let d = Date(timeIntervalSince1970: a)
        
        
        
        
        let currentUserPhoto = Singleton.shared.checkValueSet(key: K.defaultKeys.User.userPhoto)
        arrayUserImage = arrayUserImage.filter{$0 != currentUserPhoto}
        
//        if let avatar = arrayUserImage.first{}
        
        newMessageIndicator.isHidden = groups.unreadMessageCount > 0 ? false: true
        
        guard let lastMessage = groups.lastMessage else { return }
        if lastMessage is SBDUserMessage{
            let userMessage = lastMessage as! SBDUserMessage
            lastMessageLabel.text = userMessage.message
        }
        
        
    }
    func minutesToHoursMinutes (minutes : Int) -> (hours : Int , leftMinutes : Int) {
        return (minutes / 60, (minutes % 60))
    }
    
}
