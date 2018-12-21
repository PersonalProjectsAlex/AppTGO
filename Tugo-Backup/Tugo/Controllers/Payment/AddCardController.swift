//
//  AddCardController.swift
//  Tugo
//
//  Created by Alex on 6/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Stripe
import IQKeyboardManagerSwift
import HexColors
import Alamofire

class AddCardController: UIViewController {
    // MARK: - Let-Var
    let paymentConfig = STPPaymentConfiguration.init()
    let theme = STPTheme()
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }

    
    //Setting and converting time to refresh a token
    open var time: Double{
        let time = 604800
        return time.msToSeconds.rounded()
    }
    
    // MARK: - Outlets
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up general actions/delegates/Core
        setUpActions()

        // setting up UI elements to be used through the code
        setUpUI()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Setting theme colors
        theme.primaryBackgroundColor = .white
        theme.accentColor = HexColor(K.colors.orange)
        theme.secondaryForegroundColor = HexColor(K.colors.orange)
        
    }
    
    func setUpActions(){
        
        //removin iQ
        IQKeyboardManager.sharedManager().enable = false
        
        //Setting Payment
        paymentConfig.requiredBillingAddressFields = STPBillingAddressFields.none
        paymentConfig.publishableKey = K.stripePublishableKey
        
        // Setting STPAddCardViewController
        let addCardViewController = STPAddCardViewController.init(configuration: paymentConfig, theme: theme)
        addCardViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: addCardViewController)
        addCardViewController.title = K.titles.addCardTitle
        
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    private func gettingData(){}
    
    private func addNewCard(sourceID: String){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        let params: Parameters = ["stripe_source": sourceID]
        
        UserManager().registerNewCard(header: header, params: params) { (response) in
            guard let response = response else{return}
            if let presenter = weak.presentingViewController as? SecondStepBookingController {
                presenter.cardStripeSource = response.stripeSource
                presenter.friendlyCard = response.friendlyCard
            }
            weak.closeModal()
            
        }
    }
    
    
    func closeModal(){
        navigationController?.dismiss(animated: true) {}
        dismiss(animated: true, completion: nil)
    }
    // MARK: - Objective C
    
}

extension AddCardController: STPAddCardViewControllerDelegate {
    
    func addCardViewControllerDidCancel(_ addCardViewController: STPAddCardViewController) {
       closeModal()
    }
    
    
    func addCardViewController(_ addCardViewController: STPAddCardViewController,
                               didCreateToken token: STPToken,
                               completion: @escaping STPErrorBlock) {
            self.addNewCard(sourceID: token.tokenId)
    }
    
    
}
