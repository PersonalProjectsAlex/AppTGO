//
//  ChatControllerHost+TableViewDelegate.swift
//  Tugo
//
//  Created by Alex on 31/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit

extension ChatControllerHost: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return groupChannels.count > 0 ? groupChannels.count : 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = chatTableView.dequeueReusableCell(withIdentifier: K.cells.table.chatCell, for: indexPath) as? ChatCell else { return UITableViewCell() }
        if groupChannels.count > 0{
            cell.setGroups = groupChannels[indexPath.row]
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if groupChannels.count>0{
            selectedGroupChannel = groupChannels[indexPath.row]
            self.performSegue(withIdentifier: K.segues.ChatStoryboard.chatControllerToChatDetail, sender: self)
        }
    }
    
}
