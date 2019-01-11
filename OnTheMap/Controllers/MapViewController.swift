//
//  MapViewController.swift
//  OnTheMap
//
//  Created by MAC on 04/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: SharedViewController, MKMapViewDelegate {

    var networkObjectSub = NetworkMethod()
    var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super .viewWillAppear(animated)
        networkObjectSub.getStudentLocation { (success, message, error) in
            if success == true {
                let locationsArray = AllStudentLocations.studentsLocations
                
                for oneLocation in locationsArray {
                    
                    let lat = CLLocationDegrees(oneLocation.latitude )
                    let long = CLLocationDegrees(oneLocation.longitude)
                    
                    let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
                    
                    let firstName = oneLocation.firstName
                    let lastName = oneLocation.lastName
                    let mediaURL = oneLocation.mediaURL
                    
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = "\(firstName) \(lastName)"
                    annotation.subtitle = mediaURL
                    
                    self.annotations.append(annotation)
                }
                DispatchQueue.main.async {
                 self.mapView.addAnnotations(self.annotations)
                }
            }else {
                if error != nil || !message.isEmpty {
                    self.showAlert(message: "Failed to download students locations")
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            if let toOpen = view.annotation?.subtitle! {
               UIApplication.shared.open(NSURL(string: toOpen)! as URL)
            }
        }
    }
    
    override func refreshTapped() {
        mapView.reloadInputViews()
    }
}
