//
//  ValidateCodeHostController.swift
//  Tugo
//
//  Created by Alex on 4/10/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Alamofire
import AVFoundation

class ValidateCodeHostController: UIViewController, AVSpeechSynthesizerDelegate{

    // MARK: - Let-Var
    let codePendient = Singleton.shared.checkisBool(key: K.defaultKeys.Auth.Host.pendingState)
    
    open var header: HTTPHeaders{
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let bearer = Core.shared.setBearerToken(token)
        return ["Authorization": bearer]
    }
    
    // MARK: - Outlets
    @IBOutlet weak var codeTextfield: UITextField!
    @IBOutlet weak var accountButton: UIButton!
    
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        let utterance = AVSpeechUtterance(string:"Ahora verifiquemos tu correo!")
        utterance.voice = AVSpeechSynthesisVoice(language: "es-MX")

        let voice = AVSpeechSynthesizer()
        voice.delegate = self
        voice.speak(utterance)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
 
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Setting background gradient
        Core.shared.settinGradientHost(at: accountButton)
        
    }
    
    func setUpActions(){}
    
    
    
    @IBAction func validateCode(_ sender: UIButton) {
        guard let code = codeTextfield.text, !code.isEmpty else{
            Core.shared.alert(message: "Debes ingresar un código", title: "Error", at: self)
            return
        }
        
        settingCode(code: code)
    }
    
    private func settingCode(code: String){
        
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        let params: Parameters =  ["activation_code":code]
        
        HostManager().activateAccount(header: header, params: params) {
            activate in
            guard let activate = activate else{
                Core.shared.alert(message: "Sucedio un problema registrando el código", title: "Error", at: weak)
                return
            }
            print(activate)
            Singleton.shared.removeDefault(toRemove: K.defaultKeys.Auth.Host.pendingState)
            Singleton.shared.saveHostIncompleteStatus(true)
            weak.performSegue(withIdentifier: K.segues.AuthHost.validateCodeToHostInformation, sender: weak)
            
        }
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        if codePendient{
            performSegue(withIdentifier: K.segues.AuthHost.validateCodeToMain, sender: nil)
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    
    // MARK: - Objective C
    

}
