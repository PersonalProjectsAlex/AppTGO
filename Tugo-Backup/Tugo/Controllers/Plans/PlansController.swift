//
//  PlansController.swift
//  Tugo
//
//  Created by Alex on 28/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import XLPagerTabStrip
import Alamofire

class PlansController: UIViewController{
    
    // MARK: - Let-Var
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    
    var bookings = Bookings()
    var selectedBook: Reservation?
    
    
    // MARK: - Outlets
    @IBOutlet weak var plansTableView: UITableView!
    @IBOutlet weak var placeholderView: UIView!
    
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
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.Plans.plansToDetail {
            let detailController = segue.destination as! PlansDetailController
            detailController.selectedBook = selectedBook
        }
    }
    
    // MARK: - SetUps / Funcs
    
    func setUpUI(){
        
    }
    
    func setUpActions(){
        //Tableview Delegate
        plansTableView.delegate = self
        plansTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: plansTableView, named: K.cells.table.plansTableCell)
        
    }
    
    private func gettingData(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        BooksManager().getBookings(header: header) {
            response in
            guard let books = response else{
                weak.placeholderView.isHidden = false
                return
            }
            weak.bookings = books
            if weak.bookings.count > 0{
                weak.placeholderView.isHidden = true
                weak.plansTableView.reloadData()
            }else{
                weak.placeholderView.isHidden = false
            }
        }
    }
    
    @IBAction func exploreAction(_ sender: UIButton) {
        self.tabBarController?.selectedIndex = 0
    }
    
    
    
    // MARK: - Objective C

}
