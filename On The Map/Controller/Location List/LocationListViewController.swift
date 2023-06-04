//
//  LocationListViewController.swift
//  On The Map
//
//  Created by Ademola Fadumo on 25/05/2023.
//

import Foundation
import UIKit

class LocationListViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkClient.getStudentLocations { studentLocations, error in
            if let _ = error {
                self.showUIAlertView(title: "Fetch Failed", message: "Error fetching student locations")
                
                return
            }
            
            StudentModel.studentLocations = studentLocations
            
            self.tableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StudentLocation") as! StudentLocationTableViewCell
        
        cell.studentName.text = StudentModel.studentLocations[indexPath.row].firstName + " " + StudentModel.studentLocations[indexPath.row].lastName
        cell.studentURL.text = StudentModel.studentLocations[indexPath.row].mediaURL
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentModel.studentLocations.count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var urlString = StudentModel.studentLocations[indexPath.row].mediaURL
        
        
        if !urlString.contains("https") {
            urlString = "https://" + urlString
        }
        
        let url = URL(string: urlString)
        if let url = url {
            DispatchQueue.main.async {
                UIApplication.shared.open(url)
            }
        }
    }
}
