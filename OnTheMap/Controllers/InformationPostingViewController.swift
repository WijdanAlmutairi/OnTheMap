//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by MAC on 08/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit
import CoreLocation

class InformationPostingViewController: UIViewController {

    var lat = 0.0
    var lon = 0.0
    
    var myKeyboard = Keyboard()
     var activityView = UIActivityIndicatorView(style: .gray)
    
    @IBOutlet weak var mapString: UITextField!
    @IBOutlet weak var urlLink: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myKeyboard.configureTextField(textField: mapString!)
        myKeyboard.configureTextField(textField: urlLink!)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        myKeyboard.subscribeToKeyboardNotifications()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        myKeyboard.unsubscribeFromKeyboardNotifications()
    }

    @IBAction func findLocationPressed(_ sender: Any) {
        showActivityIndicatory()
        guard !mapString.text!.isEmpty, !urlLink.text!.isEmpty else {
            self.showAlert(message: "Loacation or Link fields are empty")
            print("Loacation or Link fields are empty ")
            return
        }
        convertToLocation(address: mapString.text!) { (success, message, error) in
            if success == true {
                DispatchQueue.main.async {
                    self.activityView.stopAnimating()
                    self.performSegue(withIdentifier: "sendLocation", sender: self)
                }
            }
        }
   
       
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let locationVc = segue.destination as! LocationViewController
        locationVc.location = CLLocationCoordinate2D(latitude: self.lat, longitude: self.lon)
        locationVc.mapString = mapString.text!
        locationVc.urlLink = urlLink.text!
    }
    func convertToLocation(address: String?, completionHandler: @escaping (_ result: Bool, _ message: String, _ error: Error?)->()){
        let geoCoder = CLGeocoder()
        if let mapString = address {
            geoCoder.geocodeAddressString(mapString) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        self.showAlert(message: "Cannot Find Location")
                        print("Cannot Find Location")
                        completionHandler(false, "Cannot Find Location", error)
                        return
                }
                
                self.lat = location.coordinate.latitude
                self.lon = location.coordinate.longitude
                if(self.lat != 0.0 && self.lon != 0.0){
                    completionHandler(true, "", nil)}
                
            }
        }
    }
    
    @IBAction func cancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    func showActivityIndicatory() {
        activityView.center = self.view.center
        activityView.startAnimating()
        self.view.addSubview(activityView)
    }
    
}
