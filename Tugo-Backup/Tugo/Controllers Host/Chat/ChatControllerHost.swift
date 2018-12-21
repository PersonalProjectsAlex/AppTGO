//
//  ChatController.swift
//  Tugo
//
//  Created by Alex on 31/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SendBirdSDK


class ChatControllerHost: UIViewController, ConnectionManagerDelegate, SBDConnectionDelegate{

    // MARK: - Let-Var
    var groupChannels = [SBDGroupChannel]()
    var selectedGroupChannel:SBDGroupChannel?
    let query = SBDGroupChannel.createMyGroupChannelListQuery()!
    
    // MARK: - Outlets
    @IBOutlet weak var chatTableView: UITableView!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()

        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //Calling register on Sendbird
        settiingSendBirdUser()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.ChatStoryboard.chatControllerToChatDetail {
            
            let detailController = segue.destination as! ChatDetailController
            detailController.selectedGroupChannel = selectedGroupChannel
        }
    }
 
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    
    func setUpActions(){
        //Tableview Delegate
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: chatTableView, named: K.cells.table.chatCell)
    }
    
    private func gettingData(){}
    
    private func settiingSendBirdUser(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        //Getting instances for user
        let userName = Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName)
        
        ConnectionManager.login(userId: userName, nickname: userName) { (user, error) in
            
            guard error == nil else {
                print(error?.domain.description)
                return
            }
            print(SBDMain.getCurrentUser()?.userId)

            //getting all channels/groups for user
            weak.query.includeEmptyChannel = true
            weak.query.loadNextPage(completionHandler: { (channels, error) in
                if (error != nil) {
                    print(error?.description)
                    return
                }
                
                guard let channels = channels else{return}
                weak.groupChannels = channels
                if weak.groupChannels.count > 0{
                    weak.chatTableView.reloadData()
                }
            })
        }
        
    }
    
    
    // MARK: - Objective C

    // MARK: - SendBird
    func didConnect(isReconnection: Bool) {}
    func didDisconnect() {}
    
}
