//
//  ProfileViewController.swift
//  Firebase-Demo
//
//  Created by Christian Hurtado on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import UIKit
import FirebaseAuth

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var profileImageView: UIImageView!
    
    @IBOutlet weak var displayNameTextField: UITextField!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    
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
                // user.displayName
                //user.email
                //user.phoneNumber
        //        user.photoURL
               
            }
    
    
    @IBAction func updateButton(_ sender: UIButton) {
        // change the user's display name
        
        guard let displayName = displayNameTextField.text,
            !displayName.isEmpty else {
                print("missing fields")
                return
        }
        
        let request = Auth.auth().currentUser?.createProfileChangeRequest()
        
        request?.displayName = displayName
        
        request?.commitChanges(completion: { [unowned self] (error) in
            if let error = error {
                // TODO: show alert
                self.showAlert(title: "Profile Change", message: "Error changing profile: \(error)")
            } else {
                print("profile successfully updated")
                self.showAlert(title: "Profile Update", message: "Profile successfully updated.")
            }
    })
    }

}

extension ProfileViewController: UITextFieldDelegate{
    override func resignFirstResponder() -> Bool {
        return true
    }
}
