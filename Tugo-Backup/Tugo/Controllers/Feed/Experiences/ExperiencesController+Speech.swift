//
//  ExperiencesController+Speech.swift
//  Tugo
//
//  Created by Alex on 6/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import Speech

extension ExperiencesController: SFSpeechRecognizerDelegate{
    
    
    //MARK: - Check Authorization Status for Speech
    func requestSpeechAuthorization() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.speechButton.isEnabled = true
                case .denied:
                    self.speechButton.isEnabled = false
                    print("User denied access to speech recognition")
                    
                case .restricted:
                    self.speechButton.isEnabled = false
                    print("Speech recognition restricted on this device")
                    
                case .notDetermined:
                    self.speechButton.isEnabled = false
                    print("Speech recognition not yet authorized")
                }
            }
        }
    }
    
    
    
    //MARK: - Recognize Speech
    func recordAndRecognizeSpeech() {
        
        let recordingFormat = audioEngine.inputNode.outputFormat(forBus: 0)
        audioEngine.inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            Core.shared.alert(message: "There has been an audio engine error.", title: "Error", at: self)
            return print(error)
        }
        guard let myRecognizer = SFSpeechRecognizer() else {
            
            Core.shared.alert(message: "Speech recognition is not supported for your current locale.", title: "Error", at: self)
            
            return
        }
        if !myRecognizer.isAvailable {
            
            Core.shared.alert(message: "Speech recognition is not currently available. Check back at a later time.", title: "Error", at: self)
            // Recognizer is not available right now
            return
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { result, error in
            if let result = result {
                
                let bestString = result.bestTranscription.formattedString
              
                if let textfield = self.searchBar.value(forKey: "searchField") as? UITextField {
                    textfield.text = "\(bestString)"
                    textfield.sendActions(for: UIControlEvents.editingChanged)
                    self.resultsearchTableView.isHidden = false
                    self.resultsearchTableView.isUserInteractionEnabled = true
                }
                
            } else if let error = error {
                print(error)
            }
        })
    }
    
    
}
