//
//  BasicInfoEditController.swift
//  Tugo
//
//  Created by Alex on 12/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import DropDown
import SkyFloatingLabelTextField
import Alamofire

class BasicInfoEditController: UIViewController {

    // MARK: - Let-Var
    let genderDropDown = DropDown()
    let countriesDropDown = DropDown()
    let datePickerView: UIDatePicker = UIDatePicker()
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    let locale = Locale(identifier: "es_GT")
    var country:String?
    var gender:String?
    
    
    // MARK: - Outlets
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var genderSelectedLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    @IBOutlet weak var countrySelectedLabel: UILabel!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var userNameLabel: UITextField!
    @IBOutlet weak var genderView: UIView!
    @IBOutlet weak var countryView: UIView!
    
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
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {}
    
    // MARK: - SetUps / Funcs
    func setUpUI(){}
    
    func setUpActions(){
        //Setting dropdowns
        //Gender
        genderDropDown.dataSource = ["Hombre", "Mujer"]
        genderDropDown.anchorView = genderView
        
        //Countries
        countriesDropDown.dataSource = ["El Salvador", "Guatemala"]
        countriesDropDown.anchorView = countryView
       
        //Delegating dateTextfield
        setUpBirthday()
        
        //Adding tap on our 'Dropdown'
        let gestureSelectGender = UITapGestureRecognizer(target: self, action:  #selector (selectGender(sender:)))
        genderView.addGestureRecognizer(gestureSelectGender)
        
        let gestureSelectCountry = UITapGestureRecognizer(target: self, action:  #selector (selectCountry(sender:)))
        countryView.addGestureRecognizer(gestureSelectCountry)
        
    }
    
    private func gettingData(){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        UserManager().getUserInfo(header: header) {
            userinfo in
            guard let userinfo = userinfo else{return}
            weak.userNameLabel.text = userinfo.username
            if let gender = userinfo.gender, !gender.isEmpty{
                weak.genderSelectedLabel.text = gender
                weak.genderSelectedLabel.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
            }else{
                weak.genderSelectedLabel.text = "Género"
            }
            
            if let country = userinfo.country, !country.isEmpty{
                weak.countrySelectedLabel.text = country
                weak.countrySelectedLabel.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
            }else{
                weak.countrySelectedLabel.text = "Selecciona tu país de origen"
                
            }
            
            if let birthdate = userinfo.birthdate{
                weak.dateTextField.text = birthdate
                
            }else{
                weak.dateTextField.text = "Fecha de nacimiento "
            }
            
        }
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func updateInfoAction(_ sender: UIButton) {
        
        let userName = unwrapValue(value: userNameLabel.text)
        let birthDate = unwrapValue(value: dateTextField.text)
        let country = unwrapValue(value: self.country)
        let gender = unwrapValue(value: self.gender )
        
        
        if !userName.isEmpty && !birthDate.isEmpty && !country.isEmpty && !gender.isEmpty{
            let params: Parameters =  ["username" : userName, "birthdate": birthDate, "country" : country, "gender" : gender]
            updateInfo(params: params)
            
        }else if !userName.isEmpty && !birthDate.isEmpty{
            let params: Parameters =  ["username" : userName, "birthdate": birthDate]
            updateInfo(params: params)
            
        }else if !birthDate.isEmpty && !country.isEmpty{
            
            let params: Parameters =  ["country" : country, "birthdate": birthDate]
            updateInfo(params: params)
        
        }else if !birthDate.isEmpty && !gender.isEmpty{
            
            let params: Parameters =  ["gender" : gender, "birthdate": birthDate]
            updateInfo(params: params)
            
        }else if !gender.isEmpty && !country.isEmpty{
            
            let params: Parameters =  ["gender" : gender, "country": country]
            updateInfo(params: params)
            
        }
        
        

    }
    
    func unwrapValue(value: String?) ->String{
        var unwrapped = String()
        if let value = value  {
            unwrapped = value
        }
        return unwrapped
    }
    
    private func updateInfo(params: Parameters){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        
        UserManager().updateUserInfo(header: header, params: params) {
            response in
            guard let updated = response else{return}
            Core.shared.alert(message: "Los datos fuerón actualizados correctamente", title: "", at: weak)
        }
    }
    
    private func setUpBirthday(){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        datePickerView.locale = locale
        datePickerView.datePickerMode = UIDatePickerMode.date
        dateTextField.inputView = datePickerView
        datePickerView.setYearValidation(year: 18)
        datePickerView.addTarget(weak, action: #selector(weak.datePickerValueChanged), for: UIControlEvents.valueChanged)
        
        
        
    }
    
    // MARK: - Objective C
    
    //Select gender gesture
    @objc func selectGender(sender : UITapGestureRecognizer) {
        genderDropDown.show()
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        genderDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            let indexValue = "\(item) "
            switch index {
            case 0:
                weak.genderSelectedLabel.text = indexValue
                weak.genderSelectedLabel.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
                weak.gender = indexValue
                weak.genderLabel.isHidden = false
            case 1:
                weak.genderSelectedLabel.text = indexValue
                weak.genderSelectedLabel.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
                weak.gender = indexValue
                weak.genderLabel.isHidden = false
                
            default:
                print("Error in selection")
            }
        }
    }
    
    //Select Country gesture
    @objc func selectCountry(sender : UITapGestureRecognizer) {
        countriesDropDown.show()
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        countriesDropDown.selectionAction = { [unowned self] (index: Int, item: String) in
            let indexValue = "\(item) "
            switch index {
            case 0:
                weak.countrySelectedLabel.text = indexValue
                weak.countrySelectedLabel.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
                weak.country = indexValue
                weak.countryLabel.isHidden = false
            case 1:
                weak.countrySelectedLabel.text = indexValue
                weak.countrySelectedLabel.textColor = #colorLiteral(red: 0.568627451, green: 0.568627451, blue: 0.568627451, alpha: 1)
                weak.country = indexValue
                weak.countryLabel.isHidden = false
                
            default:
                print("Error in selection")
            }
        }
    }
    
    // Select date gesture
    @objc func datePickerValueChanged(sender: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateTextField.text = dateFormatter.string(from: sender.date)

    }
    
 
    
    
    
    
    
}
