//
//  ChatDetailController.swift
//  Tugo
//
//  Created by Alex on 4/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//
import UIKit
import SendBirdSDK
import Hero
import TLPhotoPicker
import NVActivityIndicatorView

protocol CreateGroupChannelSelectOptionViewControllerDelegate: class {
    func didFinishCreating(channel: SBDGroupChannel, vc: UIViewController)
}

class ChatDetailController: UIViewController, ConnectionManagerDelegate, SBDConnectionDelegate,SBDChannelDelegate, NVActivityIndicatorViewable {

    // MARK: - Let-Var
    weak var delegate: CreateGroupChannelSelectOptionViewControllerDelegate?
    var baseMessage = [SBDBaseMessage]()
    var selectedGroupChannel:SBDGroupChannel?
    var selectedAssets = [TLPHAsset]()
    var saveImage: UIImage?
    var imageState = Bool()
    var selecteduserFile: String?
    var arrayUser = [String]()
    var arrayUserImage = [String]()
    
    // MARK: - Outlets
    @IBOutlet weak var chatTableView: UITableView!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var itemsCollectionView: UICollectionView!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var profileImageview: UIImageView!
    
    // MARK: - LifeCycles
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
       
        
        SBDMain.add(self as SBDChannelDelegate, identifier: "com.tugo.prueba1")

    }
    
    override func viewWillAppear(_ animated: Bool) {
        //Calling register on Sendbird
        settiingSendBirdUser()
        
        if selectedAssets.count > 0{
            photosCollectionView.reloadData()
            photosCollectionView.isHidden = false
        }else{
            photosCollectionView.isHidden = true
        }
        
    }

    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.ChatStoryboard.chatToImageChatDetail{
            let detailController = segue.destination as! ChatImageDetailController
            detailController.selecteduserFile = selecteduserFile
        }
    }
    
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Tableview separator
        chatTableView.separatorColor = .clear
    }
    
    func setUpActions(){
        //Tableview Delegate
        chatTableView.delegate = self
        chatTableView.dataSource = self
        
        //Collectionview Delegate
        photosCollectionView.delegate = self
        photosCollectionView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: chatTableView, named: K.cells.table.messageChatTableCell)
        Core.shared.registerCellCollection(at: photosCollectionView, named: K.cells.collection.selectePhotosCollectionCell)
        
        //FIrst responder
        messageTextfield.becomeFirstResponder()
        
        //Setting Hero
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .cover(direction: .up)
        
        //Hiding collection
        photosCollectionView.isHidden = true
        
        if let group = selectedGroupChannel{
            guard let members = group.members else{return}
            guard let mem = members as? [SBDMember] else {return}
            
            for i in mem{
                arrayUser.append(i.userId)
                if let avatar = i.profileUrl{
                    arrayUserImage.append(avatar)
                }
                
            }
            
            let currentUser = Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName)
            arrayUser = arrayUser.filter{$0 != currentUser}
            userLabel.text = arrayUser.first
            
            
            let currentUserPhoto = Singleton.shared.checkValueSet(key: K.defaultKeys.User.userPhoto)
            arrayUserImage = arrayUserImage.filter{$0 != currentUserPhoto}
            if let avatar = arrayUserImage.first{
                profileImageview.sd_setImage(with: URL(string: avatar), placeholderImage: #imageLiteral(resourceName: "tugologo"))
            }
        }
    }
    
    @IBAction func addItemAction(_ sender: UIButton) {
        itemsCollectionView.isHidden = false
        let viewController = TLPhotosPickerViewController()
        viewController.delegate = self
        viewController.didExceedMaximumNumberOfSelection = { [weak self] (picker) in
            self?.showExceededMaximumAlert(vc: picker)
        }
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 1
        viewController.configure = configure
        viewController.selectedAssets = self.selectedAssets
        
        self.present(viewController, animated: true, completion: nil)
    }
    
    @IBAction func sendMessageAction(_ sender: UIButton) {
    
        if let message = messageTextfield.text, !message.isEmpty  {
             sendMessage(message: message)
        }
        
        
    }
    
    //Setting Chat Messages from SendBird
    private func settiingSendBirdUser(){
        chatTableView.reloadData()
        baseMessage.removeAll()
        
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        let userName = Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName)
        ConnectionManager.login(userId: userName, nickname: userName) { (user, error) in
            guard error == nil else {
                print(error?.domain)
                return
            }
            print(SBDMain.getCurrentUser()?.userId)
            
            guard let channel = weak.selectedGroupChannel else{return}
            SBDGroupChannel.getWithUrl(channel.channelUrl, completionHandler: { (group, error) in
                if error != nil {
                    NSLog("Error: %@", error!)
                    return
                }
                
                guard let group = group else{return}
                let messageQuery = group.createPreviousMessageListQuery()
                messageQuery?.loadPreviousMessages(withLimit: 45, reverse: true, completionHandler: { (messages, error) in
                    if error != nil {
                        NSLog("Error: %@", error!)
                        return
                    }
                    
                    guard let messages = messages else{return}
                    weak.baseMessage = messages
                    
                    weak.baseMessage.reverse()
                    
                    if weak.baseMessage.count > 0{
                        weak.chatTableView.reloadData()
                        DispatchQueue.main.async {
                            let indexPath = NSIndexPath(row: weak.baseMessage.count-1, section: 0)
                            weak.chatTableView.scrollToRow(at: indexPath as IndexPath, at: .bottom, animated: true)
                        }
                    }
                })
            })
        }
        
    }
    
    //Send message
    func sendMessage(message:String){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        
        let userName = Singleton.shared.checkValueSet(key: K.defaultKeys.User.userName)
        ConnectionManager.login(userId: userName, nickname: userName) { (user, error) in
            guard error == nil else {
                print(error?.domain)
                return
            }
            guard let channel = weak.selectedGroupChannel else{return}
            SBDGroupChannel.getWithUrl(channel.channelUrl, completionHandler: { (group, error) in
                if error != nil {
                    NSLog("Error: %@", error!)
                    return
                }
                
                guard let group = group else{return}
                
                switch weak.imageState{
                    
                    case true:
                        guard let image = weak.saveImage else{
                            print("Error imagen vacia")
                            return
                        }
                        guard let imageData = UIImageJPEGRepresentation(image, 0.5) else {return}
                        
                        group.sendFileMessage(withBinaryData: imageData, filename: "prueba", type: "image/png", size: 5, data: nil, customType: nil, completionHandler: { (message, error) in
                            if error != nil {
                                print(error)
                                return
                            }
                            weak.cleanImage(at: weak)
                        })
                    
                        group.sendUserMessage(message, data: nil, completionHandler: { (userMessage, error) in
                            if error != nil {
                                print(error)
                                return
                            }
                            weak.imageState = false
                            weak.settiingSendBirdUser()
                        })
                    
                    case false:
                    
                        group.sendUserMessage(message, data: nil, completionHandler: { (userMessage, error) in
                            if error != nil {
                                print(error)
                                return
                            }
                            weak.imageState = false
                            weak.messageTextfield.text = ""
                            weak.settiingSendBirdUser()
                        })
                        
                    
                    default:
                        print("Error")
                }
            })
        }
       
    }
    
    func cleanImage(at: ChatDetailController){
        at.imageState = false
        at.settiingSendBirdUser()
        at.saveImage = nil
        at.selectedAssets.removeAll()
        at.photosCollectionView.reloadData()
    }
    
    private func gettingData(){}
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //Custom loading
    func customLoading(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        let size = CGSize(width: 32, height: 32)
        weak.startAnimating(size, message: "", type: NVActivityIndicatorType.circleStrokeSpin)
    }
    
    // MARK: - Objective C
    
    // MARK: - SendBird
    func didConnect(isReconnection: Bool) {}
    func didDisconnect() {}
    
    func channel(_ sender: SBDBaseChannel, didReceive message: SBDBaseMessage) {
        settiingSendBirdUser()
        print(message.channelUrl)
    }
    
    
}




