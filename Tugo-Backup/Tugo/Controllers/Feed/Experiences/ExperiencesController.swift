//
//  ExperiencesController.swift
//  Tugo
//
//  Created by Alex on 21/8/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import UIKit
import Speech
import Hero
import HexColors
import Alamofire


class ExperiencesController: UIViewController,UISearchBarDelegate,UITextFieldDelegate {

    // MARK: - Let-Var
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "es_SV")) 
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    var isRecording = false
    var text = String()
    var experiences = Search()
    var selectedExperience:SearchElement?
    
    open var header: HTTPHeaders{
        let tokenHost = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.Host.accessToken)
        let token = Singleton.shared.checkValueSet(key: K.defaultKeys.Auth.accessToken)
        let setToken = !tokenHost.isEmpty ? tokenHost : token
        let bearer = Core.shared.setBearerToken(setToken)
        return ["Authorization": bearer]
    }
    
    // MARK: - Outlets
   
    @IBOutlet weak var resultsearchTableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var speechButton: UIButton!
 
    // MARK: - LifeCycles
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setting up UI elements to be used through the code
        setUpUI()
        
        // setting up general actions/delegates/Core
        setUpActions()
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == K.segues.FeedStoryBoard.searchToDetailContrioller {
            let detailController = segue.destination as! DetailsController
            detailController.selectedExperience = selectedExperience
        }
        
        if segue.identifier == K.segues.FeedStoryBoard.searchToDetailContriollerBigger {
            let detailController = segue.destination as! DetailsController
            detailController.selectedExperience = selectedExperience
        }
        
    }
    
    // MARK: - SetUps / Funcs
    func setUpUI(){
        //Searchbar
        for view in searchBar.subviews.last!.subviews {
            if type(of: view) == NSClassFromString("UISearchBarBackground"){
                view.alpha = 0.0
            }
        }
        
        if let textfield = searchBar.value(forKey: "searchField") as? UITextField {
            textfield.backgroundColor = HexColor(K.colors.searchBarBackground)
            textfield.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        }
        
        
        
    }
    
    func setUpActions(){
        //Searchbar
        searchBar.becomeFirstResponder()
        searchBar.delegate = self
        
        //Tableview Delegate
        resultsearchTableView.delegate = self
        resultsearchTableView.dataSource = self
        
        //Set Cell Identifier
        Core.shared.registerCell(at: resultsearchTableView, named: K.cells.table.searchTableCell)
        
        
        //Requesting speech
        requestSpeechAuthorization()
        
        //Setting Hero
        self.hero.isEnabled = true
        self.hero.modalAnimationType = .cover(direction: .up)
        
        
    }

    private func searchExperiences(_ term: String){
        weak var weakSelf = self
        guard let weak = weakSelf else{return}
        experiences.removeAll()
        
        let params:Parameters = ["page": 1, "per_page": 25, "term": term]
        ExperiencesManager().getExperienceSearch(header: header, params: params) {
            search in
            guard let search = search else{
              
                return
            }
            
            if search.count > 0{
                weak.experiences = search
                
                weak.resultsearchTableView.reloadData()
            }
        }
    }
    
    // MARK: - Objective C
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if !searchText.isEmpty {
            
           self.resultsearchTableView.isHidden = false
           self.resultsearchTableView.isUserInteractionEnabled = true
           searchExperiences(searchText.lowercased())
            
        } else {
            
            self.resultsearchTableView.isHidden = true
            self.resultsearchTableView.isUserInteractionEnabled = false
        }
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        searchBar.endEditing(true)
    }

    @IBAction func startButtonTapped(_ sender: UIButton) {
        if isRecording == true {
            audioEngine.stop()
            recognitionTask?.cancel()
            isRecording = false
            speechButton.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
            audioEngine.inputNode.removeTap(onBus: 0)
        } else {
            self.recordAndRecognizeSpeech()
            isRecording = true
            speechButton.setImage(#imageLiteral(resourceName: "micactive"), for: .normal)
        }
    }
    
    @IBAction func closeModalAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Objective C
    @objc func textFieldDidChange(_ textField: UITextField) {}

  
    
}
