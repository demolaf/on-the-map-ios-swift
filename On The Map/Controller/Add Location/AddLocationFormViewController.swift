//
//  AddLocationViewController.swift
//  On The Map
//
//  Created by Ademola Fadumo on 25/05/2023.
//

import Foundation
import UIKit

class AddLocationFormViewController: UIViewController {
    
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var linkTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = true
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CANCEL", style: .plain, target: self, action: #selector(cancel))
        
        self.navigationItem.title = "Add Location"
    }
    
    @objc func cancel() {
        if let navigationController = navigationController {
            navigationController.popViewController(animated: true)
        }
    }
    
    @IBAction func findLocationButtonPressed(_ sender: UIButton) {
        guard let locationText = self.locationTextField.text, self.locationTextField.hasText else { return }
        
        guard let linkText = self.linkTextField.text, self.linkTextField.hasText else { return }
        
        let addLocationMapVC = storyboard?.instantiateViewController(withIdentifier: "AddLocationMapViewController") as! AddLocationMapViewController
        
        addLocationMapVC.locationText = locationText
        addLocationMapVC.linkText = linkText
        
        navigationController?.pushViewController(addLocationMapVC, animated: true)
    }
    
    
}
