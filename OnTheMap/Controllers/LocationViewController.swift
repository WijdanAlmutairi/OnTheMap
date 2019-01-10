//
//  LocationViewController.swift
//  OnTheMap
//
//  Created by MAC on 08/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, MKMapViewDelegate {
    
    var mapString: String = ""
    var urlLink: String = ""
    var annotations = [MKPointAnnotation]()
    var location: CLLocationCoordinate2D?{
        didSet{
            print("location is \(location)")
        }
    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("map \(mapString)  link \(urlLink)")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("location is \(location)")
        placeAPin()
        //print("\(location?.latitude)")
    }
    
    
    func placeAPin(){
        let annotation = MKPointAnnotation()
        if let location = location {
        annotation.coordinate = location
        annotation.title = "Dan Cooper"
        annotation.subtitle = urlLink
        
    self.annotations.append(annotation)
    
    self.mapView.addAnnotations(self.annotations)
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
            //let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                UIApplication.shared.open(NSURL(string: toOpen)! as URL)
            }
        }
    }
}
