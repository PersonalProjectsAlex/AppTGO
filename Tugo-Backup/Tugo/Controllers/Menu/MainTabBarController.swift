//
//  MainTabBarController.swift
//  Tugo
//
//  Created by Alex on 29/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import SDWebImage

class MainTabBarController: UITabBarController {
    
    // MARK: - Let-Var
    var image:String?
    var fromSecondStep = false
    
    // MARK: - Outlets
    @IBOutlet weak var bottomtabBar: UITabBar!
    
    override func viewWillAppear(_ animated: Bool) {
        setUp()
        
        if fromSecondStep{
            self.sucessAlert()
        }
        
    }
    
    func setUp() {
        //Setting our controllers by instances on Storyboards in order to set them
       
        let first =  Core.shared.instantiateViewController(at: Core.shared.instanceStoryboard(name: K.storyboards.feed), identifier: "FeedController")
        
        let second =  Core.shared.instantiateViewController(at: Core.shared.instanceStoryboard(name: K.storyboards.plan), identifier: "PlansController" )
        
        let third =  Core.shared.instantiateViewController(at: Core.shared.instanceStoryboard(name: K.storyboards.chat), identifier: "ChatController" )
       
        let fourth =  Core.shared.instantiateViewController(at: Core.shared.instanceStoryboard(name: K.storyboards.profile), identifier: "ProfileController" )
        
        //configure the view controllers here...
        viewControllers = [first, second, third, fourth]
        
        //First item
        
        tabBar.items?[0].image = #imageLiteral(resourceName: "search")
        tabBar.items?[0].selectedImage = #imageLiteral(resourceName: "search")
        tabBar.items?[0].title = "Explorar"
        
        //Second item
        tabBar.items?[1].image = #imageLiteral(resourceName: "Planes")
        tabBar.items?[1].selectedImage = #imageLiteral(resourceName: "Planes")
        tabBar.items?[1].title = "Planes"
        
        // Third item
        tabBar.items?[2].image = #imageLiteral(resourceName: "Mensajes")
        tabBar.items?[2].selectedImage = #imageLiteral(resourceName: "Mensajes")
        tabBar.items?[2].title = "Mensajes"
        
        let avatar = Singleton.shared.checkValueSet(key: K.defaultKeys.User.userPhoto)
        //image = avatar
        
        let photo = !Singleton.shared.checkValueSet(key: K.defaultKeys.User.userPhoto).isEmpty ? avatar : "https://st-listas.20minutos.es/images/2011-01/269966/list_640px.jpg?1297262775"
        
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
            at.items?[3].image = Core.shared.maskRoundedImage(image: image, radius: 50, selected: false, borderColor: .clear).withRenderingMode(.alwaysOriginal)
            at.items?[3].selectedImage = Core.shared.maskRoundedImage(image: image, radius: 50, selected: true, borderColor: .orange).withRenderingMode(.alwaysOriginal)
            at.items?[3].title = "Perfil"
        }
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
