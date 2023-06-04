//
//  LocationMapViewController.swift
//  On The Map
//
//  Created by Ademola Fadumo on 25/05/2023.
//

import Foundation
import UIKit
import MapKit

class LocationMapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.mapView.reloadInputViews()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NetworkClient.getStudentLocations { studentLocations, error in
            if let _ = error {
                self.showUIAlertView(title: "Fetch Failed", message: "Error fetching student locations")
                
                return
            }
            
            StudentModel.studentLocations = studentLocations
            
            var annotations = [MKPointAnnotation]()
            
            for location in StudentModel.studentLocations {
                let lat = CLLocationDegrees(location.latitude)
                let long = CLLocationDegrees(location.longitude)
                
                let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                
                let annotation = MKPointAnnotation()
                
                annotation.coordinate = coordinate
                annotation.title = location.firstName + " " + location.lastName
                annotation.subtitle = location.mediaURL
                
                annotations.append(annotation)
            }
            
            self.mapView.addAnnotations(annotations)
        }
    }
    
    // Here we create a view with a "right callout accessory view". You might choose to look into other
    // decoration alternatives. Notice the similarity between this method and the cellForRowAtIndexPath
    // method in TableViewDataSource.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKMarkerAnnotationView

        if pinView == nil {
            pinView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView?.canShowCallout = true
            pinView?.markerTintColor = .red
            pinView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView?.annotation = annotation
        }
        
        return pinView
    }
    
    // This delegate method is implemented to respond to taps. It opens the system browser
    // to the URL specified in the annotationViews subtitle property.
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }
        }
    }
}
