//
//  StarNewExperienceHostController.swift
//  Tugo
//
//  Created by Alex on 8/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit

class StarNewExperienceHostController: UIViewController {

    // MARK: - Let-Var
    var imagesArray = [UIImage]()
    var maxReservation = 100
    var countPeople = 1
    var experienceModel = [ExperienceHostModel]()
    
    // MARK: - Outlets
    @IBOutlet weak var nameExperienceTextfield: UITextField!
    @IBOutlet weak var descriptionTextfield: UITextField!
    @IBOutlet weak var includeTextfield: UITextField!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var countLabel: UILabel!
    //Outleets to hide
    @IBOutlet weak var maximunLabel: UILabel!
    @IBOutlet weak var minuButton: UIButton!
    @IBOutlet weak var maxButton: UIButton!
    
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // setting up general actions/delegates/Core
        setUpActions()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
            
            if segue.identifier ==  K.segues.ExperiencesHost.startInfoToSetSchedules{
                let detailController = segue.destination as! SetExperienceDateController
                
                detailController.maxReservation = maxReservation
                detailController.imagesArray = imagesArray
                detailController.experienceModel = weak.experienceModel
                
            }
        
       
        
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Switch off
        `switch`.layer.cornerRadius = 16.0
    }
    
    func setUpActions(){
        
    }
    
    private func gettingData(){
        
    }
    
    @IBAction func nextStepAction(_ sender: UIButton) {
        guard let name = nameExperienceTextfield.text, !name.isEmpty else{return}
        guard let description = descriptionTextfield.text, !description.isEmpty else{return}
        guard let include = includeTextfield.text, !include.isEmpty else{return}
        
        experienceModel.append(ExperienceHostModel(name:name,description: description,include: include))
        self.performSegue(withIdentifier: K.segues.ExperiencesHost.startInfoToSetSchedules, sender: self)
        
    }
    
    @IBAction func switchState(_ sender: UISwitch) {
        if sender.isOn{
            outleetsToHide(false)
        }else{
            maxReservation = 100
            outleetsToHide(true)
        }
    }
    
    @IBAction func minusAction(_ sender: UIButton) {
        if countPeople > 1{
            self.countPeople -= 1
            self.countLabel.text = self.countPeople.description
             maxReservation = countPeople
        }
    }
    
    @IBAction func plusAction(_ sender: UIButton) {
        countPeople += 1
        countLabel.text = countPeople.description
        maxReservation = countPeople
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    func outleetsToHide(_ hidden: Bool){
        maximunLabel.isHidden = hidden
        minuButton.isHidden = hidden
        maxButton.isHidden = hidden
        countLabel.isHidden = hidden
        
    }
    
    // MARK: - Objective C
    
    

}
