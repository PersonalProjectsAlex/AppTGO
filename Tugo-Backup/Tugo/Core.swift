//
//  Core.swift
//  Tugo
//
//  Created by Alex on 16/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import ImageSlideshow
import HexColors
import MapKit
import SwiftMessages
import Alamofire
import Lottie
import UserNotificationsUI
import NotificationCenter
import UserNotifications
import SimpleImageViewer


enum Lotties: String{
    case prueba = "prueba"
    case loading = "loading"
}
enum LottieAction{
    case play
    case stop
}


class Core {
    // MARK: - Let-Var
    static let shared = Core()
    private init() {}
    
    
    //MARK: - UI
    
    //Show Alert Message (function)
    func alert(message: String, title: String, at viewController: UIViewController){
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okayAction = UIAlertAction(title: K.titles.textConfirmAlert, style: .cancel, handler: nil)
        alertController.addAction(okayAction)
        viewController.present(alertController, animated: true, completion: nil)
    }
    
    //Show share controller
    func showSharedController(at:UIViewController, text:String, image:UIImage){
        let vc = UIActivityViewController(activityItems: [text], applicationActivities: [])
        at.present(vc, animated: true, completion: nil)
    }
    
    //ImageSlider general features
    func imagesliderFeatures(slideShow:ImageSlideshow){
        slideShow.backgroundColor = .white
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideShow.clipsToBounds = true
       
    }
    
    //ImageSlider general features
    func imagesliderFeaturesCustom(slideShow:ImageSlideshow){
        slideShow.backgroundColor = .white
        slideShow.contentScaleMode = UIViewContentMode.scaleAspectFill
        slideShow.clipsToBounds = true
        
    }
    
    //Regex email
    func isValidEmail(testStr:String) -> Bool {
        print("validate emilId: \(testStr)")
        let emailRegEx = "^(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?(?:(?:(?:[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+(?:\\.[-A-Za-z0-9!#$%&’*+/=?^_'{|}~]+)*)|(?:\"(?:(?:(?:(?: )*(?:(?:[!#-Z^-~]|\\[|\\])|(?:\\\\(?:\\t|[ -~]))))+(?: )*)|(?: )+)\"))(?:@)(?:(?:(?:[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)(?:\\.[A-Za-z0-9](?:[-A-Za-z0-9]{0,61}[A-Za-z0-9])?)*)|(?:\\[(?:(?:(?:(?:(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))\\.){3}(?:[0-9]|(?:[1-9][0-9])|(?:1[0-9][0-9])|(?:2[0-4][0-9])|(?:25[0-5]))))|(?:(?:(?: )*[!-Z^-~])*(?: )*)|(?:[Vv][0-9A-Fa-f]+\\.[-A-Za-z0-9._~!$&'()*+,;=:]+))\\])))(?:(?:(?:(?: )*(?:(?:(?:\\t| )*\\r\\n)?(?:\\t| )+))+(?: )*)|(?: )+)?$"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        let result = emailTest.evaluate(with: testStr)
        return result
    }
    
    //Validate password
    func confirmPassword(password: String, confirm:String) -> Bool{
        
        if password == confirm{
            return true
        }else{
            return false
        }
        return false
    }
    
    //Mapkit features
    func mapkitFeatures(mapKit:MKMapView){
        mapKit.isScrollEnabled = false
        mapKit.isUserInteractionEnabled = true
    }
    
    //Opening waze
    func openWaze(latitude: Double, longitude: Double) {
        
      
            if UIApplication.shared.canOpenURL(URL(string: "waze://")!) {
                // Waze is installed. Launch Waze and start navigation
                let urlStr = String(format: "waze://?ll=%f,%f&navigate=yes", latitude, longitude)
                guard let url = URL(string: urlStr) else{return}
                UIApplication.shared.open(url)
            } else {
                // Waze is not installed. Launch AppStore to install Waze app
               UIApplication.shared.open(URL(string: "https://www.waze.com/location?ll=\(latitude),\(longitude)&navigate=yes")!, options: [:], completionHandler: nil)
            }
        
    }
    
    //Opening Google Maps
    func openGoogleMaps() {
        let lat = 13.7104146
        let lon = -89.2514715
        if let addressUrl = URL(string: "comgooglemaps://?saddr=&daddr=\(lat),\(lon)"), UIApplication.shared.canOpenURL(URL(string: "comgooglemaps://")!) && UIApplication.shared.canOpenURL(addressUrl)  {
            
            UIApplication.shared.open(addressUrl, options: [:], completionHandler: nil)
        }
        else if let webUrl = URL(string: "https://www.google.co.in/maps/dir/?saddr=&daddr=\(lat),\(lon)") {
            UIApplication.shared.open(webUrl, options: [:], completionHandler: nil)
        }
    }
    

    
    
    //Transition color on Details at feed controller
    func transitionatbottom(bottomView:UIView,bookButton: UIButton){
        DispatchQueue.main.async {
            bottomView.backgroundColor = .clear
            bookButton.layer.borderColor = UIColor.clear.cgColor
            bookButton.layer.borderWidth = 0
            
            Core.shared.settinGradient(at: bookButton)
        }
    }
    //Transition coloras swipe cell
   
    
    
    //Setting storyboards on TabPager
    func setStoryBoardName(storyboard: String, controller: String, at: UIViewController) -> UIViewController{
        return UIStoryboard(name: storyboard, bundle: nil).instantiateViewController(withIdentifier: controller)
    }
    
    
    //Making round image with Avatar
    func maskRoundedImage(image: UIImage, radius: CGFloat, selected:Bool, borderColor: UIColor) -> UIImage {
        let avatar = SwiftyAvatar(size: 20,
                                  roundess: 2,
                                  borderWidth: 2,
                                  borderColor: borderColor,
                                  background: .black)
        if selected{
            avatar.borderColor = borderColor
        }else{
            avatar.borderColor = .clear
        }
        avatar.image = image
        avatar.contentMode = .scaleAspectFill
        avatar.clipsToBounds = true
        avatar.frame.size = CGSize(width: 30, height: 30)
        let layer = avatar.layer
        
        UIGraphicsBeginImageContextWithOptions(avatar.bounds.size, false, 0.0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let roundedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return roundedImage!
    }
    
    //Intance storyboard
    func instanceStoryboard(name:String) -> UIStoryboard {
        let storyboard = UIStoryboard(name: name, bundle: nil)
        return storyboard
    }
    
    //instantiateViewController
    func instantiateViewController(at: UIStoryboard, identifier: String) -> UIViewController {
        let instanced =  at.instantiateViewController(withIdentifier: identifier)
        return instanced
        
    }
    
    //getting some dat fro a custom URL for the most part with images
    func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }
    
    //Showing message at bottom
    func customAlertNavbar(at : UIView)->MessageView{
        
        let view: NewUserDialogView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        
        var config = SwiftMessages.defaultConfig
        
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
        
        return view
    }
    
    //Showing message at bottom
    func customAlertPayment(at : UIView, image: UIImage)->MessageView{
        
        let view: NewUserDialogView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        
        var config = SwiftMessages.defaultConfig
        view.alertImageView.image = image
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
        
        return view
    }
    
    
    //Showing message at bottom
    func customAlertNavbarProfile(image: UIImage, at : UIView)->MessageView{
        
        let view: BecomeHostDialogView = try! SwiftMessages.viewFromNib()
        view.configureDropShadow()
        
        var config = SwiftMessages.defaultConfig
        config.presentationContext = .view(at)
        view.alertImageView.image = image
        config.duration = .forever
        config.presentationStyle = .bottom
        config.dimMode = .gray(interactive: true)
        SwiftMessages.show(config: config, view: view)
        
        return view
    }
    
    //Setting gradient
    func settinGradient(at:UIButton){
        guard let orange = HexColor(K.colors.orange) else {return}
        at.setGradientBackground(colorOne: orange , colorTwo: .orange)
    }
    
    //Setting gradient
    func settinGradientHost(at:UIButton){
        guard let purple = HexColor(K.colors.purple) else {return}
        guard let darkPurple = HexColor(K.colors.darkPurple) else {return}
        at.setGradientBackground(colorOne: darkPurple , colorTwo: purple )
    }
    
    
    //Setting gradient
    func viewGradient(at:UIView){
        guard let orange = HexColor(K.colors.orange) else {return}
        at.setGradientBackground(colorOne: orange , colorTwo: .orange)
    }
    
   
    
    //Create action sheet
    func createActionsheet(title: String, message: String) -> UIAlertController {
        let actionSheetController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        return actionSheetController
    }
    
    //Setting a Bearer
    func setBearerToken(_ token: String) -> String{
        let bearer = "Bearer\(" "+token)"
        return bearer
    }
    
    //Updating token
    func callOauth(){
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.refreshToken)
        let tokenUser = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.refreshToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : tokenUser
        let params: Parameters =
            ["refresh_token": setToken,
             "grant_type": "refresh_token",
             "scope":"users"]
        
        UserManager().getOauthToken(params: params) { (response) in
            print(response?.accessToken)
            
            guard let refresh_token = response?.refreshToken else {return}
            guard let access_token = response?.accessToken else {return}
            
            Singleton.shared.setrefreshToken(access_token, refresh_token)
            
        }
    }
    
    //Check panoramic size on Images
    func checkPanorama(image:UIImage) -> Bool{
        let smallest = min(image.size.width, image.size.height)
        let largest = max(image.size.width, image.size.height)
        let ratio = largest/smallest
        let result = ratio >= (CGFloat(2/1)) || (ratio >= CGFloat(4/1)) || (ratio >= CGFloat(10/1))  ?  true : false
        return result
    }
    
   
    //Setting lottie fucntions
    func playLottie(lottie: Lotties, action:LottieAction, animationView: LOTAnimationView, at: UIViewController){
        
        
        animationView.contentMode = .scaleAspectFill
        animationView.clipsToBounds = true
        at.view.addSubview(animationView)
       
        animationView.frame = CGRect(x: at.view.x, y: at.view.y, width: 500, height: 500)
        animationView.center = at.view.center
       print(action)
        
        switch action {
        case .play:
            animationView.play()
            animationView.loopAnimation = true
            
        case .stop:
          
            animationView.stop()
            animationView.isHidden = true
            
        default:
            print("Error with lottie")
        }
    }
    
    //Local Notifications asking
    func askForNotifications(){
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {
            (success, error) in
            
            guard success else { return }
            
            DispatchQueue.main.sync {
                print("Success")
                
            }
        }
    }
    
    //Creta notification
    func buildNotification(body: String, title: String, id: String){
        let content = UNMutableNotificationContent()
        content.body =  body
        content.title = title
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: nil)
        
        UNUserNotificationCenter.current().add(request) {
            error in
            print("Error")
        }
    }
    
    //Cents to dollar
    func formatAmount(_ amount: Int) -> String? {
        
        let cents: Int = amount % 100
        let dollars: Int = (amount - cents) / 100
        var camount: String
        if cents <= 9 {
            camount = "0\(cents)"
        } else {
            camount = "\(cents)"
        }
        let t = "$\(dollars).\(camount)"
        return t
    }
    func formatAmountValue(_ amount: Int) -> String? {
        
        let cents: Int = amount % 100
        let dollars: Int = (amount - cents) / 100
        var camount: String
        if cents <= 9 {
            camount = "0\(cents)"
        } else {
            camount = "\(cents)"
        }
        let t = "\(dollars).\(camount)"
        return t
    }
   
    //Calculate assets
    func countAssets(count: [Asset])-> String{
    
    let count = count.count
        var value = String()
        switch count{
        case 1:
        value =  "1/5"
        case 2:
        value = "2/5"
        case 3:
        value = "3/5"
        case 4:
        value = "4/5"
        case 5:
        value = "5/5"
        default:
        value = "N/A"
        
        }
        return value
    }
    
    func countAssetTemp(count: Int)-> Int{
        
        let count = count
        var value = Int()
        switch count{
        case 1:
            value =  5 - 1
        case 2:
            value = 5 - 2
        case 3:
            value = 5 - 3
        case 4:
            value = 5 - 4
        case 5:
            value =  5 - 5
        default:
            value = 1
            
        }
        return value
    }
   
    //Return an icon by categoriename
    func returnIconByCategory(Category name:String)-> UIImage{
        var imageTemp = UIImage()
        switch name {
        case "ig_amor":
            imageTemp = #imageLiteral(resourceName: "ico-amor")
        case "ig_marciales":
            imageTemp = #imageLiteral(resourceName: "ico-bienestar")
        case "ig_astrologia":
            imageTemp = #imageLiteral(resourceName: "ico-astrología")
        case "ig_aves":
            imageTemp = #imageLiteral(resourceName: "ico-aves")
        case "ig_bici":
            imageTemp = #imageLiteral(resourceName: "ico-bicicleta")
        case "ig_campamento":
            imageTemp = #imageLiteral(resourceName: "ico-campamento")
        case "ig_campeonato":
            imageTemp = #imageLiteral(resourceName: "ico-Torneos")
        case "ig_ciudad":
            imageTemp = #imageLiteral(resourceName: "ico-ciudad")
        case "ig_comida":
            imageTemp = #imageLiteral(resourceName: "ico-restaurantes")
        case "ig_correr":
            imageTemp = #imageLiteral(resourceName: "ico-correr")
        case "ig_escalar":
            imageTemp = #imageLiteral(resourceName: "ico-extremos")
        case "ig_fiesta":
            imageTemp = #imageLiteral(resourceName: "ico-fiesta")
        case "ig_musica":
            imageTemp = #imageLiteral(resourceName: "ico-musica")
        case "ig_nadar":
            imageTemp = #imageLiteral(resourceName: "ico-natación")
        case "ig_navegar":
            imageTemp = #imageLiteral(resourceName: "ico-navegación")
        case "ig_playa":
            imageTemp = #imageLiteral(resourceName: "ico-playa")
        case "ig_rafting":
            imageTemp = #imageLiteral(resourceName: "ico-transporte")
        case "ig_salud":
            imageTemp = #imageLiteral(resourceName: "ico-bienestar")
        case "ig_trasporte":
            imageTemp = #imageLiteral(resourceName: "ico-transporte")
        case "ig_volcan":
            imageTemp = #imageLiteral(resourceName: "ico-campamento")
            
        default:
            imageTemp = #imageLiteral(resourceName: "tugologo")
        }
        return imageTemp
    }
    
    
    //Change color on imageview
    func changeImageColor(image:UIImage, color:UIColor, at: UIImageView){
        let tintImage = image.withRenderingMode(.alwaysTemplate)
        at.tintColor = color
        at.image = tintImage
    }
    
    
    
    
    // MARK. -XIB
    
    // Register cell at a table view
    func registerCell(at tableView: UITableView, named: String, withIdentifier: String? = nil) {
        let cellNib = UINib(nibName: named, bundle: nil)
        tableView.register(cellNib, forCellReuseIdentifier: withIdentifier ?? named)
    }
    
    // Register cell at a collection view
    func registerCellCollection(at collectionView: UICollectionView, named: String, withIdentifier: String? = nil) {
        let cellNib = UINib(nibName: named, bundle: nil)
        collectionView.register(cellNib, forCellWithReuseIdentifier: withIdentifier ?? named)
    }
    
}
