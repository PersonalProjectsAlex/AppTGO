//
//  MethodTableCell.swift
//  Tugo
//
//  Created by Alex on 20/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class MethodTableCell: UITableViewCell {

    var setCards: CardElement?{
        didSet {
            setupCell()
        }
    }
    
    var setBankAccount: BankAccount?{
        didSet {
            setupBankAccount()
        }
    }
    
    @IBOutlet weak var numbercardLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    
    func setupCell(){
        guard let cards = setCards else{return}
        numbercardLabel.text = cards.friendlyCard
        
    }
    
    func setupBankAccount(){
        guard let cards = setBankAccount else{return}
        numbercardLabel.text = cards.accountNumber
        iconImageView.image = #imageLiteral(resourceName: "iconbank")
        
    }
    
}
