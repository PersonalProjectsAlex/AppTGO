//
//  MainTabBarHostController.swift
//  Tugo
//
//  Created by Alex on 18/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import HexColors
import Spring

class MainTabBarHostController: UITabBarController,UITabBarControllerDelegate {

    // MARK: - Let-Var
    let button = SpringButton.init(type: .custom)
    let instanceHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.signInhost)
    var fromSecondStep = false
    
    // MARK: - Outlets
    @IBOutlet weak var bottomtabBar: UITabBar!
    
    override func viewDidLoad() {
        delegate = self
        button.animation = "squeezeDown"
        button.animate()
        button.setImage(#imageLiteral(resourceName: "BigButton"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.layer.cornerRadius = 32
        button.addTarget(self, action: #selector(action(sender:)), for: .touchUpInside)
        view.insertSubview(button, aboveSubview: self.tabBar)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        setUp()
        if fromSecondStep{
            self.sucessAlert()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1136:
                button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 70, height: 70)
                
            case 1334:
                print("iPhone 6/6S/7/8")
                
                button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 69, width: 76, height: 76)
            case 1920, 2208:
                button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 70, height: 70)
            case 2436:
              
                button.frame = CGRect.init(x: self.tabBar.center.x - 30, y: self.view.bounds.height - 105, width: 72, height: 72)
                print("iPhone X")

                
            default:
                button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 70, height: 70)
                
            }
        }
        
        
        let screenRect : CGRect =  UIScreen.main.bounds;
        let size = screenRect.size.height
        switch size {
        case 1024:
            button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 70, height: 70)
        case 1366:
            button.frame = CGRect.init(x: self.tabBar.center.x - 32, y: self.view.bounds.height - 74, width: 70, height: 70)
        default: break
            
        }
        
      
    }

    
    func setUp() {
        //Setting our controllers by instances on Storyboards in order to set them
        
        let first =  Core.shared.instantiateViewController(at: Core.shared.instanceStoryboard(name: K.storyboards.feed), identifier: "FeedController")
        
        let second =  Core.shared.instantiateViewController(at: Core.shared.instanceStoryboard(name: K.storyboards.plan), identifier: "PlansController" )
        
        let third =   Core.shared.instantiateViewController(at: Core.shared.instanceStoryboard(name: K.storyboards.chat), identifier: "ChatController" )
        
        let fourth =  Core.shared.instantiateViewController(at: Core.shared.instanceStoryboard(name: K.storyboards.profile), identifier: "ProfileController" )
        
        let middle =  Core.shared.instantiateViewController(at: Core.shared.instanceStoryboard(name: K.storyboards.feedHost), identifier: "FeedHostController")
        
        //configure the view controllers here...
        viewControllers = [first, second, middle, third, fourth]
        
        //First item
        
        tabBar.items?[0].image = #imageLiteral(resourceName: "search")
        tabBar.items?[0].selectedImage = #imageLiteral(resourceName: "search")
        tabBar.items?[0].title = "Explorar"
        
        //Second item
        tabBar.items?[1].image = #imageLiteral(resourceName: "Planes")
        tabBar.items?[1].selectedImage = #imageLiteral(resourceName: "Planes")
        tabBar.items?[1].title = "Planes"
        
        // Third item
        tabBar.items?[3].image = #imageLiteral(resourceName: "Mensajes")
        tabBar.items?[3].selectedImage = #imageLiteral(resourceName: "Mensajes")
        tabBar.items?[3].title = "Mensajes"
        
        
        //Middle Item
        
        tabBar.items?[2].title = " "
        
        let photo = !Singleton.shared.checkValueSet(key: K.defaultKeys.User.userPhoto).isEmpty ? Singleton.shared.checkValueSet(key: K.defaultKeys.User.userPhoto) : "https://st-listas.20minutos.es/images/2011-01/269966/list_640px.jpg?1297262775"
        
        guard let url = URL(string: photo) else {
            self.lastItem(at: self.tabBar, image: #imageLiteral(resourceName: "guatemala"))
            
            return
        }
        self.lastItem(at: self.tabBar, image: #imageLiteral(resourceName: "tugologo"))
        Core.shared.getDataFromUrl(url: url) { (data, urlresponse, error) in
            if let e = error {
                print("Error downloading cat picture: \(e)")
                self.lastItem(at: self.tabBar, image: #imageLiteral(resourceName: "guatemala"))
            } else {
                // No errors found.
                // It would be weird if we didn't have a response, so check for that too.
                if let res = urlresponse as? HTTPURLResponse {
                    print("Downloaded cat picture with response code \(res.statusCode)")
                    
                    if let imageData = data {
                        // Finally convert that Data into an image and do what you wish with it.
                        
                        guard let image = UIImage(data: imageData), res.statusCode == 200 else{
                            self.lastItem(at: self.tabBar, image: #imageLiteral(resourceName: "guatemala"))
                            return
                        }
                        
                        self.lastItem(at: self.tabBar, image: image)
                        
                        // Do something with your image.
                    } else {
                        self.lastItem(at: self.tabBar, image: #imageLiteral(resourceName: "guatemala"))
                    }
                } else {
                    self.lastItem(at: self.tabBar, image: #imageLiteral(resourceName: "guatemala"))
                    
                }
            }
        }
        
    }
    
    
    //Getting last item on tabbar
    func lastItem(at:UITabBar, image: UIImage){
        DispatchQueue.main.async {
            
            at.items?[4].image = Core.shared.maskRoundedImage(image: image, radius: 50, selected: false, borderColor: .clear).withRenderingMode(.alwaysOriginal)
            at.items?[4].selectedImage = Core.shared.maskRoundedImage(image: image, radius: 50, selected: true, borderColor: #colorLiteral(red: 0.4392156863, green: 0.2509803922, blue: 0.9411764706, alpha: 1)).withRenderingMode(.alwaysOriginal)
            at.items?[4].title = "Perfil"
        }
    }
    

    
    @objc fileprivate func action(sender: UIButton) {
    
        let actionSheetController = Core.shared.createActionsheet(title: "Opciones viajero", message: "")
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in}
        cancelAction.setValue( UIColor.lightGray, forKey: "titleTextColor")
        actionSheetController.addAction(cancelAction)
        
        //Create and add first option action
        let firstItem: UIAlertAction = UIAlertAction(title: "Calendario", style: .default) { action -> Void in
            self.performSegue(withIdentifier: K.segues.MenuHost.menuHostToCalendar, sender: self)
        }
        firstItem.setValue(#imageLiteral(resourceName: "Calendario "), forKey: "image")
        firstItem.setValue( #colorLiteral(red: 0.4392156863, green: 0.2509803922, blue: 0.9411764706, alpha: 1), forKey: "titleTextColor")
        actionSheetController.addAction(firstItem)
        
        //Create and add a second option action
        let secondItem: UIAlertAction = UIAlertAction(title: "Mis experiencias", style: .default) { action -> Void in
           
            self.performSegue(withIdentifier: K.segues.MenuHost.menuToTripHost, sender: self)
            
        }
        secondItem.setValue(#imageLiteral(resourceName: "myexperiencesicon"), forKey: "image")
        secondItem.setValue( #colorLiteral(red: 0.4392156863, green: 0.2509803922, blue: 0.9411764706, alpha: 1), forKey: "titleTextColor")
        actionSheetController.addAction(secondItem)
        
        //Create and add a third option action
        let thirdItem: UIAlertAction = UIAlertAction(title: "Nueva experiencia", style: .default) { action -> Void in
            self.performSegue(withIdentifier: K.segues.MenuHost.menuToNewExperienceHost, sender: self)
        }
        thirdItem.setValue(#imageLiteral(resourceName: "newexperienceicon"), forKey: "image")
        thirdItem.setValue( #colorLiteral(red: 0.4392156863, green: 0.2509803922, blue: 0.9411764706, alpha: 1), forKey: "titleTextColor")
        
        
        //thirdItem.setValue(0, forKey: "titleTextAlignment")
        actionSheetController.addAction(thirdItem)
        
        //Create and add a forth option action
//        let forthItem: UIAlertAction = UIAlertAction(title: "Mis ganancias", style: .default) { action -> Void in
//
//        }
//        actionSheetController.addAction(forthItem)
        
        //actionSheetController.view.tintColor = HexColor("#7040F0")
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
    
    func sucessAlert() {
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(didTap))
        Core.shared.customAlertPayment(at: view, image: #imageLiteral(resourceName: "paymentsuccess")).addGestureRecognizer(recognizer)
    }
    // MARK: - Objective C
    @objc func didTap() {
        fromSecondStep = false
        selectedIndex = 1
        
    }
    
}
