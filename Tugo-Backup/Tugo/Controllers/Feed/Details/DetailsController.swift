//
//  DetailsController.swift
//  Tugo
//
//  Created by Alex on 21/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import ImageSlideshow
import Alamofire
import Kingfisher
import HexColors
import MapKit
import Hero
import SDWebImage
import SendBirdSDK
import Cosmos
import PopupDialog
import Spring


class DetailsController: UIViewController,
    UIScrollViewDelegate, MKMapViewDelegate {
    // MARK: - Let-Var
    var images = [SDWebImageSource]()
    var imagePlaceHolder = [ImageSource]()
    var selectedExperience:SearchElement?
    var selectedGroupChannel:SBDGroupChannel?
    var animateState = true
    
    // MARK: - Outlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var slideShow: ImageSlideshow!
    @IBOutlet weak var maskViewBlack: UIView!
    @IBOutlet weak var maskViewWhite: UIView!
    @IBOutlet weak var bottomView: UIView!
    @IBOutlet weak var bookButton: UIButton!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var commentsTableView: UITableView!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var mapKit: MKMapView!
    @IBOutlet weak var closeButton: UIButton!
    
    
    @IBOutlet weak var experienceNameLabel: UILabel!
    @IBOutlet weak var aboutMeHostLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var hostNameLabel: UILabel!
    @IBOutlet weak var raitingView: CosmosView!
    @IBOutlet weak var includeLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var datesTableView: UITableView!
    @IBOutlet weak var availableLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var newMessageButton: UIButton!
    @IBOutlet weak var hostImageView: UIImageView!
    @IBOutlet weak var bookSpringButton: SpringButton!
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        // setting up general actions/delegates/Core
        
        weak.setUpActions()
        
        // setting up UI elements to be used through the code
        
        weak.setUpUI()
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.FeedStoryBoard.detailToFirsStepController {
            let detailController = segue.destination as! FirstStepBookingController
           detailController.selectedExperience = selectedExperience
        }
        
        if segue.identifier == K.segues.FeedStoryBoard.detailToChatController {
            let detailController = segue.destination as! ChatDetailController
            detailController.selectedGroupChannel = selectedGroupChannel
        }
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
     
        //Dots size for controlpage
        pageControl.transform = CGAffineTransform(scaleX: 1.5   , y: 1.5);
        
        //shareButton Image
        shareButton.imageView?.contentMode = .scaleAspectFit
        newMessageButton.imageView?.contentMode = .scaleAspectFit
        
        //Separator color on tableview
        datesTableView.separatorColor = .clear
        
        //BookButton
        bookButton.layer.borderColor = UIColor.white.cgColor
        bookButton.layer.borderWidth = 0.5
        bookButton.layer.cornerRadius = 4
        bookSpringButton.clipsToBounds = true
        
        
    }
    
    func setUpActions(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        //Setting slider features
        
        weak.setSlider()
        
        //setting data onto screen
        weak.setData()
        
        //Delegating Scrollview
        scrollView.delegate = self
        scrollView.layer.shouldRasterize = true

        //Tableview Delegate
        commentsTableView.delegate = self
        commentsTableView.dataSource = self
        datesTableView.delegate = self
        datesTableView.dataSource = self
        //Set Cell Identifier
        Core.shared.registerCell(at: commentsTableView, named: K.cells.table.commentsTableCell)
        Core.shared.registerCell(at: datesTableView, named: K.cells.complementaries.tripDetailDateTableCell)
        
        //Mapkit
        mapKit.delegate = self
        Core.shared.mapkitFeatures(mapKit: mapKit)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTapFrom(recognizer:)))
        mapKit.addGestureRecognizer(tapGestureRecognizer)
        
        
        
    }
    
    private func gettingData(){}
    
    @IBAction func shareAction(_ sender: UIButton) {
        guard let experiences = selectedExperience else{return}
        let urlString = "http://ifconfig.me"
        //string to url
        let url = URL(string: urlString)
       // let message = "Hola, te invito a descargar la app Tugo y buscar la experiencia: \(experiences.name)\(url!)"
        let multiLineString = """
                      Hola, te invito a descargar la app Tugo y buscar la experiencia:
                      *\(experiences.name.capitalizingFirstLetter())*
                      Appstore: \(url!)
                      """
        Core.shared.showSharedController(at: self, text: multiLineString, image: #imageLiteral(resourceName: "tugologo"))
    }
    
    
    
    @IBAction func closeController(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func gotoChatAction(_ sender: UIButton) {
       registerSendbird()
    }
    
    //Setting data onto screen
   private  func setData(){
    
    weak var weakSelf = self
    guard let weak = weakSelf else{return}
    
    guard let experiences = selectedExperience else{return}
    hostNameLabel.text = "@\(experiences.hostUsername.capitalizingFirstLetter())"
    experienceNameLabel.text = experiences.name.capitalizingFirstLetter()
    if let hostAboutMe = experiences.hostAboutMe?.capitalizingFirstLetter(){
        aboutMeHostLabel.text = hostAboutMe
    }else{
         aboutMeHostLabel.text = " "
    }
    if let timeAgo =  experiences.timeAgo?.capitalizingFirstLetter(){
        timeAgoLabel.text = timeAgo
    }else{
        timeAgoLabel.text = " "
    }
    
    descriptionLabel.text = experiences.description
    
    if let included = experiences.incluye?.capitalizingFirstLetter(){
        includeLabel.text = included
    }else{
        includeLabel.text = " "
    }
    
    raitingView.rating = experiences.avgStars
    
    let priceDollar = Core.shared.formatAmount(experiences.priceInCents)
    if let price = priceDollar{
        weak.priceLabel.text = "\(price) por persona"
    }else{
        weak.priceLabel.text = "N/A"
    }
    
    addPinMapkit(experiences: experiences)
    print(experiences.totalAvailableReservations.description)
    availableLabel.text = experiences.totalAvailableReservations.description
    
    if let duration = experiences.duration{
        durationLabel.text = !duration.isEmpty ? "\(duration)" : "N/A"
    }else{
        durationLabel.text = "N/A"
    }
    
    hostImageView.sd_setImage(with: URL(string: experiences.hostAvatar), placeholderImage: #imageLiteral(resourceName: "tugologo"))
    
    
    }
    
    
    func addPinMapkit(experiences: SearchElement){

        let annotation = MKPointAnnotation()
        guard let lat = experiences.lat.toDouble() else{return}
        guard let long = experiences.long.toDouble() else{return}
        let center = CLLocationCoordinate2D(latitude: lat, longitude: long)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02))
        annotation.coordinate = center
        mapKit.region = region
        mapKit.addAnnotation(annotation)
    }
    
    //Setting slider features
    private func setSlider(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        DispatchQueue.main.async(execute: {
            
            //General features
            Core.shared.imagesliderFeaturesCustom(slideShow: weak.slideShow)
            
            //PageControl features
            weak.pageControl.currentPageIndicatorTintColor = .white
            weak.pageControl.pageIndicatorTintColor = .lightGray
            weak.slideShow.pageIndicator = weak.pageControl
            
            //Datasource
            guard let assets = weak.selectedExperience?.assets, assets.count > 0 else {
                weak.imagePlaceHolder = [ImageSource(image: UIImage(named: "guatemala")!)]
                weak.slideShow.setImageInputs(weak.imagePlaceHolder)
                return
            }
            
            for i in assets{
                guard let url = URL(string: i.url) else{return}
                weak.images.append(SDWebImageSource(url: url, placeholder: #imageLiteral(resourceName: "tugologo") ))
                
                
            }
            
            weak.slideShow.currentPageChanged = { page in
                let urlString = assets[page].url
                guard let url = URL(string: urlString) else{return}
                DispatchQueue.main.async {
                    KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image, error, cacheType, imageURL in
                        guard let image = image else{return}
                        
                        
                    })
                }
            }
            
           
           weak.slideShow.setImageInputs(weak.images)
            let min = CGFloat(-230)
            let max = CGFloat(230)
            
            let xMotion = UIInterpolatingMotionEffect(keyPath: "layer.transform.translation.x", type: .tiltAlongHorizontalAxis)
            xMotion.minimumRelativeValue = min
            xMotion.maximumRelativeValue = max
            let motionEffectGroup = UIMotionEffectGroup()
            motionEffectGroup.motionEffects = [xMotion]
        
            
            DispatchQueue.main.async {
                weak.slideShow.addMotionEffect(motionEffectGroup)
            }
            
            //Tap on slider
            let recognizer = UITapGestureRecognizer(target: self, action: #selector(weak.didTap))
            weak.slideShow.addGestureRecognizer(recognizer)
        })
    }
    
    //Going to booking steps
    @IBAction func goingToBookingAction(_ sender: UIButton) {
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        guard let experiences = selectedExperience else{return}
        if experiences.totalAvailableReservations > 0{
            weak.performSegue(withIdentifier: K.segues.FeedStoryBoard.detailToFirsStepController, sender: weak)
        }else{
            weak.showPopup()
        }
        
    }
    
    
    //Changing color on status bar
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
         let lastContentOffset: CGFloat = 0
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        DispatchQueue.main.async {
            if (lastContentOffset < scrollView.contentOffset.y) {
                //Animating transitions
                
                    DispatchQueue.main.async {
                        if weak.animateState{
                            weak.bookSpringButton.animation = "fadeIn"
                            weak.bookSpringButton.animate()
                            weak.bookSpringButton.duration = 1.5
                            weak.animateState = false
                        }
                    }
                
                
                    Core.shared.transitionatbottom(bottomView: weak.bottomView, bookButton: weak.bookButton)
                
            }
        }
        
    }
    
    //Popup with TimePicker
    func showPopup(){
        
        let popup = AlertNoAvailable(nibName: K.NIB.alertNoAvailable, bundle: nil)
        DispatchQueue.main.async {
            // Create the dialog
            let popup = PopupDialog(viewController: popup, buttonAlignment: .horizontal, transitionStyle: .bounceUp, tapGestureDismissal: true)
            
           // let buttonOne = CancelButton(title: "Cancelar", height: 60) {}
            
            let buttonTwo = DefaultButton(title: "Aceptar", height: 60) {}
            
            popup.addButtons([buttonTwo])
            // Present dialog
            self.present(popup, animated: true, completion: nil)
        }
        
    }
    
    
    // MARK: - Objective C
    @objc func didTap() {
        let fullScreenController = slideShow.presentFullScreenController(from: self)
        fullScreenController.slideshow.activityIndicator = DefaultActivityIndicator(style: .white, color: nil)
    }
    
    @objc func handleTapFrom(recognizer : UITapGestureRecognizer){
      
        guard let experiences = selectedExperience else{return}
        guard let lat = experiences.lat.toDouble() else{return}
        guard let long = experiences.long.toDouble() else{return}
        
        let actionSheetController: UIAlertController = UIAlertController(title: K.titles.mapTitleActionSheet, message: K.titles.mapMessageActionSheet, preferredStyle: .actionSheet)
        
        //Create and add the Cancel action
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancelar", style: .cancel) { action -> Void in}
        
        actionSheetController.addAction(cancelAction)
        
        //Create and add first option action
        let openWaze: UIAlertAction = UIAlertAction(title: K.titles.waze, style: .default) { action -> Void in
            Core.shared.openWaze(latitude: lat, longitude: long)
            
        }
        actionSheetController.addAction(openWaze)
        
        //Create and add a second option action
        let openGoogleMap: UIAlertAction = UIAlertAction(title: K.titles.googleMaps, style: .default) { action -> Void in
            Core.shared.openGoogleMaps()
        }
        actionSheetController.addAction(openGoogleMap)
        
        //Present the AlertController
        self.present(actionSheetController, animated: true, completion: nil)
    }
    
}
