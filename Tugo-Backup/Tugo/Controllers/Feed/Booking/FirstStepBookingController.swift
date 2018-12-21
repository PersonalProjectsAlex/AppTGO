//
//  FirstStepBookingController.swift
//  Tugo
//
//  Created by Alex on 28/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class FirstStepBookingController: UIViewController {
    // MARK: - Let-Var
    var countPeople = 1
    var selectedExperience:SearchElement?
    var selectedSchedules = [Schedule]()
    var selectedSchedulesHours = [Schedule]()
    var selectedIndexPath: IndexPath?
    var maxPeople = 0
    var saveScehdule:Schedule?
    var booking = [Booking]()
    
    var selectedCell = Int()
    // MARK: - Outlets
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var scheduleTableView: UITableView!
    @IBOutlet weak var minusButton: UIButton!
    @IBOutlet weak var plusButton: UIButton!
    
    @IBOutlet weak var hoursCollectionView: UICollectionView!
    
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
        gettingHours()
    }
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.FeedStoryBoard.firstStepToSecondStep {
            let detailController = segue.destination as! SecondStepBookingController
            detailController.selectedExperience = selectedExperience
            detailController.booking = booking
        }
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        
        //Separator color on tableview
        scheduleTableView.separatorColor = .clear
    }
    
    func setUpActions(){
        //Tableview Delegate
        scheduleTableView.delegate = self
        scheduleTableView.dataSource = self
        scheduleTableView.allowsSelection = true
        
        //CollectionView Delegate
        hoursCollectionView.delegate = self
        hoursCollectionView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: scheduleTableView, named: K.cells.table.dateTableCell)
        Core.shared.registerCellCollection(at: hoursCollectionView, named: K.cells.collection.hourCollectionCell)
        
        if maxPeople > 0{
            enableButton()
        }else{
            disableButtons()
        }
        
    }

    private func gettingData(){
        guard let schedules = selectedExperience?.schedules else{return}
        selectedSchedules = schedules
    }

    func gettingHours(){
        guard let schedules = selectedExperience?.schedules else{return}
        selectedSchedulesHours = schedules
    }
    
    func enableButton(){
        minusButton.isUserInteractionEnabled = true
        plusButton.isUserInteractionEnabled = true
    }
    
    
    func disableButtons(){
        minusButton.isUserInteractionEnabled = false
        plusButton.isUserInteractionEnabled = false
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        if countPeople > 1{
            self.countPeople -= 1
            self.countLabel.text = self.countPeople.description
        }
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        if maxPeople == 0{
            Core.shared.alert(message: "No hay cupos disponibles", title: "Algo sucedio:", at: self)
        }else{
            countPeople += 1
            
            if countPeople <= maxPeople{
                self.countLabel.text = self.countPeople.description
            }else{
                countPeople = maxPeople
            }
        }
      
    }
    
    @IBAction func goNextController(_ sender: UIButton) {
        booking.removeAll()
        guard let schedule = saveScehdule else{return}
        guard let manyPeople = Int(countLabel.text!) else{return}
        guard let manyPeopleFormatted = Double(exactly: manyPeople) else{return}
        guard let experience = selectedExperience else{return}
        let price = Core.shared.formatAmountValue(experience.priceInCents)
        guard let priceFormatted = price?.toDouble() else{return}
        let totalAmount = (priceFormatted * manyPeopleFormatted)
        let amountInCent = experience.priceInCents * manyPeople
        
        
        booking.append(Booking(amount: totalAmount, amountInCent: amountInCent, peopleCount: manyPeople, selectedSchedule: schedule))
        if booking.count > 0{
            self.performSegue(withIdentifier: K.segues.FeedStoryBoard.firstStepToSecondStep, sender: self)
        }
    }
    
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Objective C
}
