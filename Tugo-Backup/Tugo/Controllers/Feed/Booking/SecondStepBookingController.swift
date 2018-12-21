//
//  SecondStepBookingController.swift
//  Tugo
//
//  Created by Alex on 28/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import TagListView
import HexColors
import XLActionController
import Alamofire
import SDWebImage

class SecondStepBookingController: UIViewController {
    
    // MARK: - Let-Var
    var selectedExperience:SearchElement?
    var booking = [Booking]()
    var cards = Card()
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    let instanceHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.signInhost)
    let actionSheet = SpotifyActionController()
    var cardStripeSource: String?
    let locale = Locale(identifier: "es_GT")
    var isLoaded = false
    var friendlyCard: String?
    
    // MARK: - Outlets
    @IBOutlet weak var payButton: UIButton!
    @IBOutlet weak var methodButton: UIButton!
    @IBOutlet weak var experienceImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var hostnameLabel: UILabel!
    @IBOutlet weak var tagListView: TagListView!
    @IBOutlet weak var hourLabel: UILabel!
    @IBOutlet weak var ticketsLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    @IBOutlet weak var monthLabel: UILabel!
    
    
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
        gettingData()
        settingData()
        
        if let friendlyCard = friendlyCard, !friendlyCard.isEmpty{
            methodButton.setTitle(friendlyCard, for: .normal)
        }
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
 
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        
    }
    
    func setUpActions(){
        //Taglist datasource sample
        guard let orange = HexColor(K.colors.orange) else {return}
        tagListView.tagBackgroundColor = orange
        tagListView.cornerRadius = 2
        tagListView.clipsToBounds = true
        
        
    }
    
    private func gettingData(){
        cards.removeAll()
        UserManager().getCards(header: header) { (cards) in
            guard let cards = cards else{
                self.isLoaded = true
                return
            }
            self.cards = cards
            self.isLoaded = true
        }
    }
    
    private func settingData(){
        
        guard let experiences = selectedExperience else{return}
        hostnameLabel.text = "@\(experiences.hostUsername)"
        guard let price = Core.shared.formatAmount(experiences.priceInCents) else{return}
        priceLabel.text = "\(price) por persona"
        nameLabel.text = experiences.name
        guard let asset = experiences.assets.first else{return}
        experienceImage.sd_setImage(with: URL(string: asset.url), placeholderImage: #imageLiteral(resourceName: "tugologo"))
        
        guard let book = booking.first else{return}
        totalLabel.text = book.amount.description
        ticketsLabel.text = book.peopleCount.description
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy"
        guard let month = transformStringDate(book.selectedSchedule.startDate, fromDateFormat: "yyyy-MM-dd", toDateFormat: "MMM") else{return}
        monthLabel.text = month
        guard let day = transformStringDate(book.selectedSchedule.startDate, fromDateFormat: "yyyy-MM-dd", toDateFormat: "dd") else{return}
        tagListView.addTags([day])
        hourLabel.text = "\(book.selectedSchedule.startHour) "
    }
    
    func transformStringDate(_ dateString: String,
                             fromDateFormat: String,
                             toDateFormat: String) -> String? {
        
        let initalFormatter = DateFormatter()
        initalFormatter.dateFormat = fromDateFormat
        
        guard let initialDate = initalFormatter.date(from: dateString) else {
            print ("Error in dateString or in fromDateFormat")
            return nil
        }
        
        let resultFormatter = DateFormatter()
        resultFormatter.dateFormat = toDateFormat
        resultFormatter.locale = locale
        return resultFormatter.string(from: initialDate)
    }

    
    @IBAction func showPaymentMethods(_ sender: UIButton) {
        cardStripeSource = nil
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        if cards.count > 0{
            
            DispatchQueue.main.async {
                let actionSheet = TwitterActionController()
                actionSheet.headerData = "Seleccionar método de pago:"
                for i in weak.cards{
                    actionSheet.addAction(Action(ActionData(title: i.friendlyCard,image: #imageLiteral(resourceName: "iconcreditcard")), style: .default, handler: { action in
                        weak.friendlyCard = i.friendlyCard
                        weak.methodButton.setTitle(weak.friendlyCard, for: .normal)
                        weak.cardStripeSource = i.stripeSource
                    }))
                }
                
                actionSheet.addAction(Action(ActionData(title: "Agregar método de pago",image: #imageLiteral(resourceName: "iconcreditcard")), style: .default, handler: { action in
                   weak.performSegue(withIdentifier: K.segues.FeedStoryBoard.secondStepToAddPayment, sender: nil)
                }))
                
                // present actionSheet like any other view controller
                weak.present(actionSheet, animated: true, completion: nil)
            }
        }else if cards.count == 0 && isLoaded{
            DispatchQueue.main.async {
                let actionSheet = TwitterActionController()
                actionSheet.headerData = "Metodos de pago:"
                
                
                actionSheet.addAction(Action(ActionData(title: "Agregar método de pago",image: #imageLiteral(resourceName: "iconcreditcard")), style: .default, handler: { action in
                    weak.performSegue(withIdentifier: K.segues.FeedStoryBoard.secondStepToAddPayment, sender: nil)
                }))
                
                
                // present actionSheet like any other view controller
                weak.present(actionSheet, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func bookAction(_ sender: UIButton) {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        guard let stripeSource = cardStripeSource else{
            Core.shared.alert(message: "Debes seleccionar un metodo de pago", title: "Error", at: self)
            return
        }

        guard let book = booking.first else{return}
        let tickets = book.peopleCount
        let schedule_id = book.selectedSchedule.id
        let total_amount = book.amountInCent
        
        let params:Parameters = ["tickets":tickets,
                                                 "schedule_id":schedule_id,
                                                  "type_payment":"card",
                                                   "total_amount":total_amount,
                                                   "source_id":stripeSource,
                                                   "account_charge":0,
                                                   "card_charge":total_amount]
        BooksManager().testNewBooking(header: header, params: params) {
            response in
            guard let book = response else{return}
            
            DispatchQueue.main.async {
             
                let storyBoardName = !weak.instanceHost.isEmpty ? K.storyboards.menuHost : K.storyboards.menu
                let storyBoard: UIStoryboard = UIStoryboard(name: storyBoardName, bundle: nil)
                
                
                if !weak.instanceHost.isEmpty {
                    let newViewController = storyBoard.instantiateViewController(withIdentifier:  K.Instancecontrollers.Main.Host.mainTabBarHostController) as! MainTabBarHostController
                    newViewController.fromSecondStep = true
                    weak.present(newViewController, animated: true, completion: nil)
                    
                }else{
                    let newViewController = storyBoard.instantiateViewController(withIdentifier:  K.Instancecontrollers.Main.mainTabBarController) as! MainTabBarController
                    newViewController.fromSecondStep = true
                    
                    weak.present(newViewController, animated: true, completion: nil)
                }
                
                //weak.view.window?.rootViewController?.dismiss(animated: true)
            }
            
        }
    }
    
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Objective C
    
}
