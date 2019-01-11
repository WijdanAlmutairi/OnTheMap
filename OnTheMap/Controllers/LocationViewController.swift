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
    
    var networkObject = NetworkMethod()
    var mapString: String?
    var urlLink: String?
    
    var annotations = [MKPointAnnotation]()
    var location: CLLocationCoordinate2D!//{
//        didSet{
//            print("location is \(location)")
//        }
//    }
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //mapView.reloadInputViews()
        print("location is \(String(describing: location))")
        if location?.latitude  != 0.0 && location?.longitude != 0.0 {

            placeAPin()
        }
    }
    
    
    func placeAPin(){
        let annotation = MKPointAnnotation()
        if let location = location{
            if let urlLink = urlLink{
        annotation.coordinate = location
        annotation.title = "Dan Cooper"
        annotation.subtitle = urlLink
        
        self.annotations.append(annotation)

        self.mapView.addAnnotations(self.annotations)

        
          }
        }
    }
    
    @IBAction func finishPressed(_ sender: Any) {
        if let mapString = mapString, let urlLink = urlLink  {
            if let lat = location?.latitude, let lon =  location?.longitude {
               let studentLocation =  createStudentObject(lat: lat, lon: lon, mapString: mapString, urlLink: urlLink)
                networkObject.postStudentLocation(studentLocation: studentLocation) { (success, message, error) in
                    if success == true {
                        self.dismiss(animated: true, completion: nil)
                    }else {
                        if error != nil || message.isEmpty {
                            self.showAlert(message: "Could not post your location")
                        }
                    }
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
    
    func createStudentObject (lat: Double, lon: Double, mapString: String, urlLink: String) -> StudentInformation{
           let studentObject = StudentInformation(createdAt: "", firstName: "Dan", lastName: "Cooper", latitude: lat, longitude: lon, mapString: mapString, mediaURL: urlLink, objectId: "", uniqueKey: (networkObject.appDelegate?.UserID)!, updatedAt: "")
        return studentObject
    }
}
