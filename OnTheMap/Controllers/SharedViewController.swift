//
//  SharedViewController.swift
//  OnTheMap
//
//  Created by MAC on 04/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class SharedViewController: UIViewController {

     var networkObject = NetworkMethod()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "On the Map"
        
        //Add two right bar items
        let addBarButton = UIBarButtonItem(image: UIImage(named: "icon_addpin"), style: .plain, target: self, action: #selector(addTapped))
        
        let refreshBarButton = UIBarButtonItem(image: UIImage(named: "icon_refresh"), style: .plain, target: self, action: #selector(refreshTapped))
        
        self.navigationItem.rightBarButtonItems = [addBarButton, refreshBarButton]
        
        //Add the left bar item
        let logoutBarButton = UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(logoutTapped))
        
        self.navigationItem.leftBarButtonItem = logoutBarButton
        
    }
    
    @objc func addTapped(){
        let AddToMapVc = self.storyboard?.instantiateViewController(withIdentifier: "AddToMap") as! UINavigationController
        self.present(AddToMapVc, animated: true, completion: nil)
    }
    
    @objc func refreshTapped(){
        //implementation in child class TableViewController and MapViewController
    }
    
    @objc func logoutTapped(){
        networkObject.logout { (success, message, error) in
            if success == true {
                DispatchQueue.main.async {
                    self.dismiss(animated: true, completion: nil)

                }
            }
        }
        
    }
}

