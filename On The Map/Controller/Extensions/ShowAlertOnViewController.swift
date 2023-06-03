//
//  ShowAlertExtension.swift
//  On The Map
//
//  Created by Ademola Fadumo on 03/06/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showLoginFailure(title: String, message: String) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated: true)
    }
}
