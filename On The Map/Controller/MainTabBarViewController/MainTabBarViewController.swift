//
//  MainTabBarViewController.swift
//  On The Map
//
//  Created by Ademola Fadumo on 01/06/2023.
//

import UIKit

class MainTabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LOGOUT", style: .plain, target: self, action: #selector(logout))
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: Symbols.add, style: .plain, target: self, action: #selector(addNewLocation))
        self.navigationItem.title = "On the Map"
    }
    
    @objc func logout() {
        NetworkClient.logout()
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
        }
    }
    
    @objc func addNewLocation() {
        let addLocationFormVC = storyboard?.instantiateViewController(withIdentifier: "AddLocationFormViewController")
        navigationController?.pushViewController(addLocationFormVC!, animated: true)
    }
}
