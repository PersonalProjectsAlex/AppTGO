//
//  ProfileController+ImagePickerDelegate.swift
//  Tugo
//
//  Created by Alex on 27/9/18.
//  Copyright © 2018 Tugo. All rights reserved.
//

import Foundation
import UIKit
import FirebaseCore
import Firebase
import Alamofire
import SDWebImage


extension ProfileController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    //Alert option for changing photo
    func showInputDialog() {
        
        //Creating UIAlertController and
        //Setting title and message for the alert dialog
        let alertController = UIAlertController(title: "Cambiar", message: "¿Deseas cambiar tu fotografía?", preferredStyle: .alert)
        
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Cambiar", style: .default) { (_) in
            
            
            let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Camara", style: .default, handler: {
                action in
                self.picker.sourceType = .camera
                self.picker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.present(self.picker, animated: true, completion: nil)
            }))
            alert.addAction(UIAlertAction(title: "Seleccionar fotografia", style: .default, handler: {
                action in
                self.picker.sourceType = .photoLibrary
                self.picker.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
                self.present(self.picker, animated: true, completion: nil)
            }))
            
            alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancelar", style: .cancel) { (_) in }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        present(alertController, animated: true, completion: nil)
    }
    
    //setting image selected
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        var selectedImageFromPicker: UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage{
            selectedImageFromPicker = editedImage
        }else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage{
            selectedImageFromPicker = originalImage
        }
        if let selectedImage = selectedImageFromPicker{
           
            profileImageView.image = selectedImage
            
            changeImage()
        
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    
    
    //Storage and change image
    func changeImage(){
        var imageName: String?
        if  let firCurrentuser = FIRAuth.auth()?.currentUser, FIRAuth.auth()?.currentUser != nil{
            let userID = firCurrentuser.uid
            imageName = userID
            
        }else{
            imageName = "\(UUID().uuidString.lowercased())"
        }
        
        let storage = FIRStorage.storage().reference()
        guard let image = imageName else{return}
        print(image)
        let storedImage = storage.child("avatars").child(image)
        if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.8)
        {
            let metaData = FIRStorageMetadata()
            metaData.contentType = "image/jpg"
            storedImage.put(uploadData, metadata: metaData, completion: { (metadata, error) in
                if error != nil{
                    print(error!)
                    
                    return
                }
                
                storedImage.downloadURL(completion: { (url, error) in
                    if error != nil{
                        print(error!)
                        return
                    }else{
                        
                        guard let photo = metadata?.downloadURL()?.absoluteString else {
                            Core.shared.alert(message: "Sucedio un error con esta imagen intente de nuevo", title: "Sucedio algo:", at: self)
                            return
                        }
                        let params:Parameters = ["avatar":photo]
                        self.updateInfo(params: params)
                        
                    }
                })
                
            })
        }
    }
    
}
