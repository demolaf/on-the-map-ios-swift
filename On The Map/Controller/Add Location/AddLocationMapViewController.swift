//
//  AddLocationMapViewController.swift
//  On The Map
//
//  Created by Ademola Fadumo on 25/05/2023.
//

import Foundation
import UIKit
import MapKit

class AddLocationMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var loadingView: UIView!
    
    var locationText: String!
    var linkText: String!
    var annotation: MKAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Add Location"
        
        searchForLocation()
    }
    
    @IBAction func finishButtonPressed(_ sender: UIButton?) {
        NetworkClient.addStudentLocation(mapString: locationText, mediaURL: linkText, latitude: annotation.coordinate.latitude.magnitude, longitude: annotation.coordinate.longitude.magnitude) { success, error in
            if success {
                let mainTabBarController = self.storyboard?.instantiateViewController(withIdentifier: "MainTabBarController")
                self.navigationController?.pushViewController(mainTabBarController!, animated: true)
                
            } else {
                self.showUIAlertView(title: "Failed", message: "Error storing your location")
            }
        }
    }
    
    private func searchingForLocation(_ isSearching: Bool) {
        DispatchQueue.main.async {
            self.loadingView.isHidden = !isSearching
        }
    }
    
    private func searchForLocation() {
        let request = MKLocalSearch.Request()
        
        request.naturalLanguageQuery = locationText
        request.region = mapView.region
        
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            self.searchingForLocation(true)
            
            if let _ = error {
                self.searchingForLocation(false)
                self.showUIAlertView(title: "Search Failed", message: "Error searching entered location")
                return
            }
            
            guard let response = response else { return }
            
            let placemark = response.mapItems[0].placemark
            
            let annotation = MKPointAnnotation()
            
            annotation.coordinate = placemark.coordinate
            annotation.title = UserPublicData.getUserFullName()
            annotation.subtitle = self.linkText
            
            var coordinate = MKCoordinateRegion()
            coordinate.center = annotation.coordinate
            
            DispatchQueue.main.async {
                self.mapView.setRegion(coordinate, animated: true)
                self.mapView.addAnnotation(annotation)
                
                self.annotation = annotation
            }
            
            self.searchingForLocation(false)
        }
    }
}
