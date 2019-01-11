//
//  SharedViewController.swift
//  OnTheMap
//
//  Created by MAC on 04/01/2019.
//  Copyright © 2019 Dan. All rights reserved.
//

import UIKit

class SharedViewController: UIViewController {

    static var appDelegate: AppDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        SharedViewController.appDelegate = UIApplication.shared.delegate as? AppDelegate
        
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
        print("Refresh")
    }
    
    @objc func logoutTapped(){
        
        var request = URLRequest(url: SharedViewController.appDelegate.udacityURLFromParameter([:]))
        
        request.httpMethod = "DELETE"
        var xsrfCookie: HTTPCookie? = nil
        
        let sharedCookieStorage = HTTPCookieStorage.shared
        for cookie in sharedCookieStorage.cookies! {
            if cookie.name == "XSRF-TOKEN" { xsrfCookie = cookie }
        }
        if let xsrfCookie = xsrfCookie {
            request.setValue(xsrfCookie.value, forHTTPHeaderField: "X-XSRF-TOKEN")
        }
        let task = SharedViewController.appDelegate.sharedSession.dataTask(with: request) { data, response, error in
            guard (error == nil) else {
                print ("There was an error with your request: \(error!)")
                return
            }
            
            let range = (5..<data!.count)
            _ = data?.subdata(in: range) /* subset response data! */
            SharedViewController.appDelegate.sessionID = ""
            DispatchQueue.main.async {
                let loginController = self.storyboard?.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
                self.present(loginController, animated: true, completion: nil)
            }
            
        }
        task.resume()
        
    }
}

