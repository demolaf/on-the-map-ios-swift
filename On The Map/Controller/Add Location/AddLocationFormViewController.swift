//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Ademola Fadumo on 25/05/2023.
//

import Foundation
import UIKit

class AddLocationFormViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.hidesBackButton = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancel))
        
        navigationItem.title = "Add Location"
    }
    
    @objc func cancel() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {
        guard let locationText = locationTextField.text, locationTextField.hasText else { return }
        
        guard let linkText = linkTextField.text, linkTextField.hasText else { return }
        
        let addLocationMapVC = storyboard?.instantiateViewController(withIdentifier: "AddLocationMapViewController") as! AddLocationMapViewController
        
        addLocationMapVC.locationText = locationText
        addLocationMapVC.linkText = linkText
        
        navigationController?.pushViewController(addLocationMapVC, animated: true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        return true
    }
}
