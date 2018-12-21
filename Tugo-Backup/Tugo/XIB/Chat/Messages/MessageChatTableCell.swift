//
//  MessageChatTableCell.swift
//  Tugo
//
//  Created by Alex on 4/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SendBirdSDK
import SDWebImage


class MessageChatTableCell: UITableViewCell {

    var setBaseMessage: SBDBaseMessage?{
        didSet{
            setupCell2()
        }
    }
    
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var bubleView: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet  weak var fileImageView: UIImageView!
    
    @IBOutlet weak var righMargintConstraint: NSLayoutConstraint!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    var messageInOut = Bool()
    
    
    func setupCell2(){
        
        guard let message = setBaseMessage else{return}
        if message is SBDUserMessage{
            let userMessage = message as! SBDUserMessage
            //Setting text messages
            messageLabel.text = userMessage.message?.capitalizingFirstLetter()
            let color = userMessage.sender?.userId == Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName) ? UIColor.orange : UIColor.purple
            bubleView.backgroundColor = color
            
            let seteLeftConstraintValue = userMessage.sender?.userId == Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName) ? 95 : 2
            
            let seteRightConstraintValue = userMessage.sender?.userId == Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName) ? 2 : 95
            
            leftMarginConstraint.constant = CGFloat(integerLiteral: seteLeftConstraintValue)
            righMargintConstraint.constant = CGFloat(integerLiteral: seteRightConstraintValue)
            fileImageView.isHidden = true
        }
        
        if message is SBDFileMessage{
            let userFile = message as! SBDFileMessage
            fileImageView.sd_setImage(with: URL(string: userFile.url), placeholderImage: #imageLiteral(resourceName: "tugologo"))
            
            fileImageView.isHidden = false
            messageLabel.text = ""
            let seteLeftConstraintValue = userFile.sender?.userId == Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName) ? 95 : 2
            
            let seteRightConstraintValue = userFile.sender?.userId == Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName) ? 2 : 95
            
            leftMarginConstraint.constant = CGFloat(integerLiteral: seteLeftConstraintValue)
            righMargintConstraint.constant = CGFloat(integerLiteral: seteRightConstraintValue)
            let color = userFile.sender?.userId == Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName) ? UIColor.orange : UIColor.purple
            bubleView.backgroundColor = color
            
            
            
        }
        
    }
    
    


}
