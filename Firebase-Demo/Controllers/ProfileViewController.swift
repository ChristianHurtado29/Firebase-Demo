//
//  ProfileViewController.swift
//  Firebase-Demo
//
//  Created by Christian Hurtado on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import FirebaseAuth
import Kingfisher

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    private var selectedImage: UIImage?{
        didSet{
            DispatchQueue.main.async {
                self.profileImageView.image = self.selectedImage
            }
        }
    }
    
    private let storageService = StorageService()
    
    private lazy var imagePickerController: UIImagePickerController = {
        let ip = UIImagePickerController()
        ip.delegate = self
        return ip
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        displayNameTextField.delegate = self
        updateUI()
        
    }
    
    private func updateUI(){
         guard let user = Auth.auth().currentUser else {
                    return
                }
                displayNameTextField.text = user.displayName
                emailLabel.text = user.email
                profileImageView.kf.setImage(with: user.photoURL)
                //user.email
                //user.phoneNumber
        //        user.photoURL
               
            }
    
    
    @IBAction func updateButton(_ sender: UIButton) {
        // change the user's display name
        guard let user = Auth.auth().currentUser else {
                           return
                       }
        
        guard let displayName = displayNameTextField.text,
            !displayName.isEmpty,
            let selectedImage = selectedImage else {
                print("missing fields")
                return
        }
        
        // resize image before uploading to Firebase
        let resizedImage = UIImage.resizeImage(originalImage: selectedImage, rect: profileImageView.bounds)
        
        print("original image size: \(selectedImage.size)")
        print("resized image size: \(resizedImage)")
        
        // TODO:
        // call storageService.upload
        storageService.uploadPhoto(userId: user.uid, image: resizedImage) {[weak self] (result) in
            // code here to add the photoURL to the user's photoURL property then commit changes
            switch result {
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.showAlert(title: "Error", message: "Could not update photo \(error.localizedDescription)")
                }
            case .success(let url):
                let request = Auth.auth().currentUser?.createProfileChangeRequest()
                    request?.displayName = displayName
                    request?.photoURL = url
                    request?.commitChanges(completion: { [unowned self] (error) in
                        if let error = error {
                            DispatchQueue.main.async {
                            self?.showAlert(title: "Profile Change", message: "Error changing profile: \(error.localizedDescription)")
                            }
                        } else {
                            print("profile successfully updated")
                            self?.showAlert(title: "Profile Update", message: "Profile successfully updated 🥳.")
                        }
                })
            }
        }
    
        
        
    }
    
    @IBAction func editProfilePhotoButtonPressed(_ sender: UIButton) {
        let alertController = UIAlertController(title: "Choose Photo Option", message: nil, preferredStyle: .actionSheet)
        let cameraAction = UIAlertAction(title: "Camera", style: .default) {
            alertAction in
            self.imagePickerController.sourceType = .camera
            self.present(self.imagePickerController, animated: true)
        }
        let photoLibraryAction = UIAlertAction(title: "Photo Library", style: .default){
            alertAction in
            self.imagePickerController.sourceType = .photoLibrary
            self.present(self.imagePickerController, animated: true)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        if UIImagePickerController.isSourceTypeAvailable(.camera){
        alertController.addAction(cameraAction)
        }
        alertController.addAction(photoLibraryAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true)
        
    }
    
    
    @IBAction func signOutButtonPressed(_ sender: UIButton) {
        do{
            try Auth.auth().signOut()
            UIViewController.showViewController(storyboardName: "LoginView", viewControllerId: "LoginViewController")
        } catch {
            DispatchQueue.main.async {
                self.showAlert(title: "Error signing out", message: "\(error.localizedDescription)")
            }
        }
    }

}

extension ProfileViewController: UITextFieldDelegate{
    override func resignFirstResponder() -> Bool {
        return true
    }
}

extension ProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            return
        }
        selectedImage = image
        dismiss(animated: true)
    }
    
}
