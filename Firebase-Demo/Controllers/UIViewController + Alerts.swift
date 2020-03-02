//
//  UIViewController.swift
//  Firebase-Demo
//
//  Created by Christian Hurtado on 3/2/20.
//  Copyright © 2020 Alex Paul. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    public func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
}
